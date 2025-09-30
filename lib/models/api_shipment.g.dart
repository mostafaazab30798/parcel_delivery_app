// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_shipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiShipment _$ApiShipmentFromJson(Map<String, dynamic> json) => ApiShipment(
      id: json['_id'] as String?,
      trackingNumber: json['trackingNumber'] as String?,
      status: json['status'] as String?,
      sender: Sender.fromJson(json['sender'] as Map<String, dynamic>),
      recipient: Recipient.fromJson(json['recipient'] as Map<String, dynamic>),
      shipmentType: json['shipmentType'] as String,
      weight: (json['weight'] as num?)?.toDouble(),
      description: json['description'] as String?,
      nature: json['nature'] as String?,
      notes: json['notes'] as String?,
      assignedDriver: json['assignedDriver'] == null
          ? null
          : ApiDriver.fromJson(json['assignedDriver'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      paymentMethod: json['paymentMethod'] as String?,
    );

Map<String, dynamic> _$ApiShipmentToJson(ApiShipment instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'trackingNumber': instance.trackingNumber,
      'status': instance.status,
      'sender': instance.sender,
      'recipient': instance.recipient,
      'shipmentType': instance.shipmentType,
      'weight': instance.weight,
      'description': instance.description,
      'nature': instance.nature,
      'notes': instance.notes,
      'assignedDriver': instance.assignedDriver,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'paymentMethod': instance.paymentMethod,
    };

Sender _$SenderFromJson(Map<String, dynamic> json) => Sender(
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$SenderToJson(Sender instance) => <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'notes': instance.notes,
    };

Recipient _$RecipientFromJson(Map<String, dynamic> json) => Recipient(
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$RecipientToJson(Recipient instance) => <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'notes': instance.notes,
    };
