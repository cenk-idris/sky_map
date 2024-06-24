import 'dart:ui';

import 'package:sky_map/sky_map/constants.dart';

class Star {
  final String name;
  final String constellation;
  final double rightAscensionHours;
  final double declinationDegrees;
  final double apparentMagnitude;
  final double distanceLightYear;
  final Offset coords;

  Star({
    required this.name,
    required this.constellation,
    required this.rightAscensionHours,
    required this.declinationDegrees,
    required this.apparentMagnitude,
    required this.distanceLightYear,
    required this.coords,
  });

  factory Star.fromJson(Map<String, dynamic> json) {
    try {
      double rightAscensionHours =
          _parseRightAscensionHours(json['right_ascension']);

      double declinationDegrees = _parseDeclination(json['declination']);

      Offset coords = _mapToCanvasCoord(
          rightAscensionHours: rightAscensionHours,
          declinationDegrees: declinationDegrees);

      return Star(
        name: json['name'],
        constellation: json['constellation'],
        rightAscensionHours: rightAscensionHours,
        declinationDegrees: declinationDegrees,
        apparentMagnitude: double.parse(json['apparent_magnitude']),
        distanceLightYear: double.parse(json['distance_light_year']),
        coords: coords,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  static Offset _mapToCanvasCoord(
      {required double rightAscensionHours,
      required double declinationDegrees}) {
    // Convert Ra from hours to degree
    double raDegrees = rightAscensionHours * 15; // 1 hour is 15 deg (360 /24)

    double x = (raDegrees / 360) * canvasWidth;

    double y = declinationDegrees;

    return Offset(x, y);
  }

  static double _parseRightAscensionHours(String ra) {
    final parts = ra.split('h');
    final hours = double.parse(parts[0].trim());
    final minAndSec = parts[1].split('m');
    final minutes = double.parse(minAndSec[0].trim());
    final seconds = double.parse(minAndSec[1].replaceAll('s', '').trim());
    return hours + (minutes / 60) + (seconds / 3600);
  }

  static double _parseDeclination(String dec) {
    final sign = dec.startsWith('-') ? -1 : 1;
    List<String> parts =
        dec.replaceAll(RegExp(r'[+°′″]'), '').trim().split(RegExp(r'\s+'));
    final degrees = double.parse(parts[0].trim());
    final minutes = double.parse(parts[1].trim());
    final seconds = double.parse(parts[2].trim());
    return sign * (degrees + (minutes / 60) + (seconds / 3600));
  }
}
