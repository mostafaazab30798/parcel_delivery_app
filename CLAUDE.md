# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter-based shipping and logistics application with dual user interfaces:
- **User Side**: For customers to create shipments, track packages, and calculate prices
- **Driver Side**: For drivers to manage deliveries, view earnings, and update shipment status

The app has been migrated from Firebase to a custom REST API backend for improved control and scalability.

## Commands

### Development
```bash
# Install dependencies
flutter pub get

# Generate JSON serialization code (required after modifying models)
flutter pub run build_runner build

# Run the app
flutter run

# Run with specific device
flutter run -d chrome  # Web
flutter run -d windows # Windows
flutter run -d macos   # macOS
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

### Build & Deploy
```bash
# Build for Android
flutter build apk --release
flutter build appbundle --release

# Build for iOS
flutter build ios --release

# Build for Web
flutter build web --release

# Build for Windows
flutter build windows --release

# Build for macOS
flutter build macos --release
```

### Code Generation
```bash
# Generate JSON serialization code
flutter pub run build_runner build

# Watch for changes and rebuild
flutter pub run build_runner watch

# Delete conflicting outputs and rebuild
flutter pub run build_runner build --delete-conflicting-outputs
```

## Architecture

### State Management
- **BLoC Pattern**: Primary state management using `flutter_bloc`
- **Provider**: Used for dependency injection and some local state
- **Cubits**: Used for simpler state management (navigation, auth forms)

### Core Directories
- `lib/blocs/`: State management logic
  - `driver/`: Driver-specific BLoC
  - `shipment_api/`: Shipment operations BLoC
  - `geolocation/`: Location tracking BLoC
  - `nav_bar/`: Navigation state management
- `lib/services/`: API services and business logic
  - `api_config.dart`: API endpoint configuration
  - `shipment_api_service.dart`: Shipment API operations
  - `driver_api_service.dart`: Driver API operations
  - `driver_service.dart`: Driver-specific business logic
- `lib/repos/`: Repository pattern for data abstraction
- `lib/models/`: Data models with JSON serialization
- `lib/pages/`: Screen implementations
  - `user/`: Customer-facing screens
  - `driver/`: Driver-facing screens
- `lib/components/`: Reusable UI components
- `lib/app_router/`: GoRouter navigation configuration

### Navigation
- **GoRouter**: Declarative routing with shell routes for nested navigation
- **Shell Routes**: Separate shells for user and driver interfaces
- Initial route: `/driver-home` (configurable in `router.dart`)

### API Configuration
- Base URL: `https://shipping.onetex.com.sa` (configured in `lib/services/api_config.dart`)
- Supports both national addresses (detailed Saudi addresses) and short codes
- Authentication via SharedPreferences tokens

### Data Models
All models use `json_serializable` for automatic JSON parsing:
- `ApiShipment`: Complete shipment data with sender/recipient
- `ApiDriver`: Driver profile and status
- `Address`: Supports both national addresses and short codes
- Generated files (`*.g.dart`) must be regenerated after model changes

### Key Dependencies
- `flutter_bloc`: State management
- `go_router`: Navigation
- `http`: API calls
- `json_annotation` & `json_serializable`: JSON serialization
- `geolocator`: Location services
- `shared_preferences`: Local storage
- `provider`: Dependency injection

## API Integration

### Shipment Endpoints
- `POST /api/shipments` - Create shipment
- `GET /api/shipments` - Get all shipments
- `GET /api/shipments/unassigned` - Get unassigned shipments
- `PUT /api/shipments/{trackingNumber}` - Update shipment
- `DELETE /api/shipments/{trackingNumber}` - Delete shipment
- `PATCH /api/shipments/{trackingNumber}/assign-driver` - Assign driver

### Driver Endpoints
- `GET /api/drivers/{driverId}` - Get driver data
- `PUT /api/drivers/{driverId}` - Update driver profile
- `PATCH /api/drivers/{driverId}/status` - Update status
- `PATCH /api/drivers/{driverId}/location` - Update location
- `GET /api/drivers/{driverId}/shipments` - Get driver shipments
- `GET /api/drivers/{driverId}/earnings` - Get earnings

## Important Notes

- The app currently uses mock data in `DriverBloc` - replace with actual API calls for production
- Authentication tokens should be stored in SharedPreferences after login
- The initial route is set to driver home for development - update for production
- Firebase has been completely removed from the driver side
- User side may still have Firebase references that need migration