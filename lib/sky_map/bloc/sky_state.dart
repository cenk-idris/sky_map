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

class SkyOffsetUpdated extends SkyState {
  final Offset offset;
  final List<CelestialBody> celestialBodies;

  SkyOffsetUpdated(this.offset, this.celestialBodies);
}

class SkyError extends SkyState {
  final String errorMessage;

  SkyError(this.errorMessage);
}
