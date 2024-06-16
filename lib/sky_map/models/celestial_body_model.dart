import 'dart:math';

//
//
//
//
//
//

//
//
//
//
//
//

class CelestialBody {
  final String id;
  final String name;
  final double altitudeDegree;
  final double azimuthDegree;
  final double distanceKm;
  final double magnitude;
  final String constellation;
  double? cartesianX;
  double? cartesianY;

  CelestialBody({
    required this.id,
    required this.name,
    required this.altitudeDegree,
    required this.azimuthDegree,
    required this.distanceKm,
    required this.magnitude,
    required this.constellation,
  }) {
    _calculateCartesianCoordinates();
  }

  factory CelestialBody.fromJson(Map<String, dynamic> json) {
    try {
      //print(json);
      return CelestialBody(
        id: json['id'] ?? 'Unknown',
        name: json['name'] ?? 'Unknown',
        altitudeDegree: double.tryParse(
                json['position']?['horizontal']?['altitude']?['degrees']) ??
            0.0,
        azimuthDegree: double.tryParse(
                json['position']?['horizontal']?['azimuth']?['degrees']) ??
            0.0,
        distanceKm:
            double.tryParse(json['distance']?['fromEarth']?['km']) ?? 0.0,
        magnitude: json['extraInfo']?['magnitude'] ?? 0.0,
        constellation: json['position']?['constellation']?['name'] ?? 'Unknown',
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
      );
    }
  }

  _calculateCartesianCoordinates() {
    // Convert degrees to radian
    double azimuthRad = azimuthDegree * (pi / 180);
    double altitudeRad = altitudeDegree * (pi / 180);

    cartesianX = cos(altitudeRad) * sin(azimuthRad);
    cartesianY = sin(azimuthRad) * cos(altitudeRad);
  }
}
