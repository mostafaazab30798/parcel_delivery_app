import 'package:equatable/equatable.dart';

abstract class GeolocationEvent extends Equatable {
  const GeolocationEvent();

  @override
  List<Object> get props => [];
}

class LoadGeolocation extends GeolocationEvent {}

class UpdateGeolocation extends GeolocationEvent {
  final double latitude;
  final double longitude;

  const UpdateGeolocation({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];
}
