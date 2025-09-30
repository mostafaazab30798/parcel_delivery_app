import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'app_router/router.dart';
import 'package:provider_test/blocs/geolocation/bloc.dart';
import 'package:provider_test/blocs/nav_bar/navigation_cubit.dart';
import 'package:provider_test/blocs/driver/bloc/driver_bloc.dart';
import 'package:provider_test/blocs/shipment_api/shipment_api_bloc.dart';
import 'package:provider_test/repos/geolocation/geolocation.dart';
import 'package:provider_test/repos/driver_repository.dart';
import 'package:provider_test/repos/shipment_repository.dart';
import 'package:provider_test/services/driver_service.dart';
import 'package:provider_test/services/payment_service.dart';

// Custom BlocObserver for debugging
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    try {
      super.onChange(bloc, change);
      print('${bloc.runtimeType} $change');
    } catch (e) {
      print('Error in BlocObserver onChange: $e');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    try {
      print('${bloc.runtimeType} $error $stackTrace');
      super.onError(bloc, error, stackTrace);
    } catch (e) {
      print('Error in BlocObserver onError: $e');
    }
  }
}

Future<void> _requestPermissions() async {
  try {
    // Request location permission with error handling
    final status = await Permission.location.request();
    if (status.isDenied) {
      // Handle denied permission gracefully
      print('Location permission denied');
    }
  } catch (e) {
    // Handle permission errors gracefully
    print('Error requesting permissions: $e');
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    print('Flutter binding initialized successfully');

    // Set up BlocObserver for debugging
    try {
      Bloc.observer = AppBlocObserver();
      print('BlocObserver set up successfully');
    } catch (e) {
      print('Error setting up BlocObserver: $e');
      // Continue without BlocObserver if it fails
    }

    // Set up error handling for unhandled errors
    try {
      FlutterError.onError = (FlutterErrorDetails details) {
        try {
          print('Flutter error: ${details.exception}');
          print('Stack trace: ${details.stack}');
        } catch (e) {
          print('Error in FlutterError.onError: $e');
        }
      };
      print('Flutter error handler set up successfully');
    } catch (e) {
      print('Error setting up Flutter error handler: $e');
      // Continue without error handler if it fails
    }

    // Request permissions with error handling - make it non-blocking
    try {
      // Don't wait for permissions, just request them in background
      _requestPermissions();
      print('Permissions requested in background');
    } catch (e) {
      print('Error requesting permissions: $e');
      // Continue without permissions if they fail
    }

    try {
      runApp(MainApp());
      print('App started successfully');
    } catch (e) {
      print('Error starting app: $e');
      // Show a basic error screen if the app fails to start
      runApp(const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to start app. Please restart.'),
          ),
        ),
      ));
    }
  } catch (e) {
    print('Fatal error in main: $e');
    // Show a basic error screen if everything fails
    try {
      runApp(const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Fatal error occurred. Please restart the app.'),
          ),
        ),
      ));
    } catch (e2) {
      print('Error in fatal error handler: $e2');
      // If even the error handler fails, just print the error
      print('Unable to show error screen. App failed completely.');
    }
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<GeolocationRepository>(
            create: (context) {
              try {
                return GeolocationRepository();
              } catch (e) {
                print('Error creating GeolocationRepository: $e');
                return GeolocationRepository();
              }
            },
          ),
          RepositoryProvider<DriverService>(
            create: (context) {
              try {
                return DriverService();
              } catch (e) {
                print('Error creating DriverService: $e');
                return DriverService();
              }
            },
          ),
          RepositoryProvider<DriverRepository>(
            create: (context) {
              try {
                return DriverRepository();
              } catch (e) {
                print('Error creating DriverRepository: $e');
                return DriverRepository();
              }
            },
          ),
          RepositoryProvider<ShipmentRepository>(
            create: (context) {
              try {
                return ShipmentRepository();
              } catch (e) {
                print('Error creating ShipmentRepository: $e');
                return ShipmentRepository();
              }
            },
          ),
          RepositoryProvider<PaymentService>(
            create: (context) {
              try {
                return PaymentService();
              } catch (e) {
                print('Error creating PaymentService: $e');
                return PaymentService();
              }
            },
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<GeolocationBloc>(
              create: (context) {
                try {
                  final repository = context.read<GeolocationRepository>();
                  return GeolocationBloc(
                    geolocationRepository: repository,
                  );
                } catch (e) {
                  print('Error creating GeolocationBloc: $e');
                  // Return a basic bloc without location functionality
                  final repository = GeolocationRepository();
                  return GeolocationBloc(
                    geolocationRepository: repository,
                  );
                }
              },
            ),
            BlocProvider<NavigationCubit>(
              create: (context) {
                try {
                  return NavigationCubit();
                } catch (e) {
                  print('Error creating NavigationCubit: $e');
                  return NavigationCubit();
                }
              },
            ),
            BlocProvider<DriverBloc>(
              create: (context) {
                try {
                  final driverService = context.read<DriverService>();
                  final driverRepository = context.read<DriverRepository>();
                  return DriverBloc(
                    driverService: driverService,
                  );
                } catch (e) {
                  print('Error creating DriverBloc: $e');
                  return DriverBloc();
                }
              },
            ),
            BlocProvider<ShipmentApiBloc>(
              create: (context) {
                try {
                  final shipmentRepository = context.read<ShipmentRepository>();
                  return ShipmentApiBloc(repository: shipmentRepository);
                } catch (e) {
                  print('Error creating ShipmentApiBloc: $e');
                  return ShipmentApiBloc(repository: ShipmentRepository());
                }
              },
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Delivery App',
            routerConfig: router,
            builder: (context, child) {
              try {
                return child ?? const Scaffold(
                  body: Center(
                    child: Text('Something went wrong. Please try again.'),
                  ),
                );
              } catch (e) {
                print('Error building app: $e');
                return const Scaffold(
                  body: Center(
                    child: Text('Something went wrong. Please try again.'),
                  ),
                );
              }
            },
          ),
        ),
      );
    } catch (e) {
      print('Error building MainApp: $e');
      // Return a fallback UI if there's an error
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('Something went wrong. Please try again.'),
          ),
        ),
      );
    }
  }
}
