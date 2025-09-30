part of 'driver_bloc.dart';

sealed class DriverState extends Equatable {
  const DriverState();
  
  @override
  List<Object> get props => [];
}

final class DriverInitial extends DriverState {}

final class DriverLoading extends DriverState {}

final class DriverLoaded extends DriverState {
  final Map<String, dynamic> driverData;
  final List<Map<String, dynamic>> shipments;
  final List<Map<String, dynamic>> completedShipments;
  final Map<String, dynamic> earnings;
  
  const DriverLoaded({
    required this.driverData,
    required this.shipments,
    required this.completedShipments,
    required this.earnings,
  });
  
  @override
  List<Object> get props => [driverData, shipments, completedShipments, earnings];
}

final class DriverProfileUpdateSuccess extends DriverState {
  final Map<String, dynamic> driverData;
  
  const DriverProfileUpdateSuccess(this.driverData);
  
  @override
  List<Object> get props => [driverData];
}

final class DriverError extends DriverState {
  final String message;
  
  const DriverError(this.message);
  
  @override
  List<Object> get props => [message];
}
