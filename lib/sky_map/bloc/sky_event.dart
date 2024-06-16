import 'dart:ui';

import 'package:geolocator/geolocator.dart';

abstract class SkyEvent {}

class UpdateOffset extends SkyEvent {
  final Offset offset;

  UpdateOffset(this.offset);
}

class FetchLocation extends SkyEvent {}

class FetchCelestialData extends SkyEvent {
  final Position position;

  FetchCelestialData(this.position);
}
