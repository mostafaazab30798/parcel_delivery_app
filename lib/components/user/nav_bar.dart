import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const CustomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    try {
      final screenSize = MediaQuery.of(context).size;
      final isSmallScreen = screenSize.width < 600;

      // Cache calculated values to avoid recalculation on every build
      final padding = screenSize.width * (isSmallScreen ? 0.02 : 0.025);
      final iconSize = screenSize.width * (isSmallScreen ? 0.045 : 0.05);
      final borderRadiusValue = screenSize.width * (isSmallScreen ? 0.02 : 0.025);
      final titleFontSize = screenSize.width * (isSmallScreen ? 0.025 : 0.035);
      return Container(
        width: screenSize.width / 1.5,
        margin: EdgeInsets.only(
            bottom: padding * 3, right: padding * 12, left: padding * 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadiusValue * 2),
          // boxShadow: [
          //   BoxShadow(
          //     color: Color.fromARGB(51, 117, 117, 117),
          //     blurRadius: 8,
          //     offset: Offset(0, 2),
          //   ),
          // ],
        ),
        child: StylishBottomBar(
          elevation: 2,
          notchStyle: NotchStyle.circle,
          borderRadius: BorderRadius.circular(borderRadiusValue * 2),
          option: AnimatedBarOptions(
            barAnimation: BarAnimation.fade,
            iconStyle: IconStyle.animated,
          ),
          items: [
            BottomBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              selectedIcon: _buildNavIcon(
                'assets/images/home-nav.png',
                Icons.home,
                iconSize * 1.5,
                Theme.of(context).primaryColor,
              ),
              icon: _buildNavIcon(
                'assets/images/home-nav.png',
                Icons.home,
                iconSize * 1.5,
                Theme.of(context).primaryColor.withOpacity(0.7),
              ),
              title: Text(
                'الرئيسية',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: titleFontSize,
                    ),
              ),
            ),
            BottomBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: _buildNavIcon(
                'assets/images/box (2).png',
                Icons.inventory,
                iconSize * 1.5,
                Theme.of(context).primaryColor.withOpacity(0.7),
              ),
              selectedIcon: _buildNavIcon(
                'assets/images/box (2).png',
                Icons.inventory,
                iconSize * 1.5,
                Theme.of(context).primaryColor,
              ),
              title: Text(
                'الشحنات',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: titleFontSize,
                    ),
              ),
            ),
            BottomBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: _buildNavIcon(
                'assets/images/avatar.png',
                Icons.person,
                iconSize * 1.5,
                Theme.of(context).primaryColor.withOpacity(0.7),
              ),
              selectedIcon: _buildNavIcon(
                'assets/images/avatar.png',
                Icons.person,
                iconSize * 1.5,
                Theme.of(context).primaryColor,
              ),
              title: Text(
                'حسابي',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: titleFontSize,
                    ),
              ),
            ),
          ],
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      );
    } catch (e) {
      print('Error building CustomNavBar: $e');
      // Return a fallback UI if there's an error
      return Container(
        height: 60,
        color: Colors.grey[300],
        child: const Center(
          child: Text('Navigation Bar'),
        ),
      );
    }
  }

  // Helper method to build navigation icons with proper caching
  Widget _buildNavIcon(String assetPath, IconData fallbackIcon, double size, Color color) {
    return Image.asset(
      assetPath,
      color: color,
      height: size,
      width: size,
      cacheWidth: (size * 2).round(), // Cache at 2x resolution for crisp display
      cacheHeight: (size * 2).round(),
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          fallbackIcon,
          size: size,
          color: color,
        );
      },
    );
  }
}
