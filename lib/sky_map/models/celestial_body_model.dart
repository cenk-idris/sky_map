import 'dart:math';
import 'dart:ui';

import '../constants.dart';

class CelestialBody {
  final String id;
  final String name;
  final double altitudeDegree;
  final double azimuthDegree;
  final double distanceKm;
  final double magnitude;
  final String constellation;
  final Offset coords;

  CelestialBody({
    required this.id,
    required this.name,
    required this.altitudeDegree,
    required this.azimuthDegree,
    required this.distanceKm,
    required this.magnitude,
    required this.constellation,
    required this.coords,
  });

  factory CelestialBody.fromJson(Map<String, dynamic> json) {
    try {
      double altitudeDegree = double.tryParse(
              json['position']?['horizontal']?['altitude']?['degrees']) ??
          0.0;
      double azimuthDegree = double.tryParse(
              json['position']?['horizontal']?['azimuth']?['degrees']) ??
          0.0;

      Offset coords = _mapToCanvasCoords(
          azimuthDegree: azimuthDegree, altitudeDegree: altitudeDegree);
      //print(json);
      return CelestialBody(
        id: json['id'] ?? 'Unknown',
        name: json['name'] ?? 'Unknown',
        altitudeDegree: altitudeDegree,
        azimuthDegree: azimuthDegree,
        distanceKm:
            double.tryParse(json['distance']?['fromEarth']?['km']) ?? 0.0,
        magnitude: json['extraInfo']?['magnitude'] ?? 0.0,
        constellation: json['position']?['constellation']?['name'] ?? 'Unknown',
        coords: coords,
      );
    } catch (e) {
      print('Error parsing CelestialObjects: $e');
      return CelestialBody(
        id: 'Unknown',
        name: 'Unknown',
        altitudeDegree: 0.0,
        azimuthDegree: 0.0,
        distanceKm: 0.0,
        magnitude: 0.0,
        constellation: 'Unknown',
        coords: Offset.zero,
      );
    }
  }
}

Offset _mapToCanvasCoords(
    {required double azimuthDegree, required double altitudeDegree}) {
  // Convert degrees to radian
  double azimuthRad = azimuthDegree * (pi / 180);
  double altitudeRad = altitudeDegree * (pi / 180);

  double cartesianX = cos(altitudeRad) * sin(azimuthRad);
  double cartesianY = sin(azimuthRad) * cos(altitudeRad);

  double canvasX = ((cartesianX + 1) / 2) * canvasWidth;
  double canvasY = ((1 - cartesianY) / 2) * canvasHeight;

  return Offset(canvasX, canvasY);
}
