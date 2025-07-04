import 'package:flutter/material.dart';

/// Widget that displays a card template overlay on the camera preview
/// to guide users in aligning cards for optimal scanning
class CardTemplateOverlay extends StatelessWidget {
  const CardTemplateOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: CardTemplatePainter(),
      ),
    );
  }
}

/// Custom painter for drawing the card template overlay
class CardTemplatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(204)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    
    final shadowPaint = Paint()
      ..color = Colors.black.withAlpha(77)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    // Calculate card dimensions (standard trading card ratio is roughly 2.5:3.5)
    final cardWidth = size.width * 0.8;
    final cardHeight = cardWidth * 1.4; // 2.5:3.5 ratio
    
    // Center the card template
    final left = (size.width - cardWidth) / 2;
    final top = (size.height - cardHeight) / 2;
    
    final cardRect = Rect.fromLTWH(left, top, cardWidth, cardHeight);
    const cornerRadius = Radius.circular(12.0);
    
    // Draw shadow first
    canvas.drawRRect(
      RRect.fromRectAndRadius(cardRect.translate(2, 2), cornerRadius),
      shadowPaint,
    );
    
    // Draw main card outline
    canvas.drawRRect(
      RRect.fromRectAndRadius(cardRect, cornerRadius),
      paint,
    );
    
    // Draw corner guides
    _drawCornerGuides(canvas, cardRect, paint);
    
    // Draw instruction text
    _drawInstructionText(canvas, size, cardRect);
  }
  
  void _drawCornerGuides(Canvas canvas, Rect cardRect, Paint paint) {
    const guideLength = 20.0;
    const guideOffset = 10.0;
    
    final guidePaint = Paint()
      ..color = Colors.yellow.withAlpha(230)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    // Top-left corner
    canvas.drawLine(
      Offset(cardRect.left - guideOffset, cardRect.top - guideOffset),
      Offset(cardRect.left - guideOffset + guideLength, cardRect.top - guideOffset),
      guidePaint,
    );
    canvas.drawLine(
      Offset(cardRect.left - guideOffset, cardRect.top - guideOffset),
      Offset(cardRect.left - guideOffset, cardRect.top - guideOffset + guideLength),
      guidePaint,
    );
    
    // Top-right corner
    canvas.drawLine(
      Offset(cardRect.right + guideOffset, cardRect.top - guideOffset),
      Offset(cardRect.right + guideOffset - guideLength, cardRect.top - guideOffset),
      guidePaint,
    );
    canvas.drawLine(
      Offset(cardRect.right + guideOffset, cardRect.top - guideOffset),
      Offset(cardRect.right + guideOffset, cardRect.top - guideOffset + guideLength),
      guidePaint,
    );
    
    // Bottom-left corner
    canvas.drawLine(
      Offset(cardRect.left - guideOffset, cardRect.bottom + guideOffset),
      Offset(cardRect.left - guideOffset + guideLength, cardRect.bottom + guideOffset),
      guidePaint,
    );
    canvas.drawLine(
      Offset(cardRect.left - guideOffset, cardRect.bottom + guideOffset),
      Offset(cardRect.left - guideOffset, cardRect.bottom + guideOffset - guideLength),
      guidePaint,
    );
    
    // Bottom-right corner
    canvas.drawLine(
      Offset(cardRect.right + guideOffset, cardRect.bottom + guideOffset),
      Offset(cardRect.right + guideOffset - guideLength, cardRect.bottom + guideOffset),
      guidePaint,
    );
    canvas.drawLine(
      Offset(cardRect.right + guideOffset, cardRect.bottom + guideOffset),
      Offset(cardRect.right + guideOffset, cardRect.bottom + guideOffset - guideLength),
      guidePaint,
    );
  }
  
  void _drawInstructionText(Canvas canvas, Size size, Rect cardRect) {
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Karte hier positionieren',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(1, 1),
              blurRadius: 2,
              color: Colors.black,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      cardRect.bottom + 30,
    );
    
    textPainter.paint(canvas, textOffset);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Extension to get the card template bounds for cropping
extension CardTemplateOverlayExtension on CardTemplateOverlay {
  static Rect getCardBounds(Size screenSize) {
    final cardWidth = screenSize.width * 0.8;
    final cardHeight = cardWidth * 1.4;
    final left = (screenSize.width - cardWidth) / 2;
    final top = (screenSize.height - cardHeight) / 2;
    
    return Rect.fromLTWH(left, top, cardWidth, cardHeight);
  }
}