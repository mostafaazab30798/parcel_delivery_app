import 'package:flutter/material.dart';
import '../../components/user/recent_shipments.dart';

class UserShipmentScreen extends StatelessWidget {
  const UserShipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: spacing * 4,
              width: spacing * 6,
              padding: EdgeInsets.all(spacing * 0.5),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Text(
              'شحناتك',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: spacing * 2.5,
                    color: Theme.of(context).cardColor,
                  ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  vertical: padding * 0.5, horizontal: padding * 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RecentShipments(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
