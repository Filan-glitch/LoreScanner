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
import 'scan_state.dart';

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
    required this._indexProvider,
  });

  final void Function(MatchResult result) onDetected;
  final MatchIndex Function() _indexProvider;

  CameraController? camera;
  final TextRecognizer _recognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  bool _busy = false;
  int _frameCount = 0;
  DateTime _lastFrameAt = DateTime.fromMillisecondsSinceEpoch(0);
  int? _trackedCardId;
  int _trackedHits = 0;
  int _trackedMisses = 0;
  final Map<int, DateTime> _cooldowns = {};

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
    _trackedCardId = null;
    _trackedHits = 0;
    _trackedMisses = 0;
  }

  /// Puts a just-confirmed card on cooldown so the next frames don't
  /// immediately re-detect it.
  void cooldown(int cardId) {
    _cooldowns[cardId] = DateTime.now().add(scanCardCooldown);
    _resetTracking();
  }

  Future<void> _onFrame(CameraImage image) async {
    final now = DateTime.now();
    if (kDebugMode && ++_frameCount % 30 == 1) {
      log.info('SCAN heartbeat frame=$_frameCount busy=$_busy '
          'widgetSize=$widgetSize format=${image.format.group} '
          'planes=${image.planes.length} ${image.width}x${image.height}');
    }
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

    final rotationDegrees = controller.description.sensorOrientation;
    final inputImage = _toInputImage(image, rotationDegrees);
    if (inputImage == null) return null;

    final recognized = await _recognizer.processImage(inputImage);

    final sensorSize =
        Size(image.width.toDouble(), image.height.toDouble());
    final uprightSize = RoiMapper.uprightSize(sensorSize, rotationDegrees);
    final mapper =
        RoiMapper(widgetSize: widgetSize, uprightImageSize: uprightSize);
    final imageRoi = mapper.widgetToImage(cardRoi(widgetSize));

    // ML Kit applies the rotation metadata itself: boxes arrive already in
    // the upright frame (verified on Pixel 9a — y exceeds sensor height).
    final lines = <OcrLine>[
      for (final block in recognized.blocks)
        for (final line in block.lines)
          OcrLine(line.text, line.boundingBox),
    ];

    final parsed = parseOcrLines(lines, imageRoi);
    if (kDebugMode && lines.isNotEmpty) {
      log.info('SCAN raw=${lines.length} lines, roi=$imageRoi, '
          'inRoi names=${parsed.nameCandidates}, footer=${parsed.footer}, '
          'sample=${lines.take(3).map((l) => '"${l.text}"@${l.boundingBox}').join(' | ')}');
    }
    if (parsed.nameCandidates.isEmpty && parsed.footer == null) return null;

    final result = await compute(
        matchCards, MatchInput(parsed: parsed, index: _indexProvider()));
    if (kDebugMode && result != null) {
      log.info('SCAN match card=${result.cardId} '
          'score=${result.score.toStringAsFixed(3)}');
    }
    return result;
  }

  void _track(MatchResult? result) {
    final cardId = result?.cardId;
    if (cardId != null) {
      final coolUntil = _cooldowns[cardId];
      if (coolUntil != null && DateTime.now().isBefore(coolUntil)) return;
    }

    if (cardId == null || cardId != _trackedCardId) {
      if (cardId == null) {
        // Tolerate brief dropouts before giving up on the tracked card.
        if (_trackedCardId != null && ++_trackedMisses >= 2) _resetTracking();
        return;
      }
      _trackedCardId = cardId;
      _trackedHits = 1;
      _trackedMisses = 0;
      return;
    }

    _trackedMisses = 0;
    if (++_trackedHits >= scanStabilityHits) {
      final detected = result!;
      _resetTracking();
      onDetected(detected);
    }
  }

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

  void _onDetected(MatchResult result) {
    state = ScanDetected(cardId: result.cardId, score: result.score);
    _dismissTimer?.cancel();
    _dismissTimer = Timer(scanConfirmTimeout, dismiss);
  }

  /// User confirmed the detected card — caller persists, we cool down.
  void confirmed(int cardId) {
    _dismissTimer?.cancel();
    _controller?.cooldown(cardId);
    HapticFeedback.mediumImpact();
    state = const ScanStreaming();
  }

  void dismiss() {
    _dismissTimer?.cancel();
    final s = state;
    if (s is ScanDetected) {
      _controller?.cooldown(s.cardId);
      state = const ScanStreaming();
    }
  }
}
