import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app_router/router.dart';
import 'firebase_options.dart';
import 'package:provider_test/blocs/auth/bloc.dart';
import 'package:provider_test/blocs/geolocation/bloc.dart';
import 'package:provider_test/blocs/geolocation/event.dart';
import 'package:provider_test/blocs/nav_bar/navigation_cubit.dart';
import 'package:provider_test/repos/geolocation/geolocation.dart';

Future<void> _requestPermissions() async {
  // Request location permission
  await Permission.location.request();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request all necessary permissions
  await _requestPermissions();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GeolocationRepository>(
          create: (context) => GeolocationRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GeolocationBloc>(
            create: (context) => GeolocationBloc(
              geolocationRepository: context.read<GeolocationRepository>(),
            )..add(LoadGeolocation()),
          ),
          BlocProvider<NavigationCubit>(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Delivery App',
          routerConfig: router,
        ),
      ),
    );
  }
}
