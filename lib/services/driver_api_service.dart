import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_driver.dart';
import 'auth_service.dart';

class DriverApiService {
  final http.Client _httpClient;
  final AuthService _authService;

  DriverApiService({http.Client? httpClient, AuthService? authService})
      : _httpClient = httpClient ?? http.Client(),
        _authService = authService ?? AuthService();

  /// Create a new driver
  Future<ApiDriver> createDriver(ApiDriver driver) async {
    try {
      final response = await _authService.authenticatedRequest(
        method: 'POST',
        endpoint: '/drivers',
        body: driver.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiDriver.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create driver: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating driver: $e');
    }
  }

  /// Get all drivers
  Future<List<ApiDriver>> getAllDrivers() async {
    try {
      final response = await _authService.authenticatedRequest(
        method: 'GET',
        endpoint: '/drivers',
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => ApiDriver.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get drivers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting drivers: $e');
    }
  }

  /// Get driver by ID
  Future<ApiDriver> getDriverById(String driverId) async {
    try {
      final response = await _authService.authenticatedRequest(
        method: 'GET',
        endpoint: '/drivers/$driverId',
      );

      print('🔍 Get driver response: ${response.statusCode}');
      print('🔍 Response body: ${response.body}');

      if (response.statusCode == 200) {
        return ApiDriver.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get driver: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting driver: $e');
    }
  }

  /// Update driver
  Future<ApiDriver> updateDriver(
    String driverId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final response = await _authService.authenticatedRequest(
        method: 'PUT',
        endpoint: '/drivers/$driverId',
        body: updateData,
      );

      print('🔍 Update driver response: ${response.statusCode}');
      print('🔍 Response body: ${response.body}');

      if (response.statusCode == 200) {
        return ApiDriver.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update driver: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating driver: $e');
    }
  }

  /// Delete driver
  Future<void> deleteDriver(String driverId) async {
    try {
      final response = await _authService.authenticatedRequest(
        method: 'DELETE',
        endpoint: '/drivers/$driverId',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete driver: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting driver: $e');
    }
  }

  void dispose() {
    _httpClient.close();
    _authService.dispose();
  }
}
