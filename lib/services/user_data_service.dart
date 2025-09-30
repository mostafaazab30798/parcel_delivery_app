import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/address.dart';
import '../models/api_shipment.dart';

class UserDataService {
  static const String _senderDataKey = 'saved_sender_data';
  static const String _recipientDataKey = 'saved_recipient_data';
  static const String _addressesListKey = 'saved_recipient_addresses_list';
  
  static UserDataService? _instance;
  SharedPreferences? _prefs;
  
  UserDataService._internal();
  
  static UserDataService get instance {
    _instance ??= UserDataService._internal();
    return _instance!;
  }
  
  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Sender data methods (for profile information)
  Future<bool> saveSenderData(Sender senderData) async {
    try {
      await _initPrefs();
      final senderJson = senderData.toJson();
      final success = await _prefs!.setString(_senderDataKey, jsonEncode(senderJson));
      print('💾 Sender data saved: $success');
      return success;
    } catch (e) {
      print('❌ Failed to save sender data: $e');
      return false;
    }
  }

  Future<Sender?> loadSenderData() async {
    try {
      await _initPrefs();
      final senderDataString = _prefs!.getString(_senderDataKey);
      if (senderDataString == null) {
        print('📭 No saved sender data found');
        return null;
      }
      
      final senderJson = jsonDecode(senderDataString) as Map<String, dynamic>;
      final senderData = Sender.fromJson(senderJson);
      print('📥 Sender data loaded: ${senderData.name}');
      return senderData;
    } catch (e) {
      print('❌ Failed to load sender data: $e');
      return null;
    }
  }

  Future<bool> hasSavedSenderData() async {
    try {
      await _initPrefs();
      final hasData = _prefs!.containsKey(_senderDataKey);
      print('🔍 Has saved sender data: $hasData');
      return hasData;
    } catch (e) {
      print('❌ Failed to check for saved sender data: $e');
      return false;
    }
  }

  Future<bool> deleteSenderData() async {
    try {
      await _initPrefs();
      final success = await _prefs!.remove(_senderDataKey);
      print('🗑️ Sender data deleted: $success');
      return success;
    } catch (e) {
      print('❌ Failed to delete sender data: $e');
      return false;
    }
  }

  Future<Map<String, String>> getSenderDataAsMap() async {
    try {
      final senderData = await loadSenderData();
      if (senderData == null) return {};

      return {
        'name': senderData.name,
        'phone': senderData.phone,
        'shortAddress': senderData.address.shortCode ?? '',
        'buildingNumber': senderData.address.national?.buildingNumber ?? '',
        'unitNumber': senderData.address.national?.street ?? '', // Using street field for unit number
        'postalCode': senderData.address.national?.postalCode ?? '',
        'city': senderData.address.national?.city ?? '',
        'district': senderData.address.national?.district ?? '',
        'address': senderData.notes ?? '', // Additional detailed address
        'notes': senderData.notes ?? '',
      };
    } catch (e) {
      print('❌ Failed to get sender data as map: $e');
      return {};
    }
  }

  Future<bool> saveSenderDataFromMap({
    required String name,
    required String phone,
    required String shortAddress,
    required String buildingNumber,
    required String unitNumber,
    required String postalCode,
    String? city,
    String? district,
    String? address,
    String? notes,
  }) async {
    try {
      final senderData = Sender(
        name: name,
        phone: phone,
        address: Address(
          shortCode: shortAddress,
          national: NationalAddress(
            buildingNumber: buildingNumber,
            street: unitNumber, // Using street field to store unit number
            district: district ?? '',
            city: city ?? '',
            region: city ?? '', // Using city for region as well
            postalCode: postalCode,
          ),
        ),
        notes: address, // Store detailed address in notes
      );
      
      return await saveSenderData(senderData);
    } catch (e) {
      print('❌ Failed to save sender data from map: $e');
      return false;
    }
  }

  // Recipient data methods (for saved addresses)
  Future<bool> saveRecipientData(Recipient recipientData) async {
    try {
      await _initPrefs();
      final recipientJson = recipientData.toJson();
      final success = await _prefs!.setString(_recipientDataKey, jsonEncode(recipientJson));
      print('💾 Recipient data saved: $success');
      return success;
    } catch (e) {
      print('❌ Failed to save recipient data: $e');
      return false;
    }
  }

  Future<Recipient?> loadRecipientData() async {
    try {
      await _initPrefs();
      final recipientDataString = _prefs!.getString(_recipientDataKey);
      if (recipientDataString == null) {
        print('📭 No saved recipient data found');
        return null;
      }
      
      final recipientJson = jsonDecode(recipientDataString) as Map<String, dynamic>;
      final recipientData = Recipient.fromJson(recipientJson);
      print('📥 Recipient data loaded: ${recipientData.name}');
      return recipientData;
    } catch (e) {
      print('❌ Failed to load recipient data: $e');
      return null;
    }
  }

  Future<bool> hasSavedRecipientData() async {
    try {
      await _initPrefs();
      final hasData = _prefs!.containsKey(_recipientDataKey);
      print('🔍 Has saved recipient data: $hasData');
      return hasData;
    } catch (e) {
      print('❌ Failed to check for saved recipient data: $e');
      return false;
    }
  }

  Future<bool> deleteRecipientData() async {
    try {
      await _initPrefs();
      final success = await _prefs!.remove(_recipientDataKey);
      print('🗑️ Recipient data deleted: $success');
      return success;
    } catch (e) {
      print('❌ Failed to delete recipient data: $e');
      return false;
    }
  }

