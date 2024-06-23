import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sky_map/sky_map/bloc/sky_event.dart';
import 'package:sky_map/sky_map/bloc/sky_state.dart';
import 'package:sky_map/sky_map/services/bodies_api_service.dart';
import 'package:sky_map/sky_map/services/location_service.dart';

import '../models/celestial_body_model.dart';

class SkyBloc extends Bloc<SkyEvent, SkyState> {
  List<CelestialBody> _celestialBodies = [];
  Position? position;
  double? localSiderealTime;
  double heading = 0.0;

  SkyBloc() : super(SkyInitial()) {
    on<FetchLocation>(_onFetchLocation);
    on<FetchCelestialData>(_onFetchCelestialData);
    on<UpdateHeading>(_onUpdateHeading);
  }

  void _onFetchLocation(FetchLocation event, Emitter<SkyState> emit) async {
    // Emit loading state to notify we started to gather needed information
    emit(SkyLoading());
    // Then request locations
    try {
      position = await determinePosition();
      if (position != null) {
        final now = DateTime.now().toUtc();
        localSiderealTime = calculateLST(now, position!.longitude);
        print('Local Sidereal Time: $localSiderealTime');
        print('Position: $position');
        add(FetchCelestialData(position!));
      } else {
        throw Exception('Position empty');
      }
    } catch (e) {
      emit(SkyError('Failed to fetch location'));
    }
  }

  void _onFetchCelestialData(
      FetchCelestialData event, Emitter<SkyState> emit) async {
    try {
      // Get API url and credentials from .env
      List<CelestialBody> celestialBodyList =
          await BodiesApiService(event.position).getAllCelestialBodies();
      for (var body in celestialBodyList) {
        print(
            'date: ${body.date}, id: ${body.id}, name: ${body.name}, rAH: ${body.rightAscensionHours}, dec: ${body.declinationDegrees} altitudeDeg: ${body.altitudeDegree}, azimuthDeg: ${body.azimuthDegree}, distanceKm: ${body.distanceKm}, magnitude: ${body.magnitude}, constellation: ${body.constellation}, Coords: (${body.coords.dx},${body.coords.dy})');
      }
      _celestialBodies = celestialBodyList;
      emit(SkyReady(event.position, _celestialBodies));
    } catch (e) {
      emit(SkyError('Failed to fetch celestial data: ${e.toString()}'));
    }
  }

  void _onUpdateHeading(UpdateHeading event, Emitter<SkyState> emit) {
    emit(SkyHeadingUpdated(event.heading, _celestialBodies));
  }

  double calculateLST(DateTime now, double longitude) {
    final jd = _toJulianDate(now);
    print('Julian date: $jd');
    final s = jd - 2451545.0;
    final t = s / 36525.0;
    final t0 = 6.697374558 + (2400.051336 * t) + (0.000025862 * t * t);
    final gst = t0 +
        (now.hour + (now.minute / 60.0) + (now.second / 3600.0)) * 1.002737909;

    double lst = (gst + longitude / 15.0) % 24.0;
    if (lst < 0) lst += 24.0;

    return lst;
  }

  double _toJulianDate(DateTime date) {
    return date.millisecondsSinceEpoch / 86400000.0 + 2440587.5;
  }
}
