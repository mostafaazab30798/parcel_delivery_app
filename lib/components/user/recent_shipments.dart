import 'package:flutter/material.dart';
import 'package:provider_test/components/user/shipment.dart';

class RecentShipments extends StatelessWidget {
  const RecentShipments({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    final borderRadiusValue = screenSize.width * (isSmallScreen ? 0.02 : 0.025);
    const itemCount = 3;
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey.shade300,
          height: 1,
        );
      },
      itemBuilder: (context, index) {
        BorderRadius borderRadius = BorderRadius.zero;
        if (index == 0) {
          borderRadius = BorderRadius.only(
            topLeft: Radius.circular(borderRadiusValue * 1.5),
            topRight: Radius.circular(borderRadiusValue * 1.5),
          );
        } else if (index == itemCount - 1) {
          borderRadius = BorderRadius.only(
            bottomLeft: Radius.circular(borderRadiusValue * 1.5),
            bottomRight: Radius.circular(borderRadiusValue * 1.5),
          );
        }
        return buildShippingItem(
          context,
          'assets/images/box.png',
          'جاري الشحن',
          'واردة',
          borderRadius: borderRadius,
        );
      },
    );
  }
}
