import 'dart:ui';

import 'package:geolocator/geolocator.dart';

abstract class SkyEvent {}

class UpdateHeading extends SkyEvent {
  final double heading;

  UpdateHeading(this.heading);
}

class FetchLocation extends SkyEvent {}

class FetchCelestialData extends SkyEvent {
  final Position position;

  FetchCelestialData(this.position);
}
