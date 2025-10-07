import 'package:flutter/material.dart'; import 'dart:ui' as ui;

class BalloonPainter extends CustomPainter { final Color color; final double sizePx;

BalloonPainter({required this.color, required this.sizePx});

@override void paint(Canvas canvas, Size size) { final paint = Paint() ..shader = ui.Gradient.linear( Offset(0, 0), Offset(size.width, size.height), [color.withOpacity(0.9), color.withOpacity(0.6)], ) ..style = PaintingStyle.fill;

// Balloon body
final balloonPath = Path()
  ..moveTo(size.width * 0.5, 0)
  ..quadraticBezierTo(size.width * 1.2, size.height * 0.3, size.width * 0.5, size.height)
  ..quadraticBezierTo(size.width * -0.2, size.height * 0.3, size.width * 0.5, 0);

canvas.drawPath(balloonPath, paint);

// Highlight reflection (more pronounced)
final highlight = Paint()
  ..shader = ui.Gradient.radial(
    Offset(size.width * 0.35, size.height * 0.25),
    size.width * 0.25,
    [Colors.white.withOpacity(0.8), Colors.transparent],
  );
canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.25), size.width * 0.18, highlight);

// Golden string (fixed gold color)
final stringPaint = Paint()
  ..shader = ui.Gradient.linear(
    Offset(size.width * 0.5, size.height * 1.05),
    Offset(size.width * 0.5, size.height * 1.5),
    [const Color(0xFFFFD700), const Color(0xFFDAA520)],
  )
  ..strokeWidth = size.width * 0.05
  ..style = PaintingStyle.stroke;

canvas.drawLine(
  Offset(size.width * 0.5, size.height * 1.05),
  Offset(size.width * 0.5, size.height * 1.5),
  stringPaint,
);

// Balloon knot
final knot = Paint()..color = color.withOpacity(0.9);
canvas.drawRect(
  Rect.fromCenter(
    center: Offset(size.width * 0.5, size.height * 1.02),
    width: size.width * 0.15,
    height: size.height * 0.1,
  ),
  knot,
);

}

@override bool shouldRepaint(covariant CustomPainter oldDelegate) => true; }

class BalloonWidget extends StatelessWidget { final Color color; final double sizePx; const BalloonWidget({super.key, required this.color, required this.sizePx});

@override Widget build(BuildContext context) { return CustomPaint( size: Size(sizePx, sizePx * 1.5), painter: BalloonPainter(color: color, sizePx: sizePx), ); } }