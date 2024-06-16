import 'package:flutter/material.dart';

class SkyPainter extends CustomPainter {
  final Offset offset;

  SkyPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    print('Canvas size: w: ${size.width} and h: ${size.height}');
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Example shapes
    canvas.drawCircle(Offset(100 + offset.dx, 100 + offset.dy), 50, paint);
    canvas.drawCircle(Offset(300 + offset.dx, 500 + offset.dy), 30, paint);
    canvas.drawCircle(Offset(600 + offset.dx, 300 + offset.dy), 40, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
