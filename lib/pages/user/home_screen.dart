import 'package:flutter/material.dart';

import '../../components/user/status_card.dart';
import '../../components/user/tracking_bar.dart';
import 'calculate_price.dart';
import 'new_delivery_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.04 : 0.03);
    final iconSize = screenSize.width * (isSmallScreen ? 0.15 : 0.19);
    final spacing = screenSize.width * (isSmallScreen ? 0.02 : 0.015);
    final fontSize = screenSize.width * (isSmallScreen ? 0.07 : 0.045);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: iconSize * 0.8,
              width: iconSize * 1.2,
              padding: EdgeInsets.all(spacing * 0.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Text('مرحبًا بك',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Theme.of(context).cardColor, fontSize: fontSize)),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: padding, vertical: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Top Section
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/shipments.jpg',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black.withOpacity(0.18),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: padding, vertical: padding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(height: spacing),
                                const TrackingBar(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Top Section

                    SizedBox(height: spacing * 1.5),
                    // Bottom White Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'خدماتنا',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        SizedBox(height: spacing),
                        Column(
                          children: [
                            buildStatCard(
                              'إنشاء شحنة',
                              'assets/images/add-package.png',
                              Theme.of(context).cardColor,
                              context,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NewDeliveryScreen()),
                                );
                              },
                            ),
                            SizedBox(height: spacing),
                            buildStatCard(
                              'حساب التكلفة',
                              'assets/images/calculator.png',
                              Theme.of(context).cardColor,
                              context,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CalculatePrice()),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
