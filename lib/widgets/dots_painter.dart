import 'dart:math';
import 'package:flutter/material.dart';

class DotsPainter extends CustomPainter {
  final int dotsCount;
  final Color? dotsColor;
  final int seed;

  const DotsPainter({this.dotsCount = 75, this.dotsColor, this.seed = 1337});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotsColor ?? Colors.white.withAlpha((0.2*255).toInt())
      ..style = PaintingStyle.fill;

    final rand = Random(seed);

    for (int i = 0; i < dotsCount; i++) {
      final radius = 1.32 + rand.nextDouble() * (1.67 - 1.32);
      final dx = rand.nextDouble() * size.width;
      final dy = rand.nextDouble() * size.height;
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DotsPainter oldDelegate) => false;
}
