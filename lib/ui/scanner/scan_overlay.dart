import 'package:flutter/material.dart';

import '../../domain/scan/roi_mapper.dart';

/// Dims everything outside the card ROI and draws corner guides. The ROI
/// comes from the same [cardRoi] the matcher uses — aligned is matched.
class ScanOverlay extends StatelessWidget {
  const ScanOverlay({super.key, required this.tracking});

  /// Whether a candidate card is currently accumulating stability hits.
  final bool tracking;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _OverlayPainter(
        guideColor: tracking
            ? Theme.of(context).colorScheme.primary
            : Colors.white.withAlpha(230),
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  _OverlayPainter({required this.guideColor});

  final Color guideColor;

  @override
  void paint(Canvas canvas, Size size) {
    final roi = cardRoi(size);
    final rrect = RRect.fromRectAndRadius(roi, const Radius.circular(16));

    final dim = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(dim, Paint()..color = Colors.black.withAlpha(128));

    final paint = Paint()
      ..color = guideColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const guide = 28.0;
    final corners = [
      // (corner, dx sign, dy sign)
      (roi.topLeft, 1.0, 1.0),
      (roi.topRight, -1.0, 1.0),
      (roi.bottomLeft, 1.0, -1.0),
      (roi.bottomRight, -1.0, -1.0),
    ];
    for (final (corner, sx, sy) in corners) {
      canvas.drawLine(corner, corner + Offset(guide * sx, 0), paint);
      canvas.drawLine(corner, corner + Offset(0, guide * sy), paint);
    }
  }

  @override
  bool shouldRepaint(_OverlayPainter oldDelegate) =>
      oldDelegate.guideColor != guideColor;
}
