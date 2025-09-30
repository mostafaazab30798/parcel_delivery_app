import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class UserService {
  final AuthService _authService;
  
  UserService({AuthService? authService}) 
      : _authService = authService ?? AuthService();

  /// Login user using the real AuthService
  Future<Map<String, dynamic>> loginUser(String phoneNumber, String password) async {
    final authResult = await _authService.login(phoneNumber, password);
    return authResult.userData;
  }

  /// Get current user from AuthService
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final authResult = await _authService.getCurrentUser();
    return authResult?.userData;
  }

  /// Logout user using AuthService
  Future<void> logoutUser() async {
    await _authService.logout();
  }

  /// Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    return await _authService.isLoggedIn();
  }

  void dispose() {
    _authService.dispose();
  }
}