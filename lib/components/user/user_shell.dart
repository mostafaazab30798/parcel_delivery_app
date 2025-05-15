import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) => Theme(
        data: userTheme(context),
        child: Scaffold(
          body: child,
          bottomNavigationBar: CustomNavBar(
            currentIndex: currentIndex,
            onTap: onTap,
          ),
        ),
      );
}
