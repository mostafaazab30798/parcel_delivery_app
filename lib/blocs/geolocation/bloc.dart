import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider_test/blocs/geolocation/event.dart';
import 'package:provider_test/blocs/geolocation/state.dart';
import 'package:provider_test/repos/geolocation/geolocation.dart';

// Events

// Bloc
class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  final GeolocationRepository _geolocationRepository;
  Position? _cachedPosition;
  DateTime? _lastLocationTime;
  bool _isLoading = false;
  
  GeolocationBloc({required GeolocationRepository geolocationRepository})
      : _geolocationRepository = geolocationRepository,
        super(GeolocationInitial()) {
    try {
      on<LoadGeolocation>(_onLoadGeolocation);
    } catch (e) {
      print('Error setting up GeolocationBloc event handlers: $e');
      // Don't emit here, just log the error
    }
  }

  Future<void> _onLoadGeolocation(
      LoadGeolocation event, Emitter<GeolocationState> emit) async {
    
    // Prevent multiple simultaneous requests
    if (_isLoading) {
      print('Location request already in progress, ignoring');
      return;
    }
    
    // Use cached position if it's recent (less than 5 minutes old)
    if (_cachedPosition != null && _lastLocationTime != null) {
      final timeDiff = DateTime.now().difference(_lastLocationTime!);
      if (timeDiff.inMinutes < 5) {
        print('Using cached location');
        emit(GeolocationLoaded(position: _cachedPosition!));
        return;
      }
    }
    
    _isLoading = true;
    emit(GeolocationLoading());
    
    try {
      // Check if location is available first
      bool isAvailable = await _geolocationRepository.isLocationAvailable();
      if (!isAvailable) {
        _isLoading = false;
        emit(GeolocationError(message: 'Location services are not available. Please enable location services and grant permissions.'));
        return;
      }

      // Get current position
      Position? position = await _geolocationRepository.getCurrentLocation();
      
      if (position != null) {
        // Cache the position and timestamp
        _cachedPosition = position;
        _lastLocationTime = DateTime.now();
        _isLoading = false;
        emit(GeolocationLoaded(position: position));
      } else {
        _isLoading = false;
        emit(GeolocationError(message: 'Unable to get location. Please check permissions and try again.'));
      }
    } catch (e) {
      print('Geolocation error: $e');
      _isLoading = false;
      emit(GeolocationError(message: e.toString()));
    }
  }
}
