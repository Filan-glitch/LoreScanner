import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../core/constants.dart';
import '../../core/logging.dart';
import 'card_matcher.dart';
import 'match_index.dart';
import 'ocr_parser.dart';
import 'roi_mapper.dart';
import 'scan_metrics.dart';
import 'scan_state.dart';

/// Live progress report from one processed frame.
class ScanProgress {
  const ScanProgress({
    required this.phase,
    this.trackingCardId,
    this.trackingLanguage,
    this.trackingHits = 0,
  });

  final ScanPhase phase;
  final int? trackingCardId;
  final String? trackingLanguage;
  final int trackingHits;
}

/// Drives the continuous scan pipeline:
/// camera stream → ML Kit (native thread) → parse+match (compute isolate)
/// → stability tracking → [ScanDetected] with quick-confirm.
///
/// ML Kit is a platform-channel plugin, so `processImage` cannot move into a
/// Dart isolate — but it already runs on a native background thread. Only
/// the Dart-side CPU work (parsing + Levenshtein) goes through `compute()`.
class ScanController {
  ScanController({
    required this.onDetected,
    required this.onProgress,
    required this._indexProvider,
  });

  final void Function(MatchResult result) onDetected;
  final void Function(ScanProgress progress) onProgress;
  final MatchIndex Function() _indexProvider;

  CameraController? camera;
  final TextRecognizer _recognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  /// Rolling per-stage timings for tuning; read by the debug overlay.
  final ScanMetrics metrics = ScanMetrics();

  bool _busy = false;
  int _frameCount = 0;
  DateTime _lastFrameAt = DateTime.fromMillisecondsSinceEpoch(0);
  (int, String)? _trackedCard;
  int _trackedHits = 0;
  int _trackedMisses = 0;
  ScanPhase _lastPhase = ScanPhase.searching;
  final Map<(int, String), DateTime> _cooldowns = {};

  /// Preview widget size, fed from the page's LayoutBuilder — drives the
  /// ROI mapping so overlay and matcher share one geometry.
  Size widgetSize = Size.zero;

