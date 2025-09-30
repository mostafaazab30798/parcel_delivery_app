import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/driver_shell.dart';
import '../pages/driver/earnings.dart';
import '../pages/driver/home.dart';
import '../pages/login_screen.dart';
import '../pages/driver/settings.dart';
import '../pages/driver/shipments.dart';
import '../pages/switch_screen.dart';
import '../pages/signup_screen.dart';
import '../pages/otp_verification_screen.dart';
import '../pages/user/home_screen.dart';
import '../pages/user/profile_screen.dart';
import '../pages/user/tracking_screen.dart';
import '../pages/user/addresses_screen.dart';
import '../pages/user/add_address_screen.dart';
import '../pages/user/edit_address_screen.dart';
import '../pages/user/choose_address_screen.dart';
import '../components/user/user_shell.dart';
import '../blocs/signup/signup_state.dart';
import '../services/auth_service.dart';

enum AppRoute {
  //splash('/splash'),
  login('/login'),
  signup('/signup'),
  otpVerification('/otp-verification'),
  switchScreen('/switchScreen'),
  userHome('/user-home'),
  userShipment('/user-shipment'),
  userProfile('/user-profile'),
  driverHome('/driver-home'),
  driverShipments('/driver-shipments'),
  driverEarnings('/driver-earnings'),
  driverSettings('/driver-settings'),
  apiTest('/api-test'),
  testIntegration('/test-integration');

  final String path;
  const AppRoute(this.path);
}

final GoRouter router = GoRouter(
  initialLocation: AppRoute.login.path,
  redirect: (context, state) async {
    final authService = AuthService();
    
    try {
      final currentUser = await authService.getCurrentUser();
      final isLoggedIn = currentUser != null;
      final currentPath = state.matchedLocation;
      final isOnAuthPage = currentPath == AppRoute.login.path || 
                          currentPath == AppRoute.signup.path ||
                          currentPath == AppRoute.otpVerification.path;
      
      // If user is not logged in and not on auth pages, redirect to login
      if (!isLoggedIn && !isOnAuthPage) {
        return AppRoute.login.path;
      }
      
      // If user is logged in and on auth pages, redirect based on role
      if (isLoggedIn && isOnAuthPage) {
        if (currentUser.role == UserRole.driver) {
          return AppRoute.driverHome.path;
        } else {
          return AppRoute.userHome.path;
        }
      }
      
      // No redirect needed
      return null;
    } catch (e) {
      // If there's an error checking auth status, go to login
      return AppRoute.login.path;
    }
  },
  errorBuilder: (context, state) {
    return const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    );
  },
  routes: [
    GoRoute(
      path: AppRoute.login.path,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoute.signup.path,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoute.otpVerification.path,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return OTPVerificationScreen(
          phoneNumber: extra?['phoneNumber'] ?? '',
          role: extra?['role'] ?? SignUpRole.user,
          otp: extra?['otp'] ?? '',
        );
      },
    ),
    GoRoute(
      path: AppRoute.switchScreen.path,
      builder: (context, state) => const SwitchScreen(),
    ),
    // User shell route with nested routes for better performance
    ShellRoute(
      builder: (context, state, child) {
        final currentPath = state.matchedLocation;
        int currentIndex = 0;
        
        if (currentPath.contains('/user-shipment')) {
          currentIndex = 1;
        } else if (currentPath.contains('/user-profile')) {
          currentIndex = 2;
        }
        
        return UserShell(
          currentIndex: currentIndex,
          onTap: (_) {},
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: AppRoute.userHome.path,
          builder: (context, state) => const UserHomeScreen(),
        ),
        GoRoute(
          path: AppRoute.userShipment.path,
          builder: (context, state) => const UserShipmentScreen(),
        ),
        GoRoute(
          path: AppRoute.userProfile.path,
          builder: (context, state) => const UserProfileScreen(),
        ),
      ],
    ),
    // Driver shell route with nested routes for better performance
    ShellRoute(
      builder: (context, state, child) {
        return DriverShell(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoute.driverHome.path,
          builder: (context, state) => const DriverHomeScreen(),
        ),
        GoRoute(
          path: AppRoute.driverShipments.path,
          builder: (context, state) => const DriverShipmentsScreen(),
        ),
        GoRoute(
          path: AppRoute.driverEarnings.path,
          builder: (context, state) => const DriverEarningsScreen(),
        ),
        GoRoute(
          path: AppRoute.driverSettings.path,
          builder: (context, state) => const DriverSettingsScreen(),
        ),
      ],
    ),
    // Address management routes
    GoRoute(
      path: '/user-profile/addresses',
      builder: (context, state) => const AddressesScreen(),
    ),
    GoRoute(
      path: '/user-profile/addresses/add',
      builder: (context, state) => const AddAddressScreen(),
    ),
    GoRoute(
      path: '/user-profile/addresses/edit/:index',
      builder: (context, state) {
        final index = state.pathParameters['index']!;
        return EditAddressScreen(addressIndex: index);
      },
    ),
    GoRoute(
      path: '/choose-address',
      builder: (context, state) => const ChooseAddressScreen(),
    ),
  ],
);

