import 'package:equatable/equatable.dart';
import '../../models/api_shipment.dart';

sealed class ShipmentApiState extends Equatable {
  const ShipmentApiState();

  @override
  List<Object?> get props => [];
}

class ShipmentApiInitial extends ShipmentApiState {
  const ShipmentApiInitial();
}

class ShipmentApiLoading extends ShipmentApiState {
  const ShipmentApiLoading();
}

class ShipmentApiSuccess extends ShipmentApiState {
  final List<ApiShipment> shipments;

  const ShipmentApiSuccess(this.shipments);

  @override
  List<Object?> get props => [shipments];
}

class ShipmentApiFailure extends ShipmentApiState {
  final String message;

  const ShipmentApiFailure(this.message);

  @override
  List<Object?> get props => [message];
}
