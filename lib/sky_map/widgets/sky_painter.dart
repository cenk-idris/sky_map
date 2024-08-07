import 'package:flutter/material.dart';
import 'package:sky_map/sky_map/constants.dart';

import '../bloc/sky_state.dart';
import '../models/celestial_body_model.dart';
import '../models/star_model.dart';

class SkyPainter extends CustomPainter {
  final List<CelestialBody> celestialBodyList;
  final List<Star> starList;
  final double heading;
  final double localSiderealTime;

  SkyPainter(this.celestialBodyList, this.starList, this.heading,
      this.localSiderealTime);

  @override
  void paint(Canvas canvas, Size size) {
    //print('Canvas size: w: ${size.width} and h: ${size.height}');
    Paint planetPainter = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    Paint starPainter = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final canvasCenterX = canvasWidth / 2;
    final canvasCenterY = canvasHeight / 2;
    //print('height: ${size.height}');

    _drawAltitudeLine(canvas, size, planetPainter);

    // Draw stars
    for (var star in starList) {
      double adjustedX = (star.coords.dx -
              ((heading - localSiderealTime * 15) / 360) * canvasWidth) %
          canvasWidth;
      if (adjustedX < 0) {
        adjustedX += canvasWidth;
      }

      double adjustedY = canvasCenterY - (star.coords.dy / 180.0 * size.height);

      Offset position = Offset(adjustedX, adjustedY);

      canvas.drawCircle(position, 2, starPainter);

      textPainter.text = TextSpan(
        text: star.name,
        style: TextStyle(color: Colors.white, fontSize: 10),
      );

      textPainter.layout();
      textPainter.paint(canvas, position + Offset(5, -5));
    }

    // Draw celestial bodies
    for (var body in celestialBodyList) {
      double adjustedX = (body.coords.dx -
              ((heading - localSiderealTime * 15) / 360) * canvasWidth) %
          canvasWidth;
      if (adjustedX < 0) {
        adjustedX += canvasWidth;
      }
      double adjustedY =
          canvasCenterY - (body.coords.dy / 180.0 * canvasHeight);
      Offset position = Offset(adjustedX, adjustedY);

      body.adjustedCoords = position;
      canvas.drawCircle(position, 5, planetPainter);

      textPainter.text = TextSpan(
        text: body.name,
        style: TextStyle(color: Colors.white, fontSize: 10),
      );

      textPainter.layout();
      textPainter.paint(canvas, position + Offset(5, -5));
    }

    // Example shapes
    // Draw example shapes based on specific degrees
    _drawCircleAtDegree(canvas, size, planetPainter, 0, 10.0, '0°');
    _drawCircleAtDegree(canvas, size, planetPainter, 90, 10.0, '90°');
    _drawCircleAtDegree(canvas, size, planetPainter, 180, 10.0, '180°');
    _drawCircleAtDegree(canvas, size, planetPainter, 270, 10.0, '270°');
  }

  void _drawAltitudeLine(Canvas canvas, Size size, Paint paint) {
    // Calculate the center of the canvas height
    double centerY = size.height / 2;

    // Create the start and end points of the line
    Offset start = Offset(0, centerY);
    Offset end = Offset(size.width, centerY);

    // Draw the line
    canvas.drawLine(start, start, paint);

    // Create a TextPainter for the label
    final textPainter = TextPainter(
      text: TextSpan(
        text: '0° Declination',
        style: TextStyle(color: Colors.white, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    );

    // Layout and draw the text
    textPainter.layout();
    textPainter.paint(canvas, Offset(0, centerY - 15));
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
