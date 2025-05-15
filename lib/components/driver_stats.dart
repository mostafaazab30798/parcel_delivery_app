import 'package:flutter/material.dart';
import 'package:provider_test/data/driver_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider_test/blocs/auth/bloc.dart';
import 'package:provider_test/blocs/auth/state.dart';
import 'dart:io';

class DriverStates extends StatelessWidget {
  const DriverStates({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final num driverRating = drivers[0].totalStars! / drivers[0].totalReviews!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userData = state is UserDataLoaded ? state.userData : null;

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
                      userData,
                      imageSize,
                      borderRadius,
                    ),
                    _buildDriverInfo(
                      context,
                      driverRating,
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
      },
    );
  }

  Widget _buildDriverImage(
    BuildContext context,
    Map<String, dynamic>? userData,
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
            image: userData?['profilePicture'] != null
                ? DecorationImage(
                    image: FileImage(File(userData!['profilePicture'])),
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
    num driverRating,
    double padding,
    double fontSize,
    double titleFontSize,
    double iconSize,
    double spacing,
    double borderRadius,
  ) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'مرحبًا , ${drivers[0].name}',
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
                'الرقم التعريفي ${drivers[0].id}',
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
                  '(${drivers[0].totalReviews} مراجعات)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: fontSize * 0.8,
                  ),
                ),
                SizedBox(width: spacing),
                Text(
                  driverRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: spacing),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < driverRating.round()
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
