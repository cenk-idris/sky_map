import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sky_map/sky_map/bloc/sky_event.dart';
import 'package:sky_map/sky_map/bloc/sky_state.dart';
import 'package:sky_map/sky_map/services/bodies_api_service.dart';
import 'package:sky_map/sky_map/services/location_service.dart';

import '../models/celestial_body_model.dart';

class SkyBloc extends Bloc<SkyEvent, SkyState> {
  List<CelestialBody> _celestialBodies = [];

  SkyBloc() : super(SkyInitial()) {
    on<FetchLocation>(_onFetchLocation);
    on<FetchCelestialData>(_onFetchCelestialData);
    on<UpdateOffset>(_onUpdateOffset);
  }

  void _onFetchLocation(FetchLocation event, Emitter<SkyState> emit) async {
    // Emit loading state to notify we started to gather needed information
    emit(SkyLoading());
    // Then request locations
    try {
      Position position = await determinePosition();
      add(FetchCelestialData(position));
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
            'date: ${body.date}, id: ${body.id}, name: ${body.name}, altitudeDeg: ${body.altitudeDegree}, azimuthDeg: ${body.azimuthDegree}, distanceKm: ${body.distanceKm}, magnitude: ${body.magnitude}, constellation: ${body.constellation}, Coords: (${body.coords.dx},${body.coords.dy})');
      }
      _celestialBodies = celestialBodyList;
      emit(SkyReady(event.position, _celestialBodies));
    } catch (e) {
      emit(SkyError('Failed to fetch celestial data: ${e.toString()}'));
    }
  }

  void _onUpdateOffset(UpdateOffset event, Emitter<SkyState> emit) {
    emit(SkyOffsetUpdated(event.offset, _celestialBodies));
  }
}
