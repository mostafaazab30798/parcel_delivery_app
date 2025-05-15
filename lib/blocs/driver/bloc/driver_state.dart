part of 'driver_bloc.dart';

sealed class DriverState extends Equatable {
  const DriverState();
  
  @override
  List<Object> get props => [];
}

final class DriverInitial extends DriverState {}
