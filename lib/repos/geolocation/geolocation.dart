import 'package:geolocator/geolocator.dart';

class GeolocationRepository {
  GeolocationRepository() {
    try {
      // Initialize any necessary resources
      print('GeolocationRepository initialized');
    } catch (e) {
      print('Error initializing GeolocationRepository: $e');
    }
  }

  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return null;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied.');
        return null;
      }

      // Get current position with progressive fallback strategy
      try {
        // Try medium accuracy first (good balance)
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 8),
        );
      } catch (e) {
        print('Medium accuracy failed, trying low accuracy: $e');
        try {
          // Fallback to low accuracy with shorter timeout
          return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: const Duration(seconds: 5),
          );
        } catch (fallbackError) {
          print('Low accuracy also failed: $fallbackError');
          try {
            // Last resort: get last known position
            return await Geolocator.getLastKnownPosition();
          } catch (lastKnownError) {
            print('No location available: $lastKnownError');
            return null;
          }
        }
      }
    } catch (e) {
      print('GeolocationRepository error: $e');
      return null; // Return null instead of throwing exception
    }
  }

  // Add a method to check if location is available
  Future<bool> isLocationAvailable() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;
      
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse || 
             permission == LocationPermission.always;
    } catch (e) {
      print('Error checking location availability: $e');
      return false;
    }
  }

  // Get a stream of location updates for drivers (optional - currently unused)
  Stream<Position> getLocationStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.medium,
      distanceFilter: 10,
    );

    return Geolocator.getPositionStream(
      locationSettings: locationSettings,
    );
  }
}
