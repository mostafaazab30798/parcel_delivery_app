

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class DriverBottomNavBar extends StatelessWidget {
  const DriverBottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 225, 230, 235),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: GNav(
        backgroundColor: Colors.transparent,
        gap: 8,
        activeColor: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).textTheme.displaySmall?.color,
        iconSize: 24,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: const Duration(milliseconds: 200), // Reduced duration for faster response
        tabBackgroundColor: Theme.of(context).canvasColor,
        selectedIndex: currentIndex,
        onTabChange: (index) {
          final currentLocation = GoRouterState.of(context).uri.toString();
          final paths = [
            '/driver-home',
            '/driver-shipments',
            '/driver-earnings',
            '/driver-settings',
          ];
          
          final targetPath = paths[index];
          
          // Only navigate if not already on the target page to prevent duplicate navigation
          if (!currentLocation.contains(targetPath)) {
            // Direct navigation without delay for instant response
            if (context.mounted) {
              try {
                context.go(targetPath);
              } catch (e) {
                print('Navigation error: $e');
              }
            }
          }
        },
        tabs: const [
          GButton(
            icon: LucideIcons.house500,
            text: 'الرئيسية',
          ),
          GButton(
            icon: LucideIcons.store500,
            text: 'مركز الشحنات',
          ),
          GButton(
            icon: LucideIcons.dollarSign500,
            text: 'الدخل',
          ),
          GButton(
            icon: LucideIcons.user500,
            text: 'الحساب',
          )
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.contains('/driver-home')) return 0;
    if (location.contains('/driver-shipments')) return 1;
    if (location.contains('/driver-earnings')) return 2;
    if (location.contains('/driver-settings')) return 3;
    return 0;
  }
}
