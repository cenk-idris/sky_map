import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'package:sky_map/sky_map/bloc/sky_bloc.dart';
import 'package:sky_map/sky_map/bloc/sky_event.dart';

import 'package:sky_map/sky_map/widgets/sky_painter.dart';

import '../bloc/sky_state.dart';
import '../models/celestial_body_model.dart';

class SkyScreen extends StatefulWidget {
  const SkyScreen({super.key});

  @override
  State<SkyScreen> createState() => _SkyScreenState();
}

class _SkyScreenState extends State<SkyScreen> {
  double heading = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Size screenSize = MediaQuery.of(context).size;
    //print('Screen size: w: ${screenSize.width} and h: ${screenSize.height}');
  }

  @override
  void initState() {
    super.initState();

    context.read<SkyBloc>().add(FetchLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sky Map'),
      ),
      body: BlocListener<SkyBloc, SkyState>(
        listener: (context, state) {
          if (state is SkyCelestialBodyTapped) {
            _showPlanetInfo(context, state.tappedBody);
          }
        },
        child: BlocBuilder<SkyBloc, SkyState>(
          builder: (context, state) {
            if (state is SkyLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SkyReady) {
              _startListeningToCompass();
              return GestureDetector(
                onTapUp: (details) {},
                child: Container(
                  color: Colors.black,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: SkyPainter(state.celestialBodies, state.starList,
                        heading, context.read<SkyBloc>().localSiderealTime!),
                  ),
                ),
              );
            } else if (state is SkyHeadingUpdated) {
              return GestureDetector(
                onTapUp: (details) {
                  //print('Local: ${details.localPosition}');
                  //print('Global: ${details.globalPosition}');
                  context
                      .read<SkyBloc>()
                      .add(TapOnCelestialBody(details.localPosition));
                },
                child: Container(
                  color: Colors.black,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: SkyPainter(
                      state.celestialBodies,
                      state.starList,
                      heading,
                      context.read<SkyBloc>().localSiderealTime!,
                    ),
                  ),
                ),
              );
            } else if (state is SkyError) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  void _startListeningToCompass() {
    FlutterCompass.events?.listen((direction) {
      heading = direction.heading ?? 0.0;
      //print(offset);
      //print(direction.heading);
      context.read<SkyBloc>().add(UpdateHeading(heading));
    });
  }

  void _showPlanetInfo(BuildContext context, CelestialBody body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(body.name),
        content: Text(
            'Magnitude: ${body.magnitude}\nDistance: ${body.distanceKm} km\nConstellation: ${body.constellation}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  // void _startListeningToSensors() {
  //   motionSensors.absoluteOrientationUpdateInterval =
  //       Duration.microsecondsPerSecond ~/ 100;
  //   motionSensors.absoluteOrientation.listen((AbsoluteOrientationEvent event) {
  //     // Using roll and pitch for offset
  //     print('Roll: ${event.roll}, Pitch: ${event.pitch}, Yaw: ${event.yaw}');
  //     final offset = Offset(event.roll * 1000, event.pitch * 1000);
  //     context.read<SkyBloc>().add(UpdateHeading(offset));
  //   });
  // }
}
