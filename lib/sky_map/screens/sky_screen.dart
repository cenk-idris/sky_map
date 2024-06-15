import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:sky_map/sky_map/bloc/sky_bloc.dart';
import 'package:sky_map/sky_map/bloc/sky_event.dart';
import 'package:sky_map/sky_map/widgets/sky_painter.dart';

import '../bloc/sky_state.dart';

class SkyScreen extends StatefulWidget {
  const SkyScreen({super.key});

  @override
  State<SkyScreen> createState() => _SkyScreenState();
}

class _SkyScreenState extends State<SkyScreen> {
  @override
  void initState() {
    super.initState();
    //print(dotenv.env['APP_ID']);
    //print(dotenv.env['APP_SECRET']);
    motionSensors.absoluteOrientationUpdateInterval =
        Duration.microsecondsPerSecond ~/ 100;
    motionSensors.absoluteOrientation.listen((AbsoluteOrientationEvent event) {
      // Using roll and pitch for offset
      //print('Roll: ${event.roll}, Pitch: ${event.pitch}, Yaw: ${event.yaw}');
      final offset = Offset(event.roll * 400, event.pitch * 400);
      context.read<SkyBloc>().add(UpdateOffset(offset));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR-like Canvas'),
      ),
      body: BlocBuilder<SkyBloc, SkyState>(
        builder: (context, state) {
          Offset offset = Offset.zero;
          if (state is SkyOffsetUpdated) {
            offset = state.offset;
          }
          return Center(
            child: Container(
              color: Colors.black,
              child: CustomPaint(
                painter: SkyPainter(offset),
                child: Container(),
              ),
            ),
          );
        },
      ),
    );
  }
}
