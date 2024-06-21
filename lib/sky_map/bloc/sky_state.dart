import 'dart:ui';

import 'package:geolocator/geolocator.dart';

import '../models/celestial_body_model.dart';

abstract class SkyState {}

class SkyInitial extends SkyState {}

class SkyLoading extends SkyState {}

class SkyReady extends SkyState {
  final Position position;
  final List<CelestialBody> celestialBodies;

  SkyReady(this.position, this.celestialBodies);
}

class SkyHeadingUpdated extends SkyState {
  final double heading;
  final List<CelestialBody> celestialBodies;

  SkyHeadingUpdated(this.heading, this.celestialBodies);
}

class SkyError extends SkyState {
  final String errorMessage;

  SkyError(this.errorMessage);
}