  Future<void> start() async {
    if (camera != null) return;
    final cameras = await availableCameras();
    if (cameras.isEmpty) throw StateError('Keine Kamera gefunden');
    final back = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    // Resolution does not move OCR time on-device (480p 629ms vs 720p
    // 643ms — ML Kit cost is fixed, not pixel-bound), so keep high for
    // footer legibility.
    final controller = CameraController(
      back,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: defaultTargetPlatform == TargetPlatform.android
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    await controller.initialize();
    camera = controller;
    await controller.startImageStream(_onFrame);
  }

  Future<void> stop() async {
    final controller = camera;
    camera = null;
    if (controller != null) {
      try {
        if (controller.value.isStreamingImages) {
          await controller.stopImageStream();
        }
      } finally {
        await controller.dispose();
      }
    }
    _resetTracking();
  }

  Future<void> dispose() async {
    try {
      await stop();
    } finally {
      await _recognizer.close();
    }
  }

  void _resetTracking() {
    _trackedCard = null;
    _trackedHits = 0;
    _trackedMisses = 0;
  }

  /// Puts a just-confirmed card on cooldown so the next frames don't
  /// immediately re-detect it.
  void cooldown(int cardId, String language) {
    _cooldowns[(cardId, language)] = DateTime.now().add(scanCardCooldown);
    _resetTracking();
  }

  void _emit(ScanPhase phase) {
    // Only notify on actual change to keep rebuilds sparse — tracking
    // updates always go through (hit count changes).
    if (phase == _lastPhase && phase != ScanPhase.tracking) return;
    _lastPhase = phase;
    onProgress(ScanProgress(
      phase: phase,
      trackingCardId: _trackedCard?.$1,
      trackingLanguage: _trackedCard?.$2,
      trackingHits: _trackedHits,
    ));
  }

  Future<void> _onFrame(CameraImage image) async {
    final now = DateTime.now();
    if (_busy || now.difference(_lastFrameAt) < scanFrameInterval) return;
    if (widgetSize == Size.zero) return;
    _busy = true;
    _lastFrameAt = now;
    try {
      final result = await _analyzeFrame(image);
      _track(result);
    } catch (e, st) {
      log.warning('Frame analysis failed', e, st);
    } finally {
      _busy = false;
    }
  }

  Future<MatchResult?> _analyzeFrame(CameraImage image) async {
    final controller = camera;
    if (controller == null) return null;

    final stopwatch = Stopwatch()..start();
    final rotationDegrees = controller.description.sensorOrientation;
    final inputImage = _toInputImage(image, rotationDegrees);
    if (inputImage == null) return null;
    final inputMs = stopwatch.elapsedMilliseconds;

    stopwatch.reset();
    final recognized = await _recognizer.processImage(inputImage);
    final ocrMs = stopwatch.elapsedMilliseconds;

    stopwatch.reset();
    final sensorSize = Size(image.width.toDouble(), image.height.toDouble());
    final uprightSize = RoiMapper.uprightSize(sensorSize, rotationDegrees);
    final mapper =
        RoiMapper(widgetSize: widgetSize, uprightImageSize: uprightSize);
    final imageRoi = mapper.widgetToImage(cardRoi(widgetSize));

    // ML Kit applies the rotation metadata itself: boxes arrive already in
    // the upright frame (verified on Pixel 9a).
    final lines = <OcrLine>[
      for (final block in recognized.blocks)
        for (final line in block.lines)
          OcrLine(line.text, line.boundingBox),
    ];
    final parsed = parseOcrLines(lines, imageRoi);
    final parseMs = stopwatch.elapsedMilliseconds;

    if (parsed.nameCandidates.isEmpty && parsed.footer == null) {
      metrics.add(FrameTiming(
          inputMs: inputMs, ocrMs: ocrMs, parseMs: parseMs, matchMs: 0));
      _logMetricsPeriodically();
      _emit(lines.isEmpty ? ScanPhase.searching : ScanPhase.reading);
      return null;
    }

    _emit(ScanPhase.matching);
    stopwatch.reset();
    final result = await compute(
        matchCards, MatchInput(parsed: parsed, index: _indexProvider()));
    final matchMs = stopwatch.elapsedMilliseconds;

    metrics.add(FrameTiming(
        inputMs: inputMs, ocrMs: ocrMs, parseMs: parseMs, matchMs: matchMs));
    _logMetricsPeriodically();
    if (!kReleaseMode && result != null) {
      log.info('SCAN match card=${result.cardId} '
          'score=${result.score.toStringAsFixed(3)}');
    }
    return result;
  }

  void _logMetricsPeriodically() {
    if (!kReleaseMode && ++_frameCount % 20 == 0) {
      log.info('SCAN perf ${metrics.summary()}');
    }
  }

  void _track(MatchResult? result) {
    final key = result == null ? null : (result.cardId, result.language);
    if (key != null) {
      final coolUntil = _cooldowns[key];
      if (coolUntil != null && DateTime.now().isBefore(coolUntil)) return;
    }

    if (key == null || key != _trackedCard) {
      if (key == null) {
        // Tolerate brief dropouts before giving up on the tracked card.
        if (_trackedCard != null && ++_trackedMisses >= 2) {
          _resetTracking();
          _emit(ScanPhase.searching);
        }
        return;
      }
      _trackedCard = key;
      _trackedHits = 1;
      _trackedMisses = 0;
      // High-certainty reads detect on the very first frame.
      if (_trackedHits >= _requiredHits(result!.score)) {
        _resetTracking();
        onDetected(result);
      } else {
        _emit(ScanPhase.tracking);
      }
      return;
    }

    _trackedMisses = 0;
    _trackedHits++;
    if (_trackedHits >= _requiredHits(result!.score)) {
      _resetTracking();
      onDetected(result);
    } else {
      _emit(ScanPhase.tracking);
    }
  }

  /// High-certainty matches (exact name / footer-pinned, ≥0.95) confirm on
  /// the first repeat; only fuzzy matches need the full stability window.
  /// At ~650ms per frame this halves time-to-detection for clean reads.
  static int _requiredHits(double score) =>
      score >= scanInstantConfidence ? 1 : scanStabilityHits;

  InputImage? _toInputImage(CameraImage image, int rotationDegrees) {
    final rotation = InputImageRotationValue.fromRawValue(rotationDegrees);
    if (rotation == null) return null;
    final format = defaultTargetPlatform == TargetPlatform.android
        ? InputImageFormat.nv21
        : InputImageFormat.bgra8888;
    final bytes = image.planes.length == 1
        ? image.planes.first.bytes
        : _concatenatePlanes(image.planes);
    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  static Uint8List _concatenatePlanes(List<Plane> planes) {
    final builder = BytesBuilder(copy: false);
    for (final plane in planes) {
      builder.add(plane.bytes);
    }
    return builder.takeBytes();
  }
}

/// Riverpod-facing notifier wrapping [ScanController] with lifecycle and
/// detection state.
class ScanNotifier extends Notifier<ScanState> {
  ScanNotifier(this._indexProvider);

  final MatchIndex Function(Ref) _indexProvider;
  ScanController? _controller;
  Timer? _dismissTimer;

  ScanController? get controller => _controller;

  @override
  ScanState build() {
    ref.onDispose(() {
      _dismissTimer?.cancel();
      final c = _controller;
      _controller = null;
      if (c != null) unawaited(c.dispose());
    });
    return const ScanIdle();
  }

  Future<void> start() async {
    if (state is! ScanIdle && state is! ScanFailure) return;
    state = const ScanStarting();
    final controller = ScanController(
      onDetected: _onDetected,
      onProgress: _onProgress,
      indexProvider: () => _indexProvider(ref),
    );
    _controller = controller;
    try {
      await controller.start();
      state = const ScanStreaming();
    } on CameraException catch (e) {
      state = ScanFailure(e.code == 'CameraAccessDenied'
          ? 'Kamerazugriff verweigert - bitte in den Einstellungen erlauben.'
          : 'Kamera konnte nicht gestartet werden (${e.code}).');
      await controller.dispose();
      _controller = null;
    } catch (e) {
      state = ScanFailure('Kamera konnte nicht gestartet werden: $e');
      await controller.dispose();
      _controller = null;
    }
  }

  Future<void> stopScanning() async {
    _dismissTimer?.cancel();
    final controller = _controller;
    _controller = null;
    // State first: a rebuild between dispose start and state change would
    // otherwise render CameraPreview on a disposed controller.
    state = const ScanIdle();
    if (controller != null) await controller.dispose();
  }

  void _onProgress(ScanProgress progress) {
    // Detected state owns the UI until confirmed/dismissed.
    if (state is! ScanStreaming) return;
    state = ScanStreaming(
      phase: progress.phase,
      trackingCardId: progress.trackingCardId,
      trackingLanguage: progress.trackingLanguage,
      trackingHits: progress.trackingHits,
      requiredHits: scanStabilityHits,
    );
  }

  void _onDetected(MatchResult result) {
    // A manually picked print stays until confirm/dismiss/timeout — the
    // stream underneath must not swap the user's choice back.
    final s = state;
    if (s is ScanDetected && s.pinned) return;
    state = ScanDetected(
      cardId: result.cardId,
      language: result.language,
      score: result.score,
    );
    _dismissTimer?.cancel();
    _dismissTimer = Timer(scanConfirmTimeout, dismiss);
  }

  /// User picked a different print of the same-named card in the confirm
  /// bar — swap the detection and restart the confirm window. The print
  /// shown before goes on cooldown so the next frames don't instantly
  /// re-detect it.
  void switchPrint(int cardId, String language) {
    final s = state;
    if (s is! ScanDetected) return;
    if (s.cardId == cardId && s.language == language) return;
    _controller?.cooldown(s.cardId, s.language);
    state = ScanDetected(
      cardId: cardId,
      language: language,
      score: s.score,
      pinned: true,
    );
    _dismissTimer?.cancel();
    _dismissTimer = Timer(scanConfirmTimeout, dismiss);
  }

  /// User confirmed the detected card — caller persists, we cool down.
  void confirmed(int cardId, String language) {
    _dismissTimer?.cancel();
    _controller?.cooldown(cardId, language);
    HapticFeedback.mediumImpact();
    state = const ScanStreaming();
  }

  void dismiss() {
    _dismissTimer?.cancel();
    final s = state;
    if (s is ScanDetected) {
      _controller?.cooldown(s.cardId, s.language);
      state = const ScanStreaming();
    }
  }
}
