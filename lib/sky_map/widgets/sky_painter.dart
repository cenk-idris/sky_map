import 'package:flutter/material.dart';

import '../bloc/sky_state.dart';
import '../models/celestial_body_model.dart';

class SkyPainter extends CustomPainter {
  final List<CelestialBody> celestialBodyList;
  final Offset offset;

  SkyPainter(this.offset, this.celestialBodyList);

  @override
  void paint(Canvas canvas, Size size) {
    //print('Canvas size: w: ${size.width} and h: ${size.height}');
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw celestial bodies
    for (var body in celestialBodyList) {
      //print(celestialBodyList.length);
      Offset position = body.coords + offset;
      canvas.drawCircle(position, 5, paint);

      textPainter.text = TextSpan(
        text: body.name,
        style: TextStyle(color: Colors.white, fontSize: 10),
      );

      textPainter.layout();
      textPainter.paint(canvas, position + Offset(5, -5));
    }

    // Example shapes
    // Circle visible when roll value is approx 0.00
    canvas.drawCircle(Offset(210 + offset.dx, 350 + offset.dy), 50, paint);

    // Circle visible when roll value is approx 1.57
    canvas.drawCircle(Offset(1780 + offset.dx, 350 + offset.dy), 50, paint);

    // Circle visible when roll value is approx 3.14
    canvas.drawCircle(Offset(3350 + offset.dx, 350 + offset.dy), 50, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
