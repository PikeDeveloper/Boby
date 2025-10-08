import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class BalloonPainter extends CustomPainter {
  final Color color;
  final double sizePx;

  BalloonPainter({required this.color, required this.sizePx});

  @override
  void paint(Canvas canvas, Size size) {
    // Main balloon color with gradient
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width * 0.3, size.height * 0.3),
        size.width * 0.7,
        [
          color,
          Color.lerp(color, Colors.black, 0.2)!,
        ],
      )
      ..style = PaintingStyle.fill;

    // Balloon body - more oval shape
    final balloonPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.05)
      ..quadraticBezierTo(
        size.width * 0.9, size.height * 0.1,
        size.width * 0.85, size.height * 0.6
      )
      ..quadraticBezierTo(
        size.width * 0.8, size.height * 0.9,
        size.width * 0.5, size.height * 0.95
      )
      ..quadraticBezierTo(
        size.width * 0.2, size.height * 0.9,
        size.width * 0.15, size.height * 0.6
      )
      ..quadraticBezierTo(
        size.width * 0.1, size.height * 0.1,
        size.width * 0.5, size.height * 0.05
      )
      ..close();

    canvas.drawPath(balloonPath, paint);

    // Highlight reflection - more natural shape
    final highlight = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width * 0.35, size.height * 0.3),
        size.width * 0.4,
        [
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.1),
          Colors.transparent,
        ],
        [0.0, 0.5, 1.0],
      );

    final highlightPath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.6, size.height * 0.15,
        size.width * 0.7, size.height * 0.3
      )
      ..quadraticBezierTo(
        size.width * 0.6, size.height * 0.5,
        size.width * 0.3, size.height * 0.4
      )
      ..close();

    canvas.drawPath(highlightPath, highlight);

    // Balloon knot (the part where the string is tied)
    final knotPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final knotPath = Path()
      ..moveTo(size.width * 0.4, size.height * 0.93)
      ..quadraticBezierTo(
        size.width * 0.5, size.height * 0.98,
        size.width * 0.6, size.height * 0.93
      )
      ..quadraticBezierTo(
        size.width * 0.5, size.height * 1.03,
        size.width * 0.4, size.height * 0.93
      )
      ..close();

    canvas.drawPath(knotPath, knotPaint);

    // String - thinner and with a slight curve
    final stringPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.015
      ..strokeCap = StrokeCap.round;

    final stringPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.95)
      ..quadraticBezierTo(
        size.width * 0.5 + size.width * 0.05,
        size.height * 1.5,
        size.width * 0.5,
        size.height * 1.8
      );

    canvas.drawPath(stringPath, stringPaint);

    // Add some texture to the balloon
    final texturePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw some subtle curves to simulate balloon texture
    for (int i = 0; i < 5; i++) {
      final y = size.height * (0.2 + i * 0.15);
      if (y < size.height * 0.9) {
        final x = size.width * (0.2 + i * 0.05);
        final radius = size.width * (0.6 - i * 0.05);
        canvas.drawCircle(
          Offset(x, y),
          radius,
          texturePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BalloonWidget extends StatelessWidget {
  final Color color;
  final double sizePx;
  
  const BalloonWidget({
    super.key,
    required this.color,
    required this.sizePx,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(sizePx, sizePx * 1.8), // Slightly taller aspect ratio
      painter: BalloonPainter(color: color, sizePx: sizePx),
    );
  }
}