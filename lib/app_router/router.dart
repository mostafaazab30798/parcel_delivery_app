import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';

import '../components/driver_shell.dart';
import '../pages/driver/earnings.dart';
import '../pages/driver/home.dart';
import '../pages/driver/settings.dart';
import '../pages/driver/shipments.dart';
import '../pages/switch_screen.dart';
import '../pages/user/home_screen.dart';
import '../pages/user/profile_screen.dart';
import '../pages/user/tracking_screen.dart';
import '../components/user/user_shell.dart';

enum AppRoute {
  //splash('/splash'),
  // login('/login'),
  switchScreen('/switchScreen'),
  userHome('/user-home'),
  userShipment('/user-shipment'),
  userProfile('/user-profile'),
  driverHome('/driver-home'),
  driverShipments('/driver-shipments'),
  driverEarnings('/driver-earnings'),
  driverSettings('/driver-settings');

  final String path;
  const AppRoute(this.path);
}

final GoRouter router = GoRouter(
  initialLocation: AppRoute.switchScreen.path,
  routes: [
    // GoRoute(
    //   path: AppRoute.splash.path,
    //   builder: (context, state) => const SplashScreen(),
    // ),
    GoRoute(
      path: AppRoute.switchScreen.path,
      pageBuilder: GoTransitions.fade,
      builder: (context, state) => const SwitchScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        // Determine current index based on location
        final location = state.uri.toString();
        int currentIndex = 0;
        if (location.contains('/user-home'))
          currentIndex = 0;
        else if (location.contains('/user-shipment'))
          currentIndex = 1;
        else if (location.contains('/user-profile')) currentIndex = 2;

        return UserShell(
          child: child,
          currentIndex: currentIndex,
          onTap: (index) {
            final paths = [
              '/user-home',
              '/user-shipment',
              '/user-profile',
            ];
            context.go(paths[index]);
          },
        );
      },
      routes: [
        GoRoute(
          pageBuilder: GoTransitions.slide,
          path: AppRoute.userHome.path,
          builder: (context, state) => const UserHomeScreen(),
        ),
        GoRoute(
          pageBuilder: GoTransitions.slide,
          path: AppRoute.userShipment.path,
          builder: (context, state) => const UserShipmentScreen(),
        ),
        GoRoute(
          pageBuilder: GoTransitions.slide,
          path: AppRoute.userProfile.path,
          builder: (context, state) => const UserProfileScreen(),
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) => DriverShell(child: child),
      routes: [
        GoRoute(
          path: AppRoute.driverHome.path,
          pageBuilder: GoTransitions.slide,
          builder: (context, state) => const DriverHomeScreen(),
        ),
        GoRoute(
          path: AppRoute.driverShipments.path,
          pageBuilder: GoTransitions.slide,
          builder: (context, state) => DriverShipmentsScreen(),
        ),
        GoRoute(
          path: AppRoute.driverEarnings.path,
          pageBuilder: GoTransitions.slide,
          builder: (context, state) => DriverEarningsScreen(),
        ),
        GoRoute(
          path: AppRoute.driverSettings.path,
          pageBuilder: GoTransitions.slide,
          builder: (context, state) => const DriverSettingsScreen(),
        ),
      ],
    ),
  ],
);
final navigatorKey = GlobalKey<NavigatorState>();
