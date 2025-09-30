import 'package:equatable/equatable.dart';
import '../../models/api_shipment.dart';

abstract class ShipmentApiEvent extends Equatable {
  const ShipmentApiEvent();

  @override
  List<Object?> get props => [];
}

class ShipmentApiStarted extends ShipmentApiEvent {
  const ShipmentApiStarted();
}

class ShipmentApiCreateRequested extends ShipmentApiEvent {
  final ApiShipment shipment;

  const ShipmentApiCreateRequested(this.shipment);

  @override
  List<Object?> get props => [shipment];
}

class ShipmentApiLoadRequested extends ShipmentApiEvent {
  const ShipmentApiLoadRequested();
}

class ShipmentApiLoadUnassignedRequested extends ShipmentApiEvent {
  const ShipmentApiLoadUnassignedRequested();
}

class ShipmentApiUpdateRequested extends ShipmentApiEvent {
  final String trackingNumber;
  final Map<String, dynamic> updateData;

  const ShipmentApiUpdateRequested({
    required this.trackingNumber,
    required this.updateData,
  });

  @override
  List<Object?> get props => [trackingNumber, updateData];
}

class ShipmentApiDeleteRequested extends ShipmentApiEvent {
  final String trackingNumber;

  const ShipmentApiDeleteRequested(this.trackingNumber);

  @override
  List<Object?> get props => [trackingNumber];
}

class ShipmentApiAssignDriverRequested extends ShipmentApiEvent {
  final String trackingNumber;
  final String driverId;

  const ShipmentApiAssignDriverRequested({
    required this.trackingNumber,
    required this.driverId,
  });

  @override
  List<Object?> get props => [trackingNumber, driverId];
}
