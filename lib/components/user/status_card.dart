import 'package:flutter/material.dart';

Widget buildStatCard(
  String title,
  String image,
  Color color,
  BuildContext context,
  VoidCallback onTap,
) {
  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.width < 600;

  final padding = screenSize.width * (isSmallScreen ? 0.02 : 0.025);

  final titleFontSize = screenSize.width * (isSmallScreen ? 0.035 : 0.04);
  final iconSize = screenSize.width * (isSmallScreen ? 0.045 : 0.05);

  final borderRadius = screenSize.width * (isSmallScreen ? 0.02 : 0.025);

  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: screenSize.width * (isSmallScreen ? 0.2 : 0.3),
      padding: EdgeInsets.all(padding),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(image, height: iconSize * 2),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: titleFontSize * 1.5,
                  fontWeight: FontWeight.bold,
                  //color: Color(0xFF9B652E),
                ),
          ),
        ],
      ),
    ),
  );
}
