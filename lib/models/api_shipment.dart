import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'address.dart';
import 'api_driver.dart';

part 'api_shipment.g.dart';

@JsonSerializable()
class ApiShipment extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'trackingNumber')
  final String? trackingNumber;
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'sender')
  final Sender sender;
  @JsonKey(name: 'recipient')
  final Recipient recipient;
  @JsonKey(name: 'shipmentType')
  final String shipmentType;
  @JsonKey(name: 'weight')
  final double? weight;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'nature')
  final String? nature;
  @JsonKey(name: 'notes')
  final String? notes;
  @JsonKey(name: 'assignedDriver')
  final ApiDriver? assignedDriver;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  @JsonKey(name: 'paymentMethod')
  final String? paymentMethod;

  const ApiShipment({
    this.id,
    this.trackingNumber,
    this.status,
    required this.sender,
    required this.recipient,
    required this.shipmentType,
    this.weight,
    this.description,
    this.nature,
    this.notes,
    this.assignedDriver,
    this.createdAt,
    this.updatedAt,
    this.paymentMethod,
  });

  factory ApiShipment.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parsing shipment JSON: ${json.keys}');
      
      // Debug each field individually
      final id = json['_id'] as String?;
      print('✅ ID: $id');
      
      final trackingNumber = json['trackingNumber'] as String?;
      print('✅ Tracking Number: $trackingNumber');
      
      final status = json['status'] as String?;
      print('✅ Status: $status');
      
      final sender = Sender.fromJson(json['sender'] as Map<String, dynamic>);
      print('✅ Sender: ${sender.name}');
      
      final recipient = Recipient.fromJson(json['recipient'] as Map<String, dynamic>);
      print('✅ Recipient: ${recipient.name}');
      
      final shipmentType = json['shipmentType'] as String;
      print('✅ Shipment Type: $shipmentType');
      
      final weight = json['weight'] != null ? (json['weight'] as num).toDouble() : null;
      print('✅ Weight: $weight');
      
      final description = json['description'] as String?;
      print('✅ Description: $description');
      
      final nature = json['nature'] as String?;
      print('✅ Nature: $nature');
      
      final notes = json['notes'] as String?;
      print('✅ Notes: $notes');
      
      final assignedDriver = json['assignedDriver'] != null
          ? (json['assignedDriver'] is String 
              ? null  // If it's a string ID, we don't parse it as driver object
              : ApiDriver.fromJson(json['assignedDriver'] as Map<String, dynamic>))
          : null;
      print('✅ Assigned Driver: ${assignedDriver?.name}');
      
      final createdAt = json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String) 
          : null;
      print('✅ Created At: $createdAt');
      
      final updatedAt = json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null;
      print('✅ Updated At: $updatedAt');
      
      final paymentMethod = json['paymentMethod'] as String?;
      print('✅ Payment Method: $paymentMethod');
      
      return ApiShipment(
        id: id,
        trackingNumber: trackingNumber,
        status: status,
        sender: sender,
        recipient: recipient,
        shipmentType: shipmentType,
        weight: weight,
        description: description,
        nature: nature,
        notes: notes,
        assignedDriver: assignedDriver,
        createdAt: createdAt,
        updatedAt: updatedAt,
        paymentMethod: paymentMethod,
      );
    } catch (e, stackTrace) {
      print('❌ Error parsing shipment JSON: $e');
      print('❌ Stack trace: $stackTrace');
      print('❌ JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$ApiShipmentToJson(this);

  @override
  List<Object?> get props => [
        id,
        trackingNumber,
        status,
        sender,
        recipient,
        shipmentType,
        weight,
        description,
        nature,
        notes,
        assignedDriver,
        createdAt,
        updatedAt,
        paymentMethod,
      ];

  ApiShipment copyWith({
    String? id,
    String? trackingNumber,
    String? status,
    Sender? sender,
    Recipient? recipient,
    String? shipmentType,
    double? weight,
    String? description,
    String? nature,
    String? notes,
    ApiDriver? assignedDriver,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? paymentMethod,
  }) {
    return ApiShipment(
      id: id ?? this.id,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      status: status ?? this.status,
      sender: sender ?? this.sender,
      recipient: recipient ?? this.recipient,
      shipmentType: shipmentType ?? this.shipmentType,
      weight: weight ?? this.weight,
      description: description ?? this.description,
      nature: nature ?? this.nature,
      notes: notes ?? this.notes,
      assignedDriver: assignedDriver ?? this.assignedDriver,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}

@JsonSerializable()
class Sender extends Equatable {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'phone')
  final String phone;
  @JsonKey(name: 'address')
  final Address address;
  @JsonKey(name: 'notes')
  final String? notes;

  const Sender({
    required this.name,
    required this.phone,
    required this.address,
    this.notes,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parsing sender JSON: ${json.keys}');
      
      final name = json['name'] as String;
      print('✅ Sender Name: $name');
      
      final phone = json['phone'] as String;
      print('✅ Sender Phone: $phone');
      
      final address = Address.fromJson(json['address'] as Map<String, dynamic>);
      print('✅ Sender Address: ${address.national?.city}');
      
      final notes = json['notes'] as String?;
      print('✅ Sender Notes: $notes');
      
      return Sender(
        name: name,
        phone: phone,
        address: address,
        notes: notes,
      );
    } catch (e, stackTrace) {
      print('❌ Error parsing sender JSON: $e');
      print('❌ Stack trace: $stackTrace');
      print('❌ JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$SenderToJson(this);

  @override
  List<Object?> get props => [name, phone, address, notes];

  Sender copyWith({
    String? name,
    String? phone,
    Address? address,
    String? notes,
  }) {
    return Sender(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
    );
  }
}

@JsonSerializable()
class Recipient extends Equatable {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'phone')
  final String phone;
  @JsonKey(name: 'address')
  final Address address;
  @JsonKey(name: 'notes')
  final String? notes;

  const Recipient({
    required this.name,
    required this.phone,
    required this.address,
    this.notes,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parsing recipient JSON: ${json.keys}');
      
      final name = json['name'] as String;
      print('✅ Recipient Name: $name');
      
      final phone = json['phone'] as String;
      print('✅ Recipient Phone: $phone');
      
      final address = Address.fromJson(json['address'] as Map<String, dynamic>);
      print('✅ Recipient Address: ${address.national?.city}');
      
      final notes = json['notes'] as String?;
      print('✅ Recipient Notes: $notes');
      
      return Recipient(
        name: name,
        phone: phone,
        address: address,
        notes: notes,
      );
    } catch (e, stackTrace) {
      print('❌ Error parsing recipient JSON: $e');
      print('❌ Stack trace: $stackTrace');
      print('❌ JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$RecipientToJson(this);

  @override
  List<Object?> get props => [name, phone, address, notes];

  Recipient copyWith({
    String? name,
    String? phone,
    Address? address,
    String? notes,
  }) {
    return Recipient(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
    );
  }
}
