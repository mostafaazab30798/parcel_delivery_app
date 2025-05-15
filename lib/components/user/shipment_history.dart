import 'package:flutter/material.dart';

Widget buildShippingHistoryItem(BuildContext context, String image) {
  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.width < 600;
  return LayoutBuilder(
    builder: (context, constraints) {
      final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);

      final iconSize = screenSize.width * (isSmallScreen ? 0.045 : 0.05);
      final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);

      final borderRadius = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
      return Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '14 may 2023',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Row(
                  children: [
                    Text(
                      '#5R9G87R',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(width: spacing * 0.5),
                    Container(
                      width: iconSize * 1.3,
                      height: iconSize * 1.3,
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: spacing * 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'شارع الملك فهد, المدينة المنورة',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(width: spacing * 0.2),
                Icon(
                  Icons.location_on_outlined,
                  size: iconSize,
                  color: Theme.of(context).dividerColor,
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
