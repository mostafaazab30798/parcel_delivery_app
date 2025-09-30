import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider_test/services/driver_service.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  final DriverService _driverService;
  
  DriverBloc({DriverService? driverService}) 
      : _driverService = driverService ?? DriverService(),
        super(DriverInitial()) {
    
    on<DriverStarted>(_onDriverStarted);
    on<DriverProfileUpdated>(_onDriverProfileUpdated);
    on<DriverStatusChanged>(_onDriverStatusChanged);
    on<DriverLocationUpdated>(_onDriverLocationUpdated);
    on<DriverShipmentsLoaded>(_onDriverShipmentsLoaded);
    on<DriverCompletedShipmentsLoaded>(_onDriverCompletedShipmentsLoaded);
    on<DriverEarningsLoaded>(_onDriverEarningsLoaded);
    on<DriverDataRefreshed>(_onDriverDataRefreshed);
  }

  Future<void> _onDriverStarted(
    DriverStarted event,
    Emitter<DriverState> emit,
  ) async {
    try {
      emit(DriverLoading());
      
      // Load driver data from your custom API
      // This would replace the Firebase getUserData() call
      final driverData = await _loadDriverData();
      final shipments = await _loadDriverShipments();
      final completedShipments = await _loadDriverCompletedShipments();
      final earnings = await _loadDriverEarnings();
      
      emit(DriverLoaded(
        driverData: driverData,
        shipments: shipments,
        completedShipments: completedShipments,
        earnings: earnings,
      ));
    } catch (e) {
      emit(DriverError('Failed to load driver data: $e'));
    }
  }

  Future<void> _onDriverProfileUpdated(
    DriverProfileUpdated event,
    Emitter<DriverState> emit,
  ) async {
    try {
      // Update driver profile using your custom API
      final updatedData = await _updateDriverProfile(event.updateData);
      
      // Get current state to preserve other data
      final currentState = state;
      if (currentState is DriverLoaded) {
        // Emit updated DriverLoaded state with new driver data
        emit(DriverLoaded(
          driverData: updatedData,
          shipments: currentState.shipments,
          completedShipments: currentState.completedShipments,
          earnings: currentState.earnings,
        ));
      } else {
        // If not in DriverLoaded state, emit success state
        emit(DriverProfileUpdateSuccess(updatedData));
      }
    } catch (e) {
      emit(DriverError('Failed to update profile: $e'));
    }
  }

  Future<void> _onDriverStatusChanged(
    DriverStatusChanged event,
    Emitter<DriverState> emit,
  ) async {
    try {
      // Update driver status using your custom API
      await _updateDriverStatus(event.status);
      
      // Reload driver data to get updated status
      final currentState = state;
      if (currentState is DriverLoaded) {
        final updatedData = Map<String, dynamic>.from(currentState.driverData);
        updatedData['status'] = event.status;
        
        emit(DriverLoaded(
          driverData: updatedData,
          shipments: currentState.shipments,
          completedShipments: currentState.completedShipments,
          earnings: currentState.earnings,
        ));
      }
    } catch (e) {
      emit(DriverError('Failed to update status: $e'));
    }
  }

  Future<void> _onDriverLocationUpdated(
    DriverLocationUpdated event,
    Emitter<DriverState> emit,
  ) async {
    try {
      // Update driver location using your custom API
      await _updateDriverLocation(event.latitude, event.longitude);
      
      // Update the current state with new location
      final currentState = state;
      if (currentState is DriverLoaded) {
        final updatedData = Map<String, dynamic>.from(currentState.driverData);
        updatedData['currentLocation'] = {
          'latitude': event.latitude,
          'longitude': event.longitude,
        };
        
        emit(DriverLoaded(
          driverData: updatedData,
          shipments: currentState.shipments,
          completedShipments: currentState.completedShipments,
          earnings: currentState.earnings,
        ));
      }
    } catch (e) {
      emit(DriverError('Failed to update location: $e'));
    }
  }

  Future<void> _onDriverShipmentsLoaded(
    DriverShipmentsLoaded event,
    Emitter<DriverState> emit,
  ) async {
    try {
      final shipments = await _loadDriverShipments();
      
      final currentState = state;
      if (currentState is DriverLoaded) {
        emit(DriverLoaded(
          driverData: currentState.driverData,
          shipments: shipments,
          completedShipments: currentState.completedShipments,
          earnings: currentState.earnings,
        ));
      }
    } catch (e) {
      emit(DriverError('Failed to load shipments: $e'));
    }
  }

  Future<void> _onDriverCompletedShipmentsLoaded(
    DriverCompletedShipmentsLoaded event,
    Emitter<DriverState> emit,
  ) async {
    try {
      final completedShipments = await _loadDriverCompletedShipments();
      
      final currentState = state;
      if (currentState is DriverLoaded) {
        emit(DriverLoaded(
          driverData: currentState.driverData,
          shipments: currentState.shipments,
          completedShipments: completedShipments,
          earnings: currentState.earnings,
        ));
      }
    } catch (e) {
      emit(DriverError('Failed to load completed shipments: $e'));
    }
  }

  Future<void> _onDriverEarningsLoaded(
    DriverEarningsLoaded event,
    Emitter<DriverState> emit,
  ) async {
    try {
      final earnings = await _loadDriverEarnings();
      
      final currentState = state;
      if (currentState is DriverLoaded) {
        emit(DriverLoaded(
          driverData: currentState.driverData,
          shipments: currentState.shipments,
          completedShipments: currentState.completedShipments,
          earnings: earnings,
        ));
      }
    } catch (e) {
      emit(DriverError('Failed to load earnings: $e'));
    }
  }

  Future<void> _onDriverDataRefreshed(
    DriverDataRefreshed event,
    Emitter<DriverState> emit,
  ) async {
    try {
      emit(DriverLoading());
      
      // Reload all driver data
      final driverData = await _loadDriverData();
      final shipments = await _loadDriverShipments();
      final completedShipments = await _loadDriverCompletedShipments();
      final earnings = await _loadDriverEarnings();
      
      emit(DriverLoaded(
        driverData: driverData,
        shipments: shipments,
        completedShipments: completedShipments,
        earnings: earnings,
      ));
    } catch (e) {
      emit(DriverError('Failed to refresh driver data: $e'));
    }
  }

  // Helper methods to interact with your custom API
  Future<Map<String, dynamic>> _loadDriverData() async {
    final driverData = await _driverService.getDriverData();
    if (driverData != null) {
      return driverData;
    }
    throw Exception('No driver data received from API');
  }

  Future<List<Map<String, dynamic>>> _loadDriverShipments() async {
    return await _driverService.getDriverShipments();
  }

  Future<List<Map<String, dynamic>>> _loadDriverCompletedShipments() async {
    return await _driverService.getDriverCompletedShipments();
  }

  Future<Map<String, dynamic>> _loadDriverEarnings() async {
    return await _driverService.getDriverEarnings();
  }

  Future<Map<String, dynamic>> _updateDriverProfile(
    Map<String, dynamic> updateData,
  ) async {
    try {
      final success = await _driverService.updateDriverProfile(
        name: updateData['name'],
        phone: updateData['phone'],
        vehicleType: updateData['vehicleType'],
        vehiclePlateNumber: updateData['vehiclePlateNumber'],
        licenseNumber: updateData['licenseNumber'],
        region: updateData['region'],
        area: updateData['area'],
        status: updateData['status'],
        profilePicture: updateData['profilePicture'],
      );
      
      if (success) {
        // Reload driver data to get updated info
        return await _loadDriverData();
      }
      throw Exception('Failed to update profile');
    } catch (e) {
      print('Error updating driver profile: $e');
      throw e;
    }
  }

  Future<void> _updateDriverStatus(String status) async {
    try {
      await _driverService.updateDriverStatus(status);
    } catch (e) {
      print('Error updating driver status: $e');
      throw e;
    }
  }

  Future<void> _updateDriverLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      await _driverService.updateDriverLocation(latitude, longitude);
    } catch (e) {
      print('Error updating driver location: $e');
      throw e;
    }
  }
}
