import 'package:flutter/material.dart';
import 'dart:io';

class DriverStates extends StatelessWidget {
  final Map<String, dynamic> driverData;
  final Map<String, dynamic> earnings;
  
  const DriverStates({
    super.key,
    required this.driverData,
    required this.earnings,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    // Use real data from earnings for rating
    final double averageRating = (earnings['averageRating'] as num?)?.toDouble() ?? 0.0;
    final int totalReviews = earnings['completedShipments'] as int? ?? 0;

    final padding = screenSize.width * (isSmallScreen ? 0.02 : 0.03);
    final fontSize = screenSize.width * (isSmallScreen ? 0.03 : 0.045);
    final titleFontSize = screenSize.width * (isSmallScreen ? 0.04 : 0.06);
    final iconSize = screenSize.width * (isSmallScreen ? 0.04 : 0.045);
    final spacing = screenSize.width * (isSmallScreen ? 0.01 : 0.015);
    final borderRadius = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    final imageSize = screenSize.width * (isSmallScreen ? 0.2 : 0.25);

    return Padding(
      padding: EdgeInsets.only(
        top: padding * 1.5,
        right: padding * 1.5,
        left: padding * 1.5,
        bottom: padding * 0.5,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: padding * 1.5,
          vertical: padding * 1.5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius * 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        width: screenSize.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDriverImage(
                  context,
                  driverData,
                  imageSize,
                  borderRadius,
                ),
                _buildDriverInfo(
                  context,
                  averageRating,
                  totalReviews,
                  padding,
                  fontSize,
                  titleFontSize,
                  iconSize,
                  spacing,
                  borderRadius,
                ),
              ],
            ),
            // const SizedBox(height: 20),
            // _buildDeliveryStats(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverImage(
    BuildContext context,
    Map<String, dynamic> driverData,
    double imageSize,
    double borderRadius,
  ) {
    return Column(
      children: [
        Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue.withOpacity(0.2),
              width: 2,
            ),
            image: driverData['profilePicture'] != null
                ? DecorationImage(
                    image: FileImage(File(driverData['profilePicture'])),
                    fit: BoxFit.cover,
                  )
                : const DecorationImage(
                    image: AssetImage('assets/images/courier.png'),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfo(
    BuildContext context,
    double averageRating,
    int totalReviews,
    double padding,
    double fontSize,
    double titleFontSize,
    double iconSize,
    double spacing,
    double borderRadius,
  ) {
    final driverName = driverData['name'] ?? 'Driver';
    final driverId = driverData['id'] ?? driverData['_id'] ?? 'N/A';
    
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'مرحبًا , $driverName',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: spacing),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: padding * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Text(
                'الرقم التعريفي ${driverId.toString().substring(0, 8)}...',
                style: TextStyle(
                  color: Colors.deepPurple[700],
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize * 0.9,
                ),
              ),
            ),
            SizedBox(height: spacing * 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '($totalReviews شحنات مكتملة)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: fontSize * 0.8,
                  ),
                ),
                SizedBox(width: spacing),
                Text(
                  averageRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: spacing),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < averageRating.round()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: iconSize,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
