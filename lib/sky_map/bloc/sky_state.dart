import 'dart:ui';

import 'package:geolocator/geolocator.dart';

import '../models/celestial_body_model.dart';
import '../models/star_model.dart';

abstract class SkyState {}

class SkyInitial extends SkyState {}

class SkyLoading extends SkyState {}

class SkyReady extends SkyState {
  final Position position;
  final List<CelestialBody> celestialBodies;
  final List<Star> starList;

  SkyReady(this.position, this.celestialBodies, this.starList);
}

class SkyHeadingUpdated extends SkyState {
  final double heading;
  final List<CelestialBody> celestialBodies;
  final List<Star> starList;

  SkyHeadingUpdated(this.heading, this.celestialBodies, this.starList);
}

class SkyError extends SkyState {
  final String errorMessage;

  SkyError(this.errorMessage);
}

class SkyCelestialBodyTapped extends SkyState {
  final CelestialBody tappedBody;

  SkyCelestialBodyTapped(this.tappedBody);
}
