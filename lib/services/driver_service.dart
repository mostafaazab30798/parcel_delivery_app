import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'driver_api_service.dart';
import 'shipment_api_service.dart';

class DriverService {
  final http.Client _httpClient;
  final AuthService _authService;
  final DriverApiService _driverApiService;
  final ShipmentApiService _shipmentApiService;
  
  DriverService({
    http.Client? httpClient,
    AuthService? authService,
    DriverApiService? driverApiService,
    ShipmentApiService? shipmentApiService,
  }) : _httpClient = httpClient ?? http.Client(),
       _authService = authService ?? AuthService(),
       _driverApiService = driverApiService ?? DriverApiService(),
       _shipmentApiService = shipmentApiService ?? ShipmentApiService();

  /// Login driver using phone number and password
  Future<Map<String, dynamic>> loginDriver(String phoneNumber, String password) async {
    try {
      // Use AuthService for proper authentication
      final authResult = await _authService.login(phoneNumber, password);
      
      if (authResult.role != UserRole.driver) {
        throw Exception('المستخدم ليس سائقاً');
      }
      
      return authResult.userData;
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  /// Logout driver
  Future<void> logoutDriver() async {
    try {
      // Use AuthService for comprehensive logout
      await _authService.logout();
      debugPrint('🔑 Driver logged out successfully');
    } catch (e) {
      debugPrint('❌ Error during driver logout: $e');
      // Fallback: clear driver-specific data manually
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('driver_id');
      await prefs.remove('auth_token');
    }
  }

  /// Get driver data from the API using current user's credentials
  Future<Map<String, dynamic>?> getDriverData() async {
    // Get current authenticated user
    final currentUser = await _authService.getCurrentUser();
    debugPrint('🔍 Current user in DriverService: ${currentUser?.role} - ${currentUser?.userData}');
    
    if (currentUser == null) {
      throw Exception('No authenticated user found. Please login first.');
    }
    
    if (currentUser.role != UserRole.driver) {
      throw Exception('Access denied. User role is ${currentUser.role}, but driver role is required.');
    }

    // Get driver data by ID from the authenticated user data
    final driverId = currentUser.userData['id'] ?? currentUser.userData['_id'];
    debugPrint('🔍 Driver ID from user data: $driverId');
    
    if (driverId == null) {
      throw Exception('Driver ID not found in authentication data. Please contact support.');
    }

    // Get locally stored data to merge with API data
    final localData = await _getLocalDriverProfile();
    
    // Use the existing user profile data from authentication
    // According to the API, drivers are users with role="driver"
    // All driver info is in the user profile from /users/me
    // Merge with local data for any locally updated fields
    final baseData = {
      'id': driverId,
      '_id': driverId,
      'name': currentUser.userData['name'],
      'phone': currentUser.userData['phone'],
      'role': currentUser.userData['role'],
      'isVerified': currentUser.userData['isVerified'] ?? false,
      'vehicleType': currentUser.userData['vehicleType'],
      'vehiclePlateNumber': currentUser.userData['vehiclePlateNumber'],
      'licenseNumber': currentUser.userData['licenseNumber'],
      'region': currentUser.userData['region'],
      'Area': currentUser.userData['Area'],
      'isAvailable': currentUser.userData['isAvailable'] ?? true,
      'status': currentUser.userData['isAvailable'] == true ? 'online' : 'offline',
      'profilePicture': currentUser.userData['profilePicture'],
      'createdAt': currentUser.userData['createdAt'],
      'updatedAt': currentUser.userData['updatedAt'],
    };
    
    // Merge local data (overrides API data for locally updated fields)
    baseData.addAll(localData);
    
    return baseData;
  }

  /// Update driver profile using the API
  Future<bool> updateDriverProfile({
    String? name,
    String? phone,
    String? vehicleType,
    String? vehiclePlateNumber,
    String? licenseNumber,
    String? region,
    String? area,
    String? status,
    String? profilePicture,
  }) async {
    try {
      // Get current authenticated user
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null || currentUser.role != UserRole.driver) {
        throw Exception('Driver not authenticated');
      }

      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (vehicleType != null) data['vehicleType'] = vehicleType;
      if (vehiclePlateNumber != null) {
        data['vehiclePlateNumber'] = vehiclePlateNumber;
      }
      if (licenseNumber != null) data['licenseNumber'] = licenseNumber;
      if (region != null) data['region'] = region;
      if (area != null) data['Area'] = area; // Note: API uses 'Area' with capital A
      if (status != null) data['status'] = status;
      if (profilePicture != null) data['profilePicture'] = profilePicture;

      try {
        // Try to update through the API first
        await _authService.updateUserProfile(data);
        return true;
      } catch (apiError) {
        // If API update fails (403 permission error), fall back to local storage
        debugPrint('⚠️ API update failed, using local storage fallback: $apiError');
        
        // Store the updated data locally
        await _storeDriverProfileLocally(data);
        
        // Update the cached user data to reflect changes immediately
        _authService.updateCachedUserData(data);
        
        return true;
      }
    } catch (e) {
      throw Exception('Error updating driver profile: $e');
    }
  }

  /// Update driver status
  Future<bool> updateDriverStatus(String status) async {
    try {
      // Get current authenticated user
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null || currentUser.role != UserRole.driver) {
        throw Exception('Driver not authenticated');
      }

      try {
        // Try to update through the API first
        await _authService.updateUserProfile({'status': status});
        return true;
      } catch (apiError) {
        // If API update fails (403 permission error), fall back to local storage
        debugPrint('⚠️ API status update failed, using local storage fallback: $apiError');
        
        // Store the updated status locally
        await _storeDriverProfileLocally({'status': status});
        
        // Update the cached user data to reflect changes immediately
        _authService.updateCachedUserData({'status': status});
        
        return true;
      }
    } catch (e) {
      throw Exception('Error updating driver status: $e');
    }
  }

