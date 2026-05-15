import 'package:flutter/material.dart';
import 'dart:math' as math;
class CircleArcs extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..color = Color(0xff0A898D)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2 - 20),
      0,
      math.pi * 1,
      false,
      paint,
    );

    final innerPaint = Paint()
      ..color = Color(0xff0A898D)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2 - 33),
      math.pi * 0.9,
      math.pi * 1.2,
      false,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
