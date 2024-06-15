import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_map/sky_map/bloc/sky_bloc.dart';
import 'package:sky_map/sky_map/screens/sky_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Map',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(72, 74, 126, 1),
        ),
      ),
      home: BlocProvider(
        create: (context) => SkyBloc(),
        child: SkyScreen(),
      ),
    );
  }
}
