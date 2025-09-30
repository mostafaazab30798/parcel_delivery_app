import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

enum UserRole { user, driver, admin }

class AuthResult {
  final UserRole role;
  final Map<String, dynamic> userData;
  final String token;
  
  AuthResult({required this.role, required this.userData, required this.token});
}

class AuthService {
  final http.Client _httpClient = http.Client();
  
  // Cache the current user to prevent infinite loops
  AuthResult? _cachedUser;
  DateTime? _cacheTime;

  /// Register new user - returns OTP for verification
  Future<String> register(String phoneNumber, String password, {String? role}) async {
    debugPrint('🔥 REGISTER METHOD CALLED!');
    try {
      final requestBody = {
        'phone': phoneNumber,
        'password': password,
        if (role != null) 'role': role,
      };
      
      debugPrint('📝 Registration request:');
      debugPrint('  Phone: $phoneNumber');
      debugPrint('  Role: $role');
      debugPrint('  Full body: $requestBody');
      
      final response = await _httpClient.post(
        Uri.parse('${ApiConfig.fullBaseUrl}/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('📝 Registration response status: ${response.statusCode}');
      debugPrint('📝 Registration response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = jsonDecode(response.body);
          debugPrint('📝 Registration successful, user created with role: ${data['user']?['role'] ?? 'not found'}');
          // Return OTP for testing/verification
          return data['otp'] ?? data['data']?['otp'] ?? '';
        } catch (jsonError) {
          // If JSON parsing fails, this indicates a server error
          debugPrint('JSON parsing error: ${jsonError.toString()}');
          throw Exception('استجابة غير صحيحة من الخادم - يرجى المحاولة لاحقاً');
        }
      } else {
        // Handle non-success status codes
        debugPrint('Registration failed with status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        
        if (response.statusCode == 409) {
          // Phone number already exists
          throw Exception('رقم الجوال مسجل مسبقاً. يرجى تسجيل الدخول بدلاً من إنشاء حساب جديد');
        } else if (response.statusCode == 400) {
          // Bad request - validation error
          try {
            final error = jsonDecode(response.body);
            throw Exception(error['message'] ?? 'بيانات غير صحيحة. يرجى التحقق من البيانات المدخلة');
          } catch (jsonError) {
            throw Exception('بيانات غير صحيحة. يرجى التحقق من البيانات المدخلة');
          }
        } else {
          // Other errors
          try {
            final error = jsonDecode(response.body);
            throw Exception(error['message'] ?? 'فشل في إنشاء الحساب');
          } catch (jsonError) {
            // If error response isn't JSON, show status code error
            throw Exception('خطأ في الخادم: ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      debugPrint('Network error during registration: ${e.toString()}');
      
      // Check for specific network errors and provide helpful messages
      if (e.toString().contains('SocketException')) {
        throw Exception('لا يمكن الاتصال بالخادم - تأكد من اتصالك بالإنترنت وأن الخادم يعمل');
      }
      if (e.toString().contains('Connection refused')) {
        throw Exception('الخادم غير متاح - تأكد من تشغيل الخادم على localhost:5000');
      }
      
      throw Exception('خطأ في الاتصال بالخادم: ${e.toString()}');
    }
  }

  /// Verify OTP and get JWT token
  Future<AuthResult> verifyOTP(String phoneNumber, String otp) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('${ApiConfig.fullBaseUrl}/auth/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone': phoneNumber,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final token = data['token'] ?? data['data']?['token'];
          
          if (token == null) {
            throw Exception('لم يتم الحصول على رمز المصادقة');
          }

          // Store token and get user profile
          await _storeToken(token);
          final userProfile = await _getUserProfile(token);
          
          final role = _parseUserRole(userProfile['role']);
          
          return AuthResult(
            role: role,
            userData: userProfile,
            token: token,
          );
        } catch (jsonError) {
          debugPrint('JSON parsing error in OTP verification: ${jsonError.toString()}');
          throw Exception('استجابة غير صحيحة من الخادم - يرجى المحاولة لاحقاً');
        }
      } else {
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['message'] ?? 'رمز التحقق غير صحيح');
        } catch (jsonError) {
          // Server response isn't JSON, return generic error
          throw Exception('خطأ في الخادم - يرجى المحاولة لاحقاً');
        }
      }
    } catch (e) {
      debugPrint('Network error during OTP verification: ${e.toString()}');
      
      // Check for specific network errors and provide helpful messages
      if (e.toString().contains('SocketException')) {
        throw Exception('لا يمكن الاتصال بالخادم - تأكد من اتصالك بالإنترنت وأن الخادم يعمل');
      }
      if (e.toString().contains('Connection refused')) {
        throw Exception('الخادم غير متاح - تأكد من تشغيل الخادم على localhost:5000');
      }
      
      throw Exception('خطأ في التحقق: ${e.toString()}');
    }
  }

  /// Login directly with phone and password
  Future<AuthResult> login(String phoneNumber, String password) async {
    try {
      debugPrint('🔑 Attempting login for phone: $phoneNumber');
      
      final response = await _httpClient.post(
        Uri.parse('${ApiConfig.fullBaseUrl}/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone': phoneNumber,
          'password': password,
        }),
      );

      debugPrint('🔑 Login response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] ?? data['data']?['token'];
        
        if (token == null) {
          throw Exception('لم يتم الحصول على رمز المصادقة');
        }

        // Clear cache before storing new token
        _cachedUser = null;
        _cacheTime = null;
        
        // Store token and get user profile
        await _storeToken(token);
        final userProfile = await _getUserProfile(token);
        
        final role = _parseUserRole(userProfile['role']);
        debugPrint('🔑 Login successful');
        debugPrint('  - Phone: $phoneNumber');
        debugPrint('  - API Role: "${userProfile['role']}"');
        debugPrint('  - Parsed Role: $role');
        debugPrint('  - Should go to: ${role == UserRole.driver ? "DRIVER HOME" : "USER HOME"}');
        
        final authResult = AuthResult(
          role: role,
          userData: userProfile,
          token: token,
        );
        
        // Update cache with new user
        _cachedUser = authResult;
        _cacheTime = DateTime.now();
        
        return authResult;
      } else {
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['message'] ?? 'بيانات الدخول غير صحيحة');
        } catch (e) {
          if (response.statusCode == 404) {
            throw Exception('رقم الجوال غير مسجل. يرجى التسجيل أولاً');
          } else if (response.statusCode == 401) {
            throw Exception('كلمة المرور غير صحيحة');
          } else {
            throw Exception('خطأ في تسجيل الدخول. يرجى المحاولة لاحقاً');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Login error: ${e.toString()}');
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('خطأ في تسجيل الدخول: ${e.toString()}');
    }
  }

  /// Simplified login for phone number only - attempts login with default password
  /// For production, this should use OTP authentication
  Future<AuthResult> loginWithPhoneOnly(String phoneNumber) async {
    try {
      // First try to login with a default password pattern
      // This is for development only - production should use OTP
      String defaultPassword = '123456'; // Common default password for testing
      
      try {
        // Try actual login with default password
        return await login(phoneNumber, defaultPassword);
      } catch (e) {
        // If default password fails, try another common pattern
        try {
          defaultPassword = phoneNumber; // Some users use their phone as password
          return await login(phoneNumber, defaultPassword);
        } catch (e2) {
          // If both fail, provide helpful error
          throw Exception('يرجى إدخال كلمة المرور. إذا نسيت كلمة المرور، استخدم خيار إعادة تعيين كلمة المرور');
        }
      }
    } catch (e) {
      throw Exception('خطأ في تسجيل الدخول: ${e.toString()}');
    }
  }

  /// Get user profile from token
  Future<Map<String, dynamic>> _getUserProfile(String token) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiConfig.fullBaseUrl}/users/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('📋 Full API response: $data');
        
