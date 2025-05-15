import 'package:equatable/equatable.dart';

class Shipment extends Equatable {
  final int? id;
  final String? trackingNumber;
  final String? status;
  final String? pickupAddress;
  final String? deliveryAddress;
  final DateTime? pickupDate;
  final DateTime? deliveryDate;
  final double? weight;
  final String? description;
  final int? driverId;
  final String? customerName;
  final String? customerPhone;
  final double? price;
  final String? paymentStatus;
  final String? type;

  const Shipment({
    this.id,
    this.trackingNumber,
    this.status,
    this.pickupAddress,
    this.deliveryAddress,
    this.pickupDate,
    this.deliveryDate,
    this.weight,
    this.description,
    this.driverId,
    this.customerName,
    this.customerPhone,
    this.price,
    this.paymentStatus,
    this.type,
  });

  @override
  List<Object?> get props => [
        id,
        trackingNumber,
        status,
        pickupAddress,
        deliveryAddress,
        pickupDate,
        deliveryDate,
        weight,
        description,
        driverId,
        customerName,
        customerPhone,
        price,
        paymentStatus,
      ];

  Shipment copyWith({
    int? id,
    String? trackingNumber,
    String? status,
    String? pickupAddress,
    String? deliveryAddress,
    DateTime? pickupDate,
    DateTime? deliveryDate,
    double? weight,
    String? description,
    int? driverId,
    String? customerName,
    String? customerPhone,
    double? price,
    String? paymentStatus,
  }) {
    return Shipment(
      id: id ?? this.id,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      status: status ?? this.status,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      pickupDate: pickupDate ?? this.pickupDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      weight: weight ?? this.weight,
      description: description ?? this.description,
      driverId: driverId ?? this.driverId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      price: price ?? this.price,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }
}
