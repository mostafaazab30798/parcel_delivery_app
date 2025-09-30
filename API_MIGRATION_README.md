# API Migration Guide

This document outlines the migration of the Flutter app from Firebase to the new Shipping API backend.

## Overview

The app has been migrated to use a RESTful API backend that provides comprehensive CRUD operations for shipments and drivers. The new API supports both national addresses (detailed Saudi addresses) and short codes for simplified addressing.

## New API Features

### Shipments API (`/api/shipments`)

- **POST** - Create shipments with national addresses or short codes
- **GET** - Retrieve all shipments or by tracking number
- **GET** - Get unassigned shipments
- **PUT** - Update shipment details
- **DELETE** - Remove shipments
- **PATCH** - Assign drivers to shipments

### Drivers API (`/api/drivers`)

- **POST** - Create new drivers
- **GET** - Retrieve all drivers or by ID
- **PUT** - Update driver information
- **DELETE** - Remove drivers

## New Data Models

### Address System

The new address system supports two formats:

1. **National Address** - Detailed Saudi address with building number, street, district, city, region, and postal code
2. **Short Code** - Simplified address using a short code (e.g., "KSA-XYZ123")

```dart
class Address {
  final NationalAddress? national;
  final String? shortCode;
}

class NationalAddress {
  final String buildingNumber;
  final String street;
  final String district;
  final String city;
  final String region;
  final String postalCode;
}
```

### Shipment Model

The new shipment model includes:

- Sender and recipient information with addresses
- Shipment type and weight
- Driver assignment
- Tracking number and status
- Creation and update timestamps

### Driver Model

The new driver model includes:

- Name, phone, and license number
- Region and area information
- Status and availability
- Creation and update timestamps

## Architecture Changes

### Service Layer

- `ShipmentApiService` - Handles all shipment API operations
- `DriverApiService` - Handles all driver API operations
- `ApiConfig` - Centralized API configuration and endpoints

### Repository Layer

- `ShipmentRepository` - Business logic layer for shipments
- `DriverRepository` - Business logic layer for drivers

### Bloc Layer

- `ShipmentApiBloc` - State management for shipment operations
- New events and states for API operations

## Usage Examples

### Creating a Shipment with National Address

```dart
final shipment = ApiShipment(
  sender: Sender(
    name: 'Ali Sender',
    phone: '0551234567',
    address: Address(
      national: NationalAddress(
        buildingNumber: '123',
        street: 'King Road',
        district: 'Olaya',
        city: 'Riyadh',
        region: 'Riyadh',
        postalCode: '12345',
      ),
    ),
  ),
  recipient: Recipient(
    name: 'Mohammed Receiver',
    phone: '0569876543',
    address: Address(
      national: NationalAddress(
        buildingNumber: '321',
        street: 'Prince Street',
        district: 'Sulaimaniyah',
        city: 'Jeddah',
        region: 'Makkah',
        postalCode: '54321',
      ),
    ),
  ),
  shipmentType: 'Normal',
  weight: 5.0,
);

// Create shipment using bloc
context.read<ShipmentApiBloc>().add(
  ShipmentApiCreateRequested(shipment),
);
```

### Creating a Shipment with Short Code

```dart
final shipment = ApiShipment(
  sender: Sender(
    name: 'Short Sender',
    phone: '0502223344',
    address: Address(shortCode: 'KSA-XYZ123'),
  ),
  recipient: Recipient(
    name: 'Short Receiver',
    phone: '0599988776',
    address: Address(shortCode: 'KSA-ABC987'),
  ),
  shipmentType: 'Document',
);
```

### Loading Shipments

```dart
// Load all shipments
context.read<ShipmentApiBloc>().add(
  const ShipmentApiLoadRequested(),
);

// Load unassigned shipments
context.read<ShipmentApiBloc>().add(
  const ShipmentApiLoadUnassignedRequested(),
);
```

### Assigning a Driver

```dart
context.read<ShipmentApiBloc>().add(
  ShipmentApiAssignDriverRequested(
    trackingNumber: 'TRACK123',
    driverId: 'DRIVER456',
  ),
);
```

## Testing the API

A test widget has been created at `lib/components/api_test_widget.dart` that demonstrates:

- Creating test shipments
- Loading all shipments
- Loading unassigned shipments
- Deleting shipments
- Error handling

To test the API:

1. Ensure the backend server is running on `localhost:5000`
2. Navigate to the test widget in your app
3. Use the buttons to test different API operations

## Configuration

### API Base URL

The API base URL is configured in `lib/services/api_config.dart`. To change the server:

```dart
class ApiConfig {
  static const String baseUrl = 'http://your-server:5000';
  // ... rest of configuration
}
```

### Environment Variables

For production, consider using environment variables or build configurations to set the API URL.

## Migration Steps

1. **Install Dependencies** - Run `flutter pub get` to install new packages
2. **Generate Code** - Run `flutter pub run build_runner build` to generate JSON serialization code
3. **Update Existing Blocs** - Replace Firebase calls with new API repository calls
4. **Update UI Components** - Modify forms to support new address formats
5. **Test API Integration** - Use the test widget to verify functionality

## Error Handling

The new API services include comprehensive error handling:

- Network errors are caught and re-thrown with descriptive messages
- HTTP status codes are validated
- Repository layer provides additional error context
- Bloc states include failure states for error display

## Next Steps

1. **Authentication** - Add authentication to the API calls
2. **Offline Support** - Implement caching for offline functionality
3. **Real-time Updates** - Consider WebSocket integration for live updates
4. **Performance** - Add pagination for large datasets
5. **Testing** - Create unit tests for API services and repositories

## Troubleshooting

### Common Issues

1. **Connection Refused** - Ensure the backend server is running
2. **JSON Parsing Errors** - Check that the API response matches the expected format
3. **Missing Generated Files** - Run `flutter pub run build_runner build` to generate missing files

### Debug Mode

Enable debug logging in the API services to see detailed request/response information.

## Support

For API-related issues, check:
1. Backend server logs
2. Network connectivity
3. API endpoint configuration
4. Request/response format validation
