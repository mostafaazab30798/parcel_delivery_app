import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_driver.g.dart';

@JsonSerializable()
class ApiDriver extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'phone')
  final String phone;
  @JsonKey(name: 'licenseNumber')
  final String licenseNumber;
  @JsonKey(name: 'region')
  final String region;
  @JsonKey(name: 'Area') // Note: API uses 'Area' with capital A
  final String area;
  @JsonKey(name: 'isAvailable')
  final bool? isAvailable;
  @JsonKey(name: 'assignedShipments')
  final List<String>? assignedShipments;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: '__v')
  final int? version;

  const ApiDriver({
    this.id,
    required this.name,
    required this.phone,
    required this.licenseNumber,
    required this.region,
    required this.area,
    this.isAvailable,
    this.assignedShipments,
    this.createdAt,
    this.version,
  });

  factory ApiDriver.fromJson(Map<String, dynamic> json) =>
      _$ApiDriverFromJson(json);

  Map<String, dynamic> toJson() => _$ApiDriverToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        licenseNumber,
        region,
        area,
        isAvailable,
        assignedShipments,
        createdAt,
        version,
      ];

  ApiDriver copyWith({
    String? id,
    String? name,
    String? phone,
    String? licenseNumber,
    String? region,
    String? area,
    bool? isAvailable,
    List<String>? assignedShipments,
    DateTime? createdAt,
    int? version,
  }) {
    return ApiDriver(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      region: region ?? this.region,
      area: area ?? this.area,
      isAvailable: isAvailable ?? this.isAvailable,
      assignedShipments: assignedShipments ?? this.assignedShipments,
      createdAt: createdAt ?? this.createdAt,
      version: version ?? this.version,
    );
  }
}
