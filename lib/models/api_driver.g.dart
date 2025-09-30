// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiDriver _$ApiDriverFromJson(Map<String, dynamic> json) => ApiDriver(
      id: json['_id'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      licenseNumber: json['licenseNumber'] as String,
      region: json['region'] as String,
      area: json['Area'] as String,
      isAvailable: json['isAvailable'] as bool?,
      assignedShipments: (json['assignedShipments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      version: (json['__v'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ApiDriverToJson(ApiDriver instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'licenseNumber': instance.licenseNumber,
      'region': instance.region,
      'Area': instance.area,
      'isAvailable': instance.isAvailable,
      'assignedShipments': instance.assignedShipments,
      'createdAt': instance.createdAt?.toIso8601String(),
      '__v': instance.version,
    };
