import '../models/api_shipment.dart';
import '../services/shipment_api_service.dart';

class ShipmentRepository {
  final ShipmentApiService _apiService;

  ShipmentRepository({ShipmentApiService? apiService})
      : _apiService = apiService ?? ShipmentApiService();

  /// Create a new shipment
  Future<ApiShipment> createShipment(ApiShipment shipment) async {
    try {
      return await _apiService.createShipment(shipment);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get all shipments
  Future<List<ApiShipment>> getAllShipments() async {
    try {
      return await _apiService.getAllShipments();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get shipment by tracking number
  Future<ApiShipment> getShipmentByTrackingNumber(String trackingNumber) async {
    try {
      return await _apiService.getShipmentByTrackingNumber(trackingNumber);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get unassigned shipments
  Future<List<ApiShipment>> getUnassignedShipments() async {
    try {
      return await _apiService.getUnassignedShipments();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Update shipment
  Future<ApiShipment> updateShipment(
    String trackingNumber,
    Map<String, dynamic> updateData,
  ) async {
    try {
      return await _apiService.updateShipment(trackingNumber, updateData);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Delete shipment
  Future<void> deleteShipment(String trackingNumber) async {
    try {
      await _apiService.deleteShipment(trackingNumber);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Assign driver to shipment
  Future<ApiShipment> assignDriverToShipment(
    String trackingNumber,
    String driverId,
  ) async {
    try {
      return await _apiService.assignDriverToShipment(trackingNumber, driverId);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  void dispose() {
    _apiService.dispose();
  }
}
