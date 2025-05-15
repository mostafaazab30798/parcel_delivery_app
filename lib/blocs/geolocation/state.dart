import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class GeolocationState extends Equatable {
  const GeolocationState();

  @override
  List<Object?> get props => [];
}

class GeolocationInitial extends GeolocationState {}

class GeolocationLoading extends GeolocationState {}

class GeolocationLoaded extends GeolocationState {
  final Position position;

  const GeolocationLoaded({required this.position});

  @override
  List<Object?> get props => [position];
}

class GeolocationError extends GeolocationState {
  final String message;

  const GeolocationError({required this.message});

  @override
  List<Object?> get props => [message];
}