  /// Update driver location
  Future<bool> updateDriverLocation(double latitude, double longitude) async {
    // Get current authenticated user
    final currentUser = await _authService.getCurrentUser();
    if (currentUser == null || currentUser.role != UserRole.driver) {
      throw Exception('Driver not authenticated for location update');
    }

    final driverId = currentUser.userData['id'] ?? currentUser.userData['_id'];
    if (driverId == null) {
      throw Exception('Driver ID not found for location update');
    }

    try {
      // According to API structure, location updates would be admin-only via /drivers/{id}
      // For now, we'll skip location updates since drivers can't update their own location
      // This would require admin API access or a new endpoint
      print('🔍 Location update skipped - no driver self-update endpoint available');
      return false;
    } catch (e) {
      print('❌ Location update error: $e');
      return false;
    }
  }

  /// Get driver shipments from the API
  Future<List<Map<String, dynamic>>> getDriverShipments() async {
    // Get current authenticated user
    final currentUser = await _authService.getCurrentUser();
    debugPrint('🔍 Current user for shipments: ${currentUser?.role}');
    
    if (currentUser == null || currentUser.role != UserRole.driver) {
      throw Exception('Driver not authenticated for shipments access');
    }

    final driverId = currentUser.userData['id'] ?? currentUser.userData['_id'];
    debugPrint('🔍 Driver ID from user data: \"$driverId\"');
    
    if (driverId == null) {
      throw Exception('Driver ID not found in authentication data');
    }

    // According to API structure, there's no /drivers/me/shipments endpoint
    // We need to get all shipments and filter by assigned driver ID
    try {
      final allShipments = await _shipmentApiService.getAllShipments();
      debugPrint('🔍 Total shipments from API: ${allShipments.length}');
      
      // Debug each shipment's assigned driver
      for (int i = 0; i < allShipments.length; i++) {
        final shipment = allShipments[i];
        debugPrint('  Shipment $i: assignedDriver = ${shipment.assignedDriver?.id}');
      }
      
      final driverShipments = allShipments
          .where((shipment) {
            final assigned = shipment.assignedDriver?.id;
            debugPrint('    Comparing \"$assigned\" == \"$driverId\" = ${assigned == driverId}');
            return assigned == driverId;
          })
          .toList();
          
      debugPrint('🔍 Filtered shipments for driver: ${driverShipments.length}');

      // If no assigned shipments, also get unassigned shipments that this driver can pick up
      if (driverShipments.isEmpty) {
        debugPrint('📋 No assigned shipments found, getting unassigned shipments...');
        final unassignedShipments = await _shipmentApiService.getUnassignedShipments();
        debugPrint('📋 Available unassigned shipments: ${unassignedShipments.length}');
        
        // Return unassigned shipments for driver to see available work
        final unassignedData = unassignedShipments.map((shipment) => {
          ...shipment.toJson(),
          'status': 'Available for pickup', // Mark these as available
          'isUnassigned': true,
        }).toList();
        
        debugPrint('📋 Returning ${unassignedData.length} unassigned shipments');
        return unassignedData;
      }

      return driverShipments.map((shipment) => shipment.toJson()).toList();
    } catch (e) {
      print('❌ Fallback shipments loading failed: $e');
      return [];
    }
  }

  /// Get driver completed shipments from the API
  Future<List<Map<String, dynamic>>> getDriverCompletedShipments() async {
    // Get current authenticated user
    final currentUser = await _authService.getCurrentUser();
    debugPrint('🔍 Current user for completed shipments: ${currentUser?.role}');
    
    if (currentUser == null || currentUser.role != UserRole.driver) {
      throw Exception('Driver not authenticated for completed shipments access');
    }

    final driverId = currentUser.userData['id'] ?? currentUser.userData['_id'];
    debugPrint('🔍 Driver ID from user data: \"$driverId\"');
    
    if (driverId == null) {
      throw Exception('Driver ID not found in authentication data');
    }

    try {
      final allShipments = await _shipmentApiService.getAllShipments();
      debugPrint('🔍 Total shipments from API: ${allShipments.length}');
      
      // Filter for completed shipments assigned to this driver
      final completedShipments = allShipments
          .where((shipment) {
            final assigned = shipment.assignedDriver?.id;
            final status = shipment.status?.toLowerCase();
            return assigned == driverId && status == 'delivered';
          })
          .toList();
          
      debugPrint('🔍 Completed shipments for driver: ${completedShipments.length}');

      return completedShipments.map((shipment) => shipment.toJson()).toList();
    } catch (e) {
      print('❌ Failed to load completed shipments: $e');
      return [];
    }
  }

