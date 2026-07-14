import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/scan/scan_state.dart';
import '../../providers.dart';
import 'scan_confirm_bar.dart';
import 'scan_overlay.dart';

/// Continuous scanner: full-screen preview, card-frame overlay, and a
/// quick-confirm bar that appears per detection while the stream keeps
/// running.
class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key, required this.active});

  /// Whether this tab is currently visible — drives camera lifecycle.
  final bool active;

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.active) _start();
  }

  @override
  void didUpdateWidget(ScannerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) _start();
    if (!widget.active && oldWidget.active) _stop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!widget.active) return;
    switch (state) {
      case AppLifecycleState.resumed:
        _start();
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _stop();
      default:
        break;
    }
  }

  void _start() {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(scanProvider.notifier).start());
  }

  void _stop() {
    // didUpdateWidget/lifecycle callbacks run during build — defer the
    // provider mutation past the frame.
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(scanProvider.notifier).stopScanning());
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanProvider);
    final camera = ref.read(scanProvider.notifier).controller?.camera;

    return Scaffold(
      backgroundColor: Colors.black,
      body: switch (scanState) {
        ScanIdle() || ScanStarting() => const Center(
            child: CircularProgressIndicator(),
          ),
        ScanFailure(:final message) => _FailureView(
            message: message,
            onRetry: () => ref.read(scanProvider.notifier).start(),
          ),
        _ => camera == null || !camera.value.isInitialized
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(builder: (context, constraints) {
                final size =
                    Size(constraints.maxWidth, constraints.maxHeight);
                // Defer past build — mutating controller state during the
                // build phase is a side effect; _onFrame skips frames
                // until the size arrives.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  ref.read(scanProvider.notifier).controller?.widgetSize =
                      size;
                });
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _CoverPreview(camera: camera, widgetSize: size),
                    ScanOverlay(
                      tracking: scanState is ScanStreaming &&
                          scanState.trackingCardId != null,
                    ),
                    if (!kReleaseMode)
                      Positioned(
                        left: 16,
                        right: 16,
                        top: MediaQuery.of(context).padding.top + 8,
                        child: _PerfPanel(),
                      ),
                    if (scanState is ScanDetected)
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 24,
                        child: ScanConfirmBar(
                          cardId: scanState.cardId,
                          language: scanState.language,
                        ),
                      )
                    else
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 24,
                        child: _StatusLine(state: scanState),
                      ),
                  ],
                );
              }),
      },
    );
  }
}

/// Live pipeline feedback under the frame: coarse phase only. The card
/// name deliberately stays out of this line — a tracked card can still be
/// dropped by the stability window, and naming it here would promise a
/// detection that may never surface.
class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.state});

  final ScanState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final streaming = state is ScanStreaming ? state as ScanStreaming : null;
    final phase = streaming?.phase ?? ScanPhase.searching;

    final (label, showSpinner) = switch (phase) {
      ScanPhase.searching => ('Karte in den Rahmen halten', false),
      ScanPhase.reading => ('Text wird gelesen…', true),
      ScanPhase.matching => ('Karte wird gesucht…', true),
      ScanPhase.tracking => ('Karte erkannt – kurz still halten', true),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(153),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showSpinner) ...[
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                ),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          if (phase == ScanPhase.tracking && streaming != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: streaming.trackingHits / streaming.requiredHits,
                minHeight: 6,
                backgroundColor: Colors.white24,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Debug-only: rolling per-stage pipeline timings.
class _PerfPanel extends ConsumerStatefulWidget {
  @override
  ConsumerState<_PerfPanel> createState() => _PerfPanelState();
}

class _PerfPanelState extends ConsumerState<_PerfPanel> {
  late final Stream<void> _tick =
      Stream.periodic(const Duration(seconds: 1));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: _tick,
      builder: (context, _) {
        final metrics = ref.read(scanProvider.notifier).controller?.metrics;
        if (metrics == null || metrics.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(140),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            metrics.summary(),
            style: const TextStyle(
                color: Colors.greenAccent, fontSize: 11, fontFamily: 'monospace'),
          ),
        );
      },
    );
  }
}

/// Camera preview scaled with BoxFit.cover — matches the RoiMapper's
/// cover-fit assumption exactly.
class _CoverPreview extends StatelessWidget {
  const _CoverPreview({required this.camera, required this.widgetSize});

  final CameraController camera;
  final Size widgetSize;

  @override
  Widget build(BuildContext context) {
    final previewSize = camera.value.previewSize;
    if (previewSize == null) return const SizedBox.shrink();
    // previewSize is landscape sensor-oriented; upright it for portrait.
    final uprightPreview = Size(previewSize.height, previewSize.width);
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: uprightPreview.width,
        height: uprightPreview.height,
        child: CameraPreview(camera),
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_photography, size: 64, color: Colors.white70),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 24),
            FilledButton(onPressed: onRetry, child: const Text('Erneut versuchen')),
          ],
        ),
      ),
    );
  }
}
