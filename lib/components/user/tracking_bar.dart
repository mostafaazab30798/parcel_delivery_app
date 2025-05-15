import 'package:flutter/material.dart';

class TrackingBar extends StatelessWidget {
  const TrackingBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final fontSize = screenSize.width * (isSmallScreen ? 0.04 : 0.045);

    final iconSize = screenSize.width * (isSmallScreen ? 0.045 : 0.05);
    final spacing = screenSize.width * (isSmallScreen ? 0.01 : 0.015);
    final borderRadius = screenSize.width * (isSmallScreen ? 0.02 : 0.025);
    return Container(
      height: screenSize.width * (isSmallScreen ? 0.13 : 0.15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadius * 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: spacing * 4),
          Icon(Icons.arrow_back_ios_new,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color!
                  .withOpacity(0.7),
              size: iconSize),
          SizedBox(width: spacing * 4),
          Container(
            width: 1,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .color!
                  .withOpacity(0.5),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: TextField(
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: fontSize),
              decoration: InputDecoration(
                hintText: 'أدخل رمز التتبع الخاص بك لتتبع الشحنة',
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: fontSize * 0.8,
                    ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SizedBox(width: spacing),
          Image.asset('assets/images/track.png', height: iconSize * 1.5),
          SizedBox(width: spacing * 2),
        ],
      ),
    );
  }
}