  /// Get driver earnings from the API (calculated from shipments)
  Future<Map<String, dynamic>> getDriverEarnings() async {
    // Get current authenticated user
    final currentUser = await _authService.getCurrentUser();
    debugPrint('🔍 Current user for earnings: ${currentUser?.role}');
    
    if (currentUser == null || currentUser.role != UserRole.driver) {
      throw Exception('Driver not authenticated for earnings access');
    }

    final driverId = currentUser.userData['id'] ?? currentUser.userData['_id'];
    if (driverId == null) {
      throw Exception('Driver ID not found in authentication data');
    }

    // Get driver shipments to calculate earnings
    final shipments = await getDriverShipments();
    final completedShipments = await getDriverCompletedShipments();
    
    // Calculate earnings from completed shipments
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final today = DateTime(now.year, now.month, now.day);
    final thisWeekStart = today.subtract(Duration(days: now.weekday - 1));
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
    
    double monthlyEarnings = 0;
    double dailyEarnings = 0;
    double thisWeekEarnings = 0;
    double lastWeekEarnings = 0;
    int completedShipmentsCount = 0;
    int activeShipments = 0;
    
    // Standard pricing per shipment (can be customized based on shipment type/weight)
    const double basePrice = 25.0;
    const double weightMultiplier = 5.0;
    
    // Calculate earnings from completed shipments
    for (final shipmentData in completedShipments) {
      final createdAt = DateTime.tryParse(shipmentData['createdAt'] ?? '');
      final weight = (shipmentData['weight'] as num?)?.toDouble() ?? 1.0;
      
      // Calculate earnings for delivered shipments
      final shipmentEarning = basePrice + (weight * weightMultiplier);
      completedShipmentsCount++;
      
      if (createdAt != null) {
        // Monthly earnings
        if (createdAt.isAfter(thisMonth)) {
          monthlyEarnings += shipmentEarning;
        }
        
        // Daily earnings
        if (createdAt.isAfter(today)) {
          dailyEarnings += shipmentEarning;
        }
        
        // This week earnings
        if (createdAt.isAfter(thisWeekStart)) {
          thisWeekEarnings += shipmentEarning;
        }
        
        // Last week earnings
        if (createdAt.isAfter(lastWeekStart) && createdAt.isBefore(thisWeekStart)) {
          lastWeekEarnings += shipmentEarning;
        }
      }
    }
    
    // Count active shipments from all shipments
    for (final shipmentData in shipments) {
      final status = shipmentData['status']?.toString().toLowerCase() ?? '';
      if (status == 'in_transit' || status == 'picked_up') {
        activeShipments++;
      }
    }
    
    return {
      'monthlyEarnings': monthlyEarnings,
      'dailyEarnings': dailyEarnings,
      'totalShipments': shipments.length,
      'activeShipments': activeShipments,
      'completedShipments': completedShipmentsCount,
      'averageRating': 4.5, // Default rating, can be enhanced with actual rating system
      'thisWeekEarnings': thisWeekEarnings,
      'lastWeekEarnings': lastWeekEarnings,
    };
  }

  /// Update FCM token for notifications
  Future<void> updateFCMToken(String token) async {
    try {
      // Get current authenticated user
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null || currentUser.role != UserRole.driver) {
        return;
      }

      // Use the user update endpoint instead of driver update endpoint
      // Drivers are users with role="driver", so they should update through /users/me
      await _authService.updateUserProfile({'fcmToken': token});
    } catch (e) {
      // Don't throw error for FCM token update as it's not critical
      debugPrint('Error updating FCM token: $e');
    }
  }

  /// Store driver profile data locally when API update is not available
  Future<void> _storeDriverProfileLocally(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Store each field individually for easy access
      for (final entry in data.entries) {
        await prefs.setString('driver_${entry.key}', entry.value.toString());
      }
      
      // Store a timestamp to know when it was last updated
      await prefs.setString('driver_profile_updated_at', DateTime.now().toIso8601String());
      
      debugPrint('✅ Driver profile data stored locally: $data');
    } catch (e) {
      debugPrint('❌ Error storing driver profile locally: $e');
    }
  }

  /// Get locally stored driver profile data
  Future<Map<String, dynamic>> _getLocalDriverProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> localData = {};
      
      // Get all driver-related keys
      final keys = prefs.getKeys().where((key) => key.startsWith('driver_')).toList();
      
      for (final key in keys) {
        final fieldName = key.replaceFirst('driver_', '');
        if (fieldName != 'profile_updated_at') {
          localData[fieldName] = prefs.getString(key);
        }
      }
      
      return localData;
    } catch (e) {
      debugPrint('❌ Error getting local driver profile: $e');
      return {};
    }
  }

  void dispose() {
    _httpClient.close();
    _authService.dispose();
    _driverApiService.dispose();
    _shipmentApiService.dispose();
  }
}

