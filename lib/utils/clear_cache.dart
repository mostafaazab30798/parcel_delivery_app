import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Utility to completely clear all cached data
/// Use this when you need to ensure a clean authentication state
class CacheCleanupUtility {
  static Future<void> clearAllCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get all keys before clearing
      final allKeys = prefs.getKeys();
      print('🧹 Found ${allKeys.length} keys in SharedPreferences');
      
      // Log each key being removed for debugging
      for (final key in allKeys) {
        final value = prefs.get(key);
        print('  Removing key: $key = $value');
      }
      
      // Clear everything
      await prefs.clear();
      
      // Force reload to ensure changes are persisted
      await prefs.reload();
      
      print('✅ All cached data cleared successfully');
    } catch (e) {
      print('❌ Error clearing cache: $e');
    }
  }
  
  /// Clear only authentication related data
  static Future<void> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // List of keys to remove
      final authKeys = [
        'jwt_token',
        'mock_user_data',
        'driver_id',
        'user_id',
        'auth_token',
        'user_name',
        'user_phone',
        // UserDataService keys - these are the actual keys used
        'saved_sender_data',
        'saved_recipient_data',
        'saved_recipient_addresses_list',
        // Legacy keys
        'sender_name',
        'sender_phone',
        'sender_short_address',
        'sender_building_number',
        'sender_unit_number',
        'sender_postal_code',
        'sender_address',
        'sender_notes',
      ];
      
      for (final key in authKeys) {
        if (prefs.containsKey(key)) {
          await prefs.remove(key);
          print('  Removed: $key');
        }
      }
      
      // Also remove any dynamic keys that might contain user data
      final allKeys = prefs.getKeys();
      for (final key in allKeys) {
        if (key.contains('user') || key.contains('sender') || 
            key.contains('token') || key.contains('auth') || 
            key.contains('driver') || key.contains('jwt')) {
          await prefs.remove(key);
          print('  Removed dynamic key: $key');
        }
      }
      
      print('✅ Authentication data cleared');
    } catch (e) {
      print('❌ Error clearing auth data: $e');
    }
  }
  
  /// Print all SharedPreferences data for debugging
  static Future<void> debugPrintAllPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      
      debugPrint('=== SharedPreferences Debug ===');
      debugPrint('Total keys: ${allKeys.length}');
      
      if (allKeys.isEmpty) {
        debugPrint('No data stored in SharedPreferences');
      } else {
        for (final key in allKeys) {
          final value = prefs.get(key);
          debugPrint('  $key: $value');
        }
      }
      debugPrint('=== End Debug ===');
    } catch (e) {
      debugPrint('❌ Error reading preferences: $e');
    }
  }
}