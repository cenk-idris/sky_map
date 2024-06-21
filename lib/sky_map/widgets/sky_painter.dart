import 'package:flutter/material.dart';
import 'package:sky_map/sky_map/constants.dart';

import '../bloc/sky_state.dart';
import '../models/celestial_body_model.dart';

class SkyPainter extends CustomPainter {
  final List<CelestialBody> celestialBodyList;
  final double heading;

  SkyPainter(this.celestialBodyList, this.heading);

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

    final canvasCenterX = canvasWidth / 2;
    final canvasCenterY = size.height / 2;
    print(size.height);

    // Draw celestial bodies
    for (var body in celestialBodyList) {
      double adjustedX =
          canvasCenterX + body.coords.dx - (heading / 360) * canvasWidth;
      double adjustedY = canvasCenterY + body.coords.dy;
      Offset position = Offset(adjustedX, adjustedY);
      //print(position);
      canvas.drawCircle(position, 5, paint);

      textPainter.text = TextSpan(
        text: body.name,
        style: TextStyle(color: Colors.white, fontSize: 10),
      );

      textPainter.layout();
      textPainter.paint(canvas, position + Offset(5, -5));
    }

    // Example shapes
    // Draw example shapes based on specific degrees
    _drawCircleAtDegree(canvas, size, paint, 0, 10.0, '0°');
    _drawCircleAtDegree(canvas, size, paint, 90, 10.0, '90°');
    _drawCircleAtDegree(canvas, size, paint, 180, 10.0, '180°');
    _drawCircleAtDegree(canvas, size, paint, 270, 10.0, '270°');
  }

  void _drawCircleAtDegree(Canvas canvas, Size size, Paint paint, double degree,
      double centerY, String label) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Calculate the position based on degree and heading
    double relativeDegree = (degree - heading) % 360;
    if (relativeDegree < 0) {
      relativeDegree += 360; // Ensure the degree is within the 0-360 range
    }

    // Convert relative degree to canvas position
    double positionX = (relativeDegree / 360) * canvasWidth;
    Offset position = Offset(positionX, centerY);

    canvas.drawCircle(position, 0, paint);

    textPainter.text = TextSpan(
      text: label,
      style: TextStyle(color: Colors.white, fontSize: 10),
    );

    textPainter.layout();
    textPainter.paint(canvas, position + Offset(25, -5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