  Future<Map<String, String>> getRecipientDataAsMap() async {
    try {
      final recipientData = await loadRecipientData();
      if (recipientData == null) return {};

      final result = {
        'name': recipientData.name,
        'phone': recipientData.phone,
        'shortAddress': recipientData.address.shortCode ?? '',
        'buildingNumber': recipientData.address.national?.buildingNumber ?? '',
        'unitNumber': recipientData.address.national?.street ?? '', // Using street field for unit number
        'postalCode': recipientData.address.national?.postalCode ?? '',
        'city': recipientData.address.national?.city ?? '',
        'district': recipientData.address.national?.district ?? '',
        'address': recipientData.notes ?? '', // Additional detailed address
        'notes': recipientData.notes ?? '',
      };
      
      print('🔍 getRecipientDataAsMap result:');
      print('  shortAddress: ${result['shortAddress']}');
      print('  buildingNumber: ${result['buildingNumber']}');
      print('  unitNumber: ${result['unitNumber']}');
      print('  postalCode: ${result['postalCode']}');
      
      return result;
    } catch (e) {
      print('❌ Failed to get recipient data as map: $e');
      return {};
    }
  }

  Future<bool> saveRecipientDataFromMap({
    required String name,
    required String phone,
    required String shortAddress,
    required String buildingNumber,
    required String unitNumber,
    required String postalCode,
    required String city,
    required String district,
    String? address,
    String? notes,
  }) async {
    try {
      final recipientData = Recipient(
        name: name,
        phone: phone,
        address: Address(
          shortCode: shortAddress,
          national: NationalAddress(
            buildingNumber: buildingNumber,
            street: unitNumber, // Using street field to store unit number
            district: district,
            city: city,
            region: city, // Using city for region as well
            postalCode: postalCode,
          ),
        ),
        notes: address, // Store detailed address in notes
      );
      
      return await saveRecipientData(recipientData);
    } catch (e) {
      print('❌ Failed to save recipient data from map: $e');
      return false;
    }
  }

  // Multiple recipient addresses management (separate from profile data)
  Future<List<Map<String, String>>> loadAllAddresses() async {
    try {
      await _initPrefs();
      final addressesString = _prefs!.getString(_addressesListKey);
      if (addressesString == null) {
        print('📭 No saved recipient addresses found');
        return [];
      }
      
      final addressesList = jsonDecode(addressesString) as List;
      final addresses = addressesList.map((addr) => Map<String, String>.from(addr)).toList();
      print('📥 Loaded ${addresses.length} recipient addresses');
      for (int i = 0; i < addresses.length; i++) {
        final addr = addresses[i];
        print('  Address $i: ${addr['name']} - Short: ${addr['shortAddress']}, Building: ${addr['buildingNumber']}, Unit: ${addr['unitNumber']}, Postal: ${addr['postalCode']}');
      }
      return addresses;
    } catch (e) {
      print('❌ Failed to load recipient addresses: $e');
      return [];
    }
  }

  Future<bool> saveAllAddresses(List<Map<String, String>> addresses) async {
    try {
      await _initPrefs();
      final addressesString = jsonEncode(addresses);
      final success = await _prefs!.setString(_addressesListKey, addressesString);
      print('💾 All addresses saved: $success');
      return success;
    } catch (e) {
      print('❌ Failed to save addresses: $e');
      return false;
    }
  }

  Future<bool> addAddress(Map<String, String> address) async {
    try {
      print('💾 Adding address:');
      print('  Name: ${address['name']}');
      print('  Phone: ${address['phone']}');
      print('  Short Address: ${address['shortAddress']}');
      print('  Building Number: ${address['buildingNumber']}');
      print('  Unit Number: ${address['unitNumber']}');
      print('  Postal Code: ${address['postalCode']}');
      print('  City: ${address['city']}');
      print('  District: ${address['district']}');
      print('  Address: ${address['address']}');
      
      final addresses = await loadAllAddresses();
      addresses.add(address);
      return await saveAllAddresses(addresses);
    } catch (e) {
      print('❌ Failed to add address: $e');
      return false;
    }
  }

  Future<bool> deleteAddressAtIndex(int index) async {
    try {
      final addresses = await loadAllAddresses();
      if (index >= 0 && index < addresses.length) {
        addresses.removeAt(index);
        return await saveAllAddresses(addresses);
      }
      return false;
    } catch (e) {
      print('❌ Failed to delete address: $e');
      return false;
    }
  }

  Future<bool> updateAddressAtIndex(int index, Map<String, String> updatedAddress) async {
    try {
      print('🔄 Updating address at index $index:');
      print('  Name: ${updatedAddress['name']}');
      print('  Phone: ${updatedAddress['phone']}');
      print('  Short Address: ${updatedAddress['shortAddress']}');
      print('  Building Number: ${updatedAddress['buildingNumber']}');
      print('  Unit Number: ${updatedAddress['unitNumber']}');
      print('  Postal Code: ${updatedAddress['postalCode']}');
      print('  City: ${updatedAddress['city']}');
      print('  District: ${updatedAddress['district']}');
      print('  Address: ${updatedAddress['address']}');
      
      final addresses = await loadAllAddresses();
      if (index >= 0 && index < addresses.length) {
        addresses[index] = updatedAddress;
        return await saveAllAddresses(addresses);
      }
      print('❌ Invalid index: $index (total addresses: ${addresses.length})');
      return false;
    } catch (e) {
      print('❌ Failed to update address: $e');
      return false;
    }
  }
}