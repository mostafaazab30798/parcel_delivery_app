import 'package:flutter/material.dart';
import '../../components/nav_bar.dart';
import '../services/theme.dart';

class DriverShell extends StatelessWidget {
  final Widget child;
  const DriverShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) => Theme(
        data: driverTheme(),
        child: Scaffold(
          body: child,
          bottomNavigationBar: const DriverBottomNavBar(),
        ),
      );
}
