class ApiConfig {
  // Change this URL to point to your running backend server
  // For local development: 'http://localhost:5000'
  // For remote server: 'http://your-server.com' or 'http://192.168.1.100:5000'
  // For testing with mock server: 'http://localhost:3000'
  static const String baseUrl = 'https://shipping.onetex.com.sa';
  static const String apiVersion = 'api';
  
  // Set this to false to disable mock responses and use real API
  static const bool useMockAuthentication = false;
  
  // Shipment endpoints
  static const String shipments = '/shipments';
  static const String unassignedShipments = '/shipments/unassigned';
  
  // Driver endpoints
  static const String drivers = '/drivers';
  
  // Helper methods
  static String get fullBaseUrl => '$baseUrl/$apiVersion';
  static String get shipmentsUrl => '$fullBaseUrl$shipments';
  static String get unassignedShipmentsUrl => '$fullBaseUrl$unassignedShipments';
  static String get driversUrl => '$fullBaseUrl$drivers';
  
  static String shipmentById(String trackingNumber) => 
      '$fullBaseUrl$shipments/$trackingNumber';
  
  static String assignDriverToShipment(String trackingNumber) => 
      '$fullBaseUrl$shipments/$trackingNumber/assign-driver';
  
  static String driverById(String driverId) => 
      '$fullBaseUrl$drivers/$driverId';
}
