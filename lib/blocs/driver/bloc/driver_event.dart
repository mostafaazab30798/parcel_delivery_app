part of 'driver_bloc.dart';

sealed class DriverEvent extends Equatable {
  const DriverEvent();

  @override
  List<Object> get props => [];
}

final class DriverStarted extends DriverEvent {
  const DriverStarted();
}

final class DriverProfileUpdated extends DriverEvent {
  final Map<String, dynamic> updateData;
  
  const DriverProfileUpdated(this.updateData);
  
  @override
  List<Object> get props => [updateData];
}

final class DriverStatusChanged extends DriverEvent {
  final String status;
  
  const DriverStatusChanged(this.status);
  
  @override
  List<Object> get props => [status];
}

final class DriverLocationUpdated extends DriverEvent {
  final double latitude;
  final double longitude;
  
  const DriverLocationUpdated({
    required this.latitude,
    required this.longitude,
  });
  
  @override
  List<Object> get props => [latitude, longitude];
}

final class DriverShipmentsLoaded extends DriverEvent {
  const DriverShipmentsLoaded();
}

final class DriverEarningsLoaded extends DriverEvent {
  const DriverEarningsLoaded();
}

final class DriverCompletedShipmentsLoaded extends DriverEvent {
  const DriverCompletedShipmentsLoaded();
}

final class DriverDataRefreshed extends DriverEvent {
  const DriverDataRefreshed();
}
