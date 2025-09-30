// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      national: json['national'] == null
          ? null
          : NationalAddress.fromJson(json['national'] as Map<String, dynamic>),
      shortCode: json['shortCode'] as String?,
      validated: json['validated'] as bool?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'national': instance.national,
      'shortCode': instance.shortCode,
      'validated': instance.validated,
    };

NationalAddress _$NationalAddressFromJson(Map<String, dynamic> json) =>
    NationalAddress(
      buildingNumber: json['buildingNumber'] as String,
      street: json['street'] as String,
      district: json['district'] as String,
      city: json['city'] as String,
      region: json['region'] as String,
      postalCode: json['postalCode'] as String,
    );

Map<String, dynamic> _$NationalAddressToJson(NationalAddress instance) =>
    <String, dynamic>{
      'buildingNumber': instance.buildingNumber,
      'street': instance.street,
      'district': instance.district,
      'city': instance.city,
      'region': instance.region,
      'postalCode': instance.postalCode,
    };
