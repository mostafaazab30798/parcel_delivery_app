import 'package:flutter/material.dart';
import '../../components/nav_bar.dart';
import '../services/theme.dart';

class DriverShell extends StatelessWidget {
  final Widget child;
  const DriverShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    try {
      return Theme(
        data: driverTheme(),
        child: Scaffold(
          body: child,
          bottomNavigationBar: const DriverBottomNavBar(),
        ),
      );
    } catch (e) {
      print('Error in DriverShell: $e');
      // Return a basic scaffold if there's an error
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Something went wrong in the driver interface.'),
        ),
      );
    }
  }
}
