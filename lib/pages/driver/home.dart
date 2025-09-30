import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:provider_test/blocs/driver/bloc/driver_bloc.dart';
import 'package:provider_test/blocs/geolocation/bloc.dart';
import 'package:provider_test/blocs/geolocation/state.dart';
import 'package:provider_test/blocs/geolocation/event.dart';
import 'package:provider_test/components/current_shipment.dart';
import 'package:provider_test/components/driver_stats.dart';
import 'package:provider_test/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isLocationLoaded = false;
  bool _isDriverDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  // Helper method to format address in a user-friendly way
  String _formatAddress(List<Placemark> placemarks) {
    if (placemarks.isEmpty) return 'عنوان غير متوفر';
    
    final placemark = placemarks.first;
    List<String> addressParts = [];
    
    // Add street number and name
    if (placemark.subThoroughfare?.isNotEmpty == true) {
      addressParts.add(placemark.subThoroughfare!);
    }
    if (placemark.thoroughfare?.isNotEmpty == true) {
      addressParts.add(placemark.thoroughfare!);
    }
    
    // Add sub-locality (neighborhood)
    if (placemark.subLocality?.isNotEmpty == true) {
      addressParts.add(placemark.subLocality!);
    }
    
    // Add locality (city district)
    if (placemark.locality?.isNotEmpty == true) {
      addressParts.add(placemark.locality!);
    }
    
    // Add administrative area (city/region)
    if (placemark.administrativeArea?.isNotEmpty == true) {
      addressParts.add(placemark.administrativeArea!);
    }
    
    // Add country if not Saudi Arabia (assumed default)
    if (placemark.country?.isNotEmpty == true && 
        placemark.country != 'Saudi Arabia' && 
        placemark.country != 'المملكة العربية السعودية') {
      addressParts.add(placemark.country!);
    }
    
    // Join with commas and return
    String address = addressParts.where((part) => part.isNotEmpty).join('، ');
    return address.isNotEmpty ? address : 'العنوان الحالي';
  }

  Future<void> _checkAuthentication() async {
    try {
      // Use the new AuthService to check authentication
      final authService = AuthService();
      final currentUser = await authService.getCurrentUser();
      
      if (currentUser == null || currentUser.role != UserRole.driver) {
        // Not logged in as driver, redirect to login
        if (mounted) {
          context.go('/login');
        }
      } else {
        // Logged in as driver, load driver data and location
        if (mounted) {
          // Only trigger DriverStarted once to prevent duplicate BLoC events
          if (!_isDriverDataLoaded) {
            context.read<DriverBloc>().add(const DriverStarted());
            _isDriverDataLoaded = true;
          }
          
          // Trigger geolocation loading only once
          if (!_isLocationLoaded) {
            context.read<GeolocationBloc>().add(LoadGeolocation());
            _isLocationLoaded = true;
          }
        }
      }
    } catch (e) {
      print('Authentication check error: $e');
      // On error, redirect to login
      if (mounted) {
        context.go('/login');
      }
    }
  }

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

            return BlocListener<GeolocationBloc, GeolocationState>(
              listener: (context, state) {
                // When location is loaded, update driver location in backend
                if (state is GeolocationLoaded) {
                  context.read<DriverBloc>().add(
                    DriverLocationUpdated(
                      latitude: state.position.latitude,
                      longitude: state.position.longitude,
                    ),
                  );
                }
              },
              child: SingleChildScrollView(
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
                          SizedBox(width: spacing),
                          IconButton(
                            onPressed: () {
                              // Refresh location manually, reset the flag to allow reload
                              _isLocationLoaded = false;
                              context.read<GeolocationBloc>().add(LoadGeolocation());
                            },
                            icon: Icon(
                              Icons.refresh,
                              size: iconSize * 0.8,
                              color: Colors.deepPurple[400],
                            ),
                            tooltip: 'Refresh Location',
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
                            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              final formattedAddress = _formatAddress(snapshot.data!);
                              return Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: padding,
                                    vertical: padding * 0.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.deepPurple[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    formattedAddress,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.deepPurple[700],
                                      height: 1.3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: padding,
                                    vertical: padding * 0.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.blue[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'تم تحديد موقعك الحالي',
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[700],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
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
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: padding,
                              vertical: padding * 0.5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red[200]!,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.location_off,
                                  color: Colors.red[600],
                                  size: iconSize,
                                ),
                                SizedBox(height: spacing * 0.5),
                                Text(
                                  'تعذر تحديد الموقع',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: spacing * 0.3),
                                Text(
                                  'تأكد من تشغيل خدمات الموقع والسماح للتطبيق بالوصول للموقع',
                                  style: TextStyle(
                                    fontSize: fontSize * 0.8,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  BlocBuilder<DriverBloc, DriverState>(
                    builder: (context, driverState) {
                      if (driverState is DriverInitial) {
                        // Loading initial data
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (driverState is DriverLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (driverState is DriverError) {
                        return Padding(
                          padding: EdgeInsets.all(padding),
                          child: Text(
                            'خطأ: ${driverState.message}',
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      
                      if (driverState is DriverLoaded) {
                        return Column(
                          children: [
                            DriverStates(
                              driverData: driverState.driverData,
                              earnings: driverState.earnings,
                            ),
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
                            if (driverState.shipments.isNotEmpty)
                              CurrentShipmentCard(
                                pickupLocation: driverState.shipments.first['pickupAddress'] ?? 'غير محدد',
                                deliveryLocation: driverState.shipments.first['deliveryAddress'] ?? 'غير محدد',
                                onDetails: () {
                                  // Navigate to details page
                                },
                              )
                            else
                              Padding(
                                padding: EdgeInsets.all(padding),
                                child: Text(
                                  'لا توجد شحنات حالية',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        );
                      }
                      
                      return const SizedBox.shrink();
                    },
                  ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
