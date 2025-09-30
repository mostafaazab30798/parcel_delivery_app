import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address extends Equatable {
  @JsonKey(name: 'national')
  final NationalAddress? national;
  @JsonKey(name: 'shortCode')
  final String? shortCode;
  @JsonKey(name: 'validated')
  final bool? validated;

  const Address({
    this.national,
    this.shortCode,
    this.validated,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parsing address JSON: ${json.keys}');
      
      final national = json['national'] != null
          ? NationalAddress.fromJson(json['national'] as Map<String, dynamic>)
          : null;
      print('✅ National Address: ${national?.city}');
      
      final shortCode = json['shortCode'] as String?;
      print('✅ Short Code: $shortCode');
      
      final validated = json['validated'] as bool?;
      print('✅ Validated: $validated');
      
      return Address(
        national: national,
        shortCode: shortCode,
        validated: validated,
      );
    } catch (e, stackTrace) {
      print('❌ Error parsing address JSON: $e');
      print('❌ Stack trace: $stackTrace');
      print('❌ JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  @override
  List<Object?> get props => [national, shortCode, validated];

  Address copyWith({
    NationalAddress? national,
    String? shortCode,
    bool? validated,
  }) {
    return Address(
      national: national ?? this.national,
      shortCode: shortCode ?? this.shortCode,
      validated: validated ?? this.validated,
    );
  }
}

@JsonSerializable()
class NationalAddress extends Equatable {
  @JsonKey(name: 'buildingNumber')
  final String buildingNumber;
  @JsonKey(name: 'street')
  final String street;
  @JsonKey(name: 'district')
  final String district;
  @JsonKey(name: 'city')
  final String city;
  @JsonKey(name: 'region')
  final String region;
  @JsonKey(name: 'postalCode')
  final String postalCode;

  const NationalAddress({
    required this.buildingNumber,
    required this.street,
    required this.district,
    required this.city,
    required this.region,
    required this.postalCode,
  });

  factory NationalAddress.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parsing national address JSON: ${json.keys}');
      
      final buildingNumber = json['buildingNumber']?.toString() ?? '';
      print('✅ Building Number: $buildingNumber');
      
      final street = json['street']?.toString() ?? '';
      print('✅ Street: $street');
      
      final district = json['district']?.toString() ?? '';
      print('✅ District: $district');
      
      final city = json['city']?.toString() ?? '';
      print('✅ City: $city');
      
      final region = json['region']?.toString() ?? '';
      print('✅ Region: $region');
      
      final postalCode = json['postalCode']?.toString() ?? '';
      print('✅ Postal Code: $postalCode');
      
      return NationalAddress(
        buildingNumber: buildingNumber,
        street: street,
        district: district,
        city: city,
        region: region,
        postalCode: postalCode,
      );
    } catch (e, stackTrace) {
      print('❌ Error parsing national address JSON: $e');
      print('❌ Stack trace: $stackTrace');
      print('❌ JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$NationalAddressToJson(this);

  @override
  List<Object?> get props => [
        buildingNumber,
        street,
        district,
        city,
        region,
        postalCode,
      ];

  NationalAddress copyWith({
    String? buildingNumber,
    String? street,
    String? district,
    String? city,
    String? region,
    String? postalCode,
  }) {
    return NationalAddress(
      buildingNumber: buildingNumber ?? this.buildingNumber,
      street: street ?? this.street,
      district: district ?? this.district,
      city: city ?? this.city,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
    );
  }
}
