import 'package:flutter/material.dart';
import 'package:provider_test/components/riyal.dart';

Widget buildStatCard(
  String title,
  String amount,
  Color color,
  IconData icon,
  BuildContext context,
) {
  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.width < 600;

  final padding = screenSize.width * (isSmallScreen ? 0.02 : 0.025);
  final fontSize = screenSize.width * (isSmallScreen ? 0.04 : 0.045);
  final titleFontSize = screenSize.width * (isSmallScreen ? 0.035 : 0.04);
  final iconSize = screenSize.width * (isSmallScreen ? 0.045 : 0.05);
  final spacing = screenSize.width * (isSmallScreen ? 0.01 : 0.015);
  final borderRadius = screenSize.width * (isSmallScreen ? 0.02 : 0.025);

  return Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            Icon(icon, color: color, size: iconSize * 0.8),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Riyal(color: color, size: iconSize * 0.6),
                SizedBox(height: spacing * 0.2),
              ],
            ),
            SizedBox(width: spacing * 0.5),
            Text(
              amount,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ],
    ),
  );
}
