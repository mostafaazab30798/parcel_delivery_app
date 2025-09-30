import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_shipment.dart';
import 'api_config.dart';
import 'auth_service.dart';

class ShipmentApiService {
  final http.Client _httpClient;
  final AuthService _authService;

  ShipmentApiService({http.Client? httpClient, AuthService? authService})
      : _httpClient = httpClient ?? http.Client(),
        _authService = authService ?? AuthService();

  /// Create a new shipment
  Future<ApiShipment> createShipment(ApiShipment shipment) async {
    try {
      final requestBody = shipment.toJson();
      print('🚀 Creating shipment with data: ${jsonEncode(requestBody)}');
      
      final response = await _authService.authenticatedRequest(
        method: 'POST',
        endpoint: '/shipments',
        body: requestBody,
      );

      print('📡 Server response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Check if the response has the expected format
        if (responseData['success'] == true && responseData['data'] != null) {
          return ApiShipment.fromJson(responseData['data']);
        } else {
          throw Exception('Invalid response format: ${response.body}');
        }
      } else {
        throw Exception('Failed to create shipment: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error creating shipment: $e');
      throw Exception('Error creating shipment: $e');
    }
  }

  /// Get all shipments
  Future<List<ApiShipment>> getAllShipments() async {
    try {
      print('📡 Fetching all shipments from: ${ApiConfig.shipmentsUrl}');
      
      final response = await _authService.authenticatedRequest(
        method: 'GET',
        endpoint: '/shipments',
      );

      print('📡 Server response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Check if the response has the expected format
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> jsonList = responseData['data'];
          return jsonList.map((json) => ApiShipment.fromJson(json)).toList();
        } else {
          throw Exception('Invalid response format: ${response.body}');
        }
      } else {
        throw Exception('Failed to get shipments: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error getting shipments: $e');
      throw Exception('Error getting shipments: $e');
    }
  }

  /// Get shipment by tracking number
  Future<ApiShipment> getShipmentByTrackingNumber(String trackingNumber) async {
    try {
      final response = await _authService.authenticatedRequest(
        method: 'GET',
        endpoint: '/shipments/$trackingNumber',
      );

      if (response.statusCode == 200) {
        return ApiShipment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get shipment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting shipment: $e');
    }
  }

  /// Get unassigned shipments
  Future<List<ApiShipment>> getUnassignedShipments() async {
    try {
      final response = await _authService.authenticatedRequest(
        method: 'GET',
        endpoint: '/shipments/unassigned',
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => ApiShipment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get unassigned shipments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting unassigned shipments: $e');
    }
  }

  /// Update shipment
  Future<ApiShipment> updateShipment(
    String trackingNumber,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final response = await _authService.authenticatedRequest(
        method: 'PUT',
        endpoint: '/shipments/$trackingNumber',
        body: updateData,
      );

      if (response.statusCode == 200) {
        return ApiShipment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update shipment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating shipment: $e');
    }
  }

  /// Delete shipment
  Future<void> deleteShipment(String trackingNumber) async {
    try {
      final response = await _authService.authenticatedRequest(
        method: 'DELETE',
        endpoint: '/shipments/$trackingNumber',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete shipment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting shipment: $e');
    }
  }

  /// Assign driver to shipment
  Future<ApiShipment> assignDriverToShipment(
    String trackingNumber,
    String driverId,
  ) async {
    try {
      final response = await _authService.authenticatedRequest(
        method: 'PATCH',
        endpoint: '/shipments/$trackingNumber/assign-driver',
        body: {'driverId': driverId},
      );

      if (response.statusCode == 200) {
        return ApiShipment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to assign driver: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error assigning driver: $e');
    }
  }

  void dispose() {
    _httpClient.close();
    _authService.dispose();
  }
}
