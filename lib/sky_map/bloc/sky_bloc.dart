import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_map/sky_map/bloc/sky_event.dart';
import 'package:sky_map/sky_map/bloc/sky_state.dart';

class SkyBloc extends Bloc<SkyEvent, SkyState> {
  SkyBloc() : super(SkyInitial());
}
