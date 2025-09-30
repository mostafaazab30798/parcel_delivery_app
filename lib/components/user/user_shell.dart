import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/user/theme.dart';
import 'nav_bar.dart';

class UserShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const UserShell({
    required this.child,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  void _handleNavigation(BuildContext context, int index) {
    final paths = [
      '/user-home',
      '/user-shipment',
      '/user-profile',
    ];
    
    final currentLocation = GoRouterState.of(context).uri.toString();
    final targetPath = paths[index];
    
    if (!currentLocation.contains(targetPath)) {
      // Direct navigation without delay for instant response
      if (context.mounted) {
        try {
          context.go(targetPath);
        } catch (e) {
          print('User navigation error: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Theme(
        data: userTheme(context),
        child: Scaffold(
          body: child,
          bottomNavigationBar: CustomNavBar(
            currentIndex: currentIndex,
            onTap: (index) => _handleNavigation(context, index),
          ),
        ),
      );
    } catch (e) {
      print('Error building UserShell: $e');
      // Return a fallback UI if there's an error
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong. Please try again.'),
        ),
      );
    }
  }
}
