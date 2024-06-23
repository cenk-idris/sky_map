import 'dart:math';
import 'dart:ui';

import '../constants.dart';

class CelestialBody {
  final String date;
  final String id;
  final String name;
  final double rightAscensionHours;
  final double declinationDegrees;
  final double altitudeDegree;
  final double azimuthDegree;
  final double distanceKm;
  final double magnitude;
  final String constellation;
  final Offset coords;

  CelestialBody({
    required this.date,
    required this.id,
    required this.name,
    required this.rightAscensionHours,
    required this.declinationDegrees,
    required this.altitudeDegree,
    required this.azimuthDegree,
    required this.distanceKm,
    required this.magnitude,
    required this.constellation,
    required this.coords,
  });

  factory CelestialBody.fromJson(Map<String, dynamic> json) {
    try {
      double rightAscensionHours = double.tryParse(
              json['position']?['equatorial']?['rightAscension']?['hours']) ??
          0.0;
      double declinationDegrees = double.tryParse(
              json['position']?['equatorial']?['declination']?['degrees']) ??
          0.0;
      double altitudeDegree = double.tryParse(
              json['position']?['horizontal']?['altitude']?['degrees']) ??
          0.0;
      double azimuthDegree = double.tryParse(
              json['position']?['horizontal']?['azimuth']?['degrees']) ??
          0.0;

      Offset coords = _mapToCanvasCoords(
          rightAscensionHours: rightAscensionHours,
          declinationDegrees: declinationDegrees);
      //print(json);
      return CelestialBody(
        date: json['date'] ?? 'Unknown',
        id: json['id'] ?? 'Unknown',
        name: json['name'] ?? 'Unknown',
        rightAscensionHours: rightAscensionHours,
        declinationDegrees: declinationDegrees,
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
        date: '2000-00-00',
        id: 'Unknown',
        name: 'Unknown',
        rightAscensionHours: 0.0,
        declinationDegrees: 0.0,
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
    {required double rightAscensionHours, required double declinationDegrees}) {
  // Convert RA from hours to degrees
  double raDegrees = rightAscensionHours * 15; // 1 hour is 15 deg (360 / 24)

  // Normalize and scale RA to canvas width
  double x = (raDegrees / 360) * canvasWidth;

  // Normalize and scale DEC to canvas height
  double y = declinationDegrees;

  return Offset(x, y);
}
