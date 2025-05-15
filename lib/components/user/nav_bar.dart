import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const CustomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

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
            selectedIcon: Image.asset('assets/images/home-nav.png',
                color: Theme.of(context).primaryColor, height: iconSize * 1.5),
            icon: Image.asset(
              'assets/images/home-nav.png',
              height: iconSize * 1.5,
              color: Theme.of(context).primaryColor.withOpacity(0.7),
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
            icon: Image.asset('assets/images/box (2).png',
                color: Theme.of(context).primaryColor.withOpacity(0.7),
                height: iconSize * 1.5),
            selectedIcon: Image.asset('assets/images/box (2).png',
                color: Theme.of(context).primaryColor, height: iconSize * 1.5),
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
            icon: Image.asset('assets/images/avatar.png',
                color: Theme.of(context).primaryColor.withOpacity(0.7),
                height: iconSize * 1.5),
            selectedIcon: Image.asset('assets/images/avatar.png',
                color: Theme.of(context).primaryColor, height: iconSize * 1.5),
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
  }
}
