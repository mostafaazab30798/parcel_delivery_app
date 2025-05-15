import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider_test/blocs/geolocation/event.dart';
import 'package:provider_test/blocs/geolocation/state.dart';
import 'package:provider_test/repos/geolocation/geolocation.dart';

// Events

// Bloc
class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  GeolocationBloc({required GeolocationRepository geolocationRepository})
      : super(GeolocationInitial()) {
    on<LoadGeolocation>(_onLoadGeolocation);
  }

  Future<void> _onLoadGeolocation(
      LoadGeolocation event, Emitter<GeolocationState> emit) async {
    emit(GeolocationLoading());
    try {
      Position position = await _determinePosition();
      emit(GeolocationLoaded(position: position));
    } catch (e) {
      emit(GeolocationError(message: e.toString()));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(); // Get the current position
    // Get the current position
  }
}
