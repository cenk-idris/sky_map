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
      ..style = PaintingStyle.fill;

    // Draw celestial bodies
    for (var body in celestialBodyList) {
      //print(celestialBodyList.length);
      Offset canvasCoords = body.coords;
      canvas.drawCircle(
          canvasCoords.translate(offset.dx, offset.dy), 10, paint);
    }

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
