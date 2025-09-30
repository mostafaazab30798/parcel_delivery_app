import '../models/api_driver.dart';
import '../services/driver_api_service.dart';

class DriverRepository {
  final DriverApiService _apiService;

  DriverRepository({DriverApiService? apiService})
      : _apiService = apiService ?? DriverApiService();

  /// Create a new driver
  Future<ApiDriver> createDriver(ApiDriver driver) async {
    try {
      return await _apiService.createDriver(driver);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get all drivers
  Future<List<ApiDriver>> getAllDrivers() async {
    try {
      return await _apiService.getAllDrivers();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get driver by ID
  Future<ApiDriver> getDriverById(String driverId) async {
    try {
      return await _apiService.getDriverById(driverId);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Update driver
  Future<ApiDriver> updateDriver(
    String driverId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      return await _apiService.updateDriver(driverId, updateData);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Delete driver
  Future<void> deleteDriver(String driverId) async {
    try {
      await _apiService.deleteDriver(driverId);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  void dispose() {
    _apiService.dispose();
  }
}
