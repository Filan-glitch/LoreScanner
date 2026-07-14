import 'package:camera/camera.dart';
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
    ref.read(scanProvider.notifier).stopScanning();
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
                ref.read(scanProvider.notifier).controller?.widgetSize = size;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _CoverPreview(camera: camera, widgetSize: size),
                    ScanOverlay(
                      tracking: scanState is ScanStreaming &&
                          scanState.trackingCardId != null,
                    ),
                    if (scanState is ScanDetected)
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 24,
                        child: ScanConfirmBar(cardId: scanState.cardId),
                      )
                    else
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 24,
                        child: Text(
                          'Karte in den Rahmen halten',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                  ],
                );
              }),
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
