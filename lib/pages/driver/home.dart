import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider_test/blocs/geolocation/bloc.dart';
import 'package:provider_test/blocs/geolocation/state.dart';
import 'package:provider_test/components/current_shipment.dart';
import 'package:provider_test/components/driver_stats.dart';

// ignore: must_be_immutable
class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = screenSize.width * (isSmallScreen ? 0.02 : 0.03);
            final iconSize = screenSize.width * (isSmallScreen ? 0.045 : 0.05);
            final fontSize = screenSize.width * (isSmallScreen ? 0.04 : 0.045);
            final titleFontSize =
                screenSize.width * (isSmallScreen ? 0.06 : 0.075);
            final spacing = screenSize.width * (isSmallScreen ? 0.01 : 0.015);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: padding * 1.5,
                      left: padding,
                      right: padding,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          EvaIcons.pin,
                          size: iconSize,
                          color: Colors.deepPurple[600],
                        ),
                        SizedBox(width: spacing),
                        Text(
                          'موقعك الحالي',
                          style: TextStyle(
                            fontSize: fontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<GeolocationBloc, GeolocationState>(
                    builder: (context, state) {
                      if (state is GeolocationLoaded) {
                        Future<List<Placemark>> placemarks =
                            placemarkFromCoordinates(
                          state.position.latitude,
                          state.position.longitude,
                        );
                        return FutureBuilder<List<Placemark>>(
                          future: placemarks,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding: EdgeInsets.all(padding),
                                child: const Text(''),
                              );
                            } else if (snapshot.hasData) {
                              final placemark = snapshot.data!.first;
                              return Center(
                                child: Text(
                                  '${placemark.thoroughfare}, ${placemark.locality}, ${placemark.country}',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple[400],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        );
                      } else if (state is GeolocationLoading) {
                        return Padding(
                          padding: EdgeInsets.all(padding),
                          child: Text(
                            'جاري تحميل الموقع ...',
                            style: TextStyle(
                              fontSize: fontSize,
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.all(padding),
                          child: Text(
                            'فشل تحميل الموقع',
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Colors.red,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const DriverStates(),
                  Padding(
                    padding: EdgeInsets.only(
                      right: padding,
                      top: padding * 1.5,
                      bottom: padding * 1.5,
                    ),
                    child: Text(
                      'الشحنة الحالية',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: titleFontSize,
                          ),
                    ),
                  ),
                  CurrentShipmentCard(
                    pickupLocation: 'الملك فهد, المدينة المنورة',
                    deliveryLocation: 'الملك فيصل, المدينة المنورة',
                    onDetails: () {
                      // Navigate to details page
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