        // Handle both nested and flat response structures
        final userData = data['data'] ?? data['user'] ?? data;
        debugPrint('🔍 User profile received:');
        debugPrint('  - Role: "${userData['role']}"');
        debugPrint('  - ID: ${userData['_id'] ?? userData['id']}');
        debugPrint('  - Phone: ${userData['phone']}');
        debugPrint('  - Name: ${userData['name']}');
        
        return userData;
      } else if (response.statusCode == 401) {
        throw Exception('جلسة العمل منتهية. يرجى تسجيل الدخول مرة أخرى');
      } else {
        throw Exception('فشل في الحصول على بيانات المستخدم');
      }
    } catch (e) {
      if (e.toString().contains('جلسة العمل منتهية')) {
        rethrow;
      }
      throw Exception('خطأ في الحصول على الملف الشخصي: ${e.toString()}');
    }
  }

  /// Store JWT token in SharedPreferences
  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  /// Get stored JWT token
  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  /// Parse user role from string
  UserRole _parseUserRole(String? roleString) {
    debugPrint('🔍 Parsing role string: "$roleString"');
    
    // Handle various role formats from API
    final normalizedRole = roleString?.toLowerCase().trim();
    
    switch (normalizedRole) {
      case 'driver':
        debugPrint('✅ Detected DRIVER role');
        return UserRole.driver;
      case 'admin':
        debugPrint('✅ Detected ADMIN role');
        return UserRole.admin;
      case 'user':
      case 'client':
      case 'customer':
        debugPrint('✅ Detected USER role');
        return UserRole.user;
      default:
        debugPrint('⚠️ Unknown role "$roleString", defaulting to USER');
        return UserRole.user;
    }
  }

  /// Check if user is logged in and return their data
  Future<AuthResult?> getCurrentUser() async {
    try {
      // Return cached user if available and recent (within 30 seconds)
      if (_cachedUser != null && _cacheTime != null) {
        final timeDiff = DateTime.now().difference(_cacheTime!);
        if (timeDiff.inSeconds < 30) {
          return _cachedUser;
        }
      }
      
      final token = await getStoredToken();
      if (token == null) {
        debugPrint('🔍 No stored token found');
        _cachedUser = null;
        _cacheTime = null;
        return null;
      }

      debugPrint('🔍 Found stored token: ${token.substring(0, 10)}...');

      // Get user profile from API

      final userProfile = await _getUserProfile(token);
      final role = _parseUserRole(userProfile['role']);

      final authResult = AuthResult(
        role: role,
        userData: userProfile,
        token: token,
      );
      
      // Cache the result
      _cachedUser = authResult;
      _cacheTime = DateTime.now();
      
      return authResult;
    } catch (e) {
      debugPrint('❌ Error getting current user: $e');
      // Clear cache and token
      _cachedUser = null;
      _cacheTime = null;
      await logout();
      return null;
    }
  }

  /// Logout - clear all stored authentication data
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Clear all authentication related data
      await prefs.remove('jwt_token');
      await prefs.remove('mock_user_data');
      await prefs.remove('driver_id');
      await prefs.remove('user_id');
      await prefs.remove('auth_token');
      await prefs.remove('user_name');
      await prefs.remove('user_phone');
      
      // Clear UserDataService data - these are the actual keys used
      await prefs.remove('saved_sender_data');
      await prefs.remove('saved_recipient_data');
      await prefs.remove('saved_recipient_addresses_list');
      
      // Clear any legacy keys
      await prefs.remove('sender_name');
      await prefs.remove('sender_phone');
      await prefs.remove('sender_short_address');
      await prefs.remove('sender_building_number');
      await prefs.remove('sender_unit_number');
      await prefs.remove('sender_postal_code');
      await prefs.remove('sender_address');
      await prefs.remove('sender_notes');
      
      // Clear any other potential cached data
      final allKeys = prefs.getKeys();
      for (final key in allKeys) {
        if (key.contains('user') || key.contains('sender') || key.contains('token') || 
            key.contains('auth') || key.contains('driver') || key.contains('jwt')) {
          await prefs.remove(key);
        }
      }
      
      // Clear the cache
      _cachedUser = null;
      _cacheTime = null;
      
      debugPrint('🔑 User logged out successfully - all session data cleared');
    } catch (e) {
      debugPrint('❌ Error during logout: $e');
      // Still clear cache even if prefs fail
      _cachedUser = null;
      _cacheTime = null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getStoredToken();
    if (token == null) return false;
    
    // Verify token is still valid by trying to get user profile
    try {
      await _getUserProfile(token);
      return true;
    } catch (e) {
      // Token is invalid, clear it
      await logout();
      return false;
    }
  }



  /// Update user profile
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await authenticatedRequest(
        method: 'PUT',
        endpoint: '/users/me',
        body: updateData,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Update cached user data
        if (_cachedUser != null) {
          _cachedUser = AuthResult(
            role: _cachedUser!.role,
            userData: data['data'] ?? data['user'] ?? data,
            token: _cachedUser!.token,
          );
        }
        return data['data'] ?? data['user'] ?? data;
      } else {
        throw Exception('Failed to update user profile: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }

  /// Update cached user data (for local storage fallback)
  void updateCachedUserData(Map<String, dynamic> updateData) {
    if (_cachedUser != null) {
      final updatedUserData = Map<String, dynamic>.from(_cachedUser!.userData);
      updatedUserData.addAll(updateData);
      
      _cachedUser = AuthResult(
        role: _cachedUser!.role,
        userData: updatedUserData,
        token: _cachedUser!.token,
      );
      
      debugPrint('✅ Cached user data updated locally: $updateData');
    }
  }

  /// Make authenticated API calls
  Future<http.Response> authenticatedRequest({
    required String method,
    required String endpoint,
    Map<String, String>? additionalHeaders,
    Map<String, dynamic>? body,
  }) async {
    final token = await getStoredToken();
    debugPrint('🔍 Making authenticated request to: $endpoint');
    debugPrint('🔍 Token available: ${token != null}');
    
    if (token == null) {
      debugPrint('❌ No token found for authenticated request');
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    // Note: Mock token logic removed - using real API endpoints

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      ...?additionalHeaders,
    };

    final uri = Uri.parse('${ApiConfig.fullBaseUrl}$endpoint');

    switch (method.toUpperCase()) {
      case 'GET':
        return await _httpClient.get(uri, headers: headers);
      case 'POST':
        return await _httpClient.post(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'PUT':
        return await _httpClient.put(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'PATCH':
        return await _httpClient.patch(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'DELETE':
        return await _httpClient.delete(uri, headers: headers);
      default:
        throw Exception('HTTP method not supported: $method');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}