import 'package:flutter/material.dart';
import 'package:provider_test/components/shipments_card.dart';
import 'package:provider_test/models/shipment.dart';

class DriverShipmentsScreen extends StatelessWidget {
  const DriverShipmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
            final fontSize = screenSize.width * (isSmallScreen ? 0.03 : 0.045);
            final titleFontSize =
                screenSize.width * (isSmallScreen ? 0.06 : 0.07);
            final iconSize = screenSize.width * (isSmallScreen ? 0.045 : 0.05);
            final spacing = screenSize.width * (isSmallScreen ? 0.01 : 0.015);
            final cardMinHeight =
                screenSize.height * (isSmallScreen ? 0.12 : 0.15);
            final borderRadius =
                screenSize.width * (isSmallScreen ? 0.03 : 0.04);

            return Column(
              children: [
                _buildHeader(context, isSmallScreen, padding, titleFontSize),
                _buildShipmentStats(
                  context,
                  isSmallScreen,
                  padding,
                  fontSize,
                  iconSize,
                  spacing,
                  cardMinHeight,
                  borderRadius,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius * 2),
                        topRight: Radius.circular(borderRadius * 2),
                      ),
                    ),
                    child: _ShipmentsList(
                      padding: padding,
                      spacing: spacing,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isSmallScreen,
    double padding,
    double titleFontSize,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        top: padding * 1.2,
        right: padding * 1.5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'الشحنات المُوكَّلة',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: titleFontSize * 1.4, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentStats(
    BuildContext context,
    bool isSmallScreen,
    double padding,
    double fontSize,
    double iconSize,
    double spacing,
    double cardMinHeight,
    double borderRadius,
  ) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'الشحنات النشطة',
              '12',
              Colors.blue,
              Icons.local_shipping,
              context,
              isSmallScreen,
              padding,
              fontSize,
              iconSize,
              spacing,
              cardMinHeight,
              borderRadius,
            ),
          ),
          SizedBox(width: spacing * 2),
          Expanded(
            child: _buildStatCard(
              'المكتملة',
              '28',
              Colors.green,
              Icons.check_circle,
              context,
              isSmallScreen,
              padding,
              fontSize,
              iconSize,
              spacing,
              cardMinHeight,
              borderRadius,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String amount,
    Color color,
    IconData icon,
    BuildContext context,
    bool isSmallScreen,
    double padding,
    double fontSize,
    double iconSize,
    double spacing,
    double cardMinHeight,
    double borderRadius,
  ) {
    return Container(
      padding: EdgeInsets.all(padding),
      constraints: BoxConstraints(
        minHeight: cardMinHeight * 0.8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: fontSize * 1.4,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              SizedBox(width: spacing),
              Icon(icon, color: color, size: iconSize),
            ],
          ),
          SizedBox(height: spacing * 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ' $amount شحنة',
                textDirection: TextDirection.rtl,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: fontSize * 1.2,
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

  Widget _buildShipmentDetail(
      IconData icon, String text, Color color, double iconSize) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          icon,
          color: color,
          size: iconSize,
        ),
      ],
    );
  }
}

class _ShipmentsList extends StatelessWidget {
  final double padding;
  final double spacing;

  const _ShipmentsList({
    required this.padding,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final List<Shipment> shipments = [
      const Shipment(
        pickupAddress: '456 Elm Street, Springfield',
        deliveryAddress: '739 Main Street, Springfield',
        type: 'مستند',
      ),
      const Shipment(
        pickupAddress: 'شارع الملك فهد, المدينة المنورة',
        deliveryAddress: 'شارع الملك فيصل, المدينة المنورة',
        type: 'مستند',
      ),
      const Shipment(
        pickupAddress: 'حي الضباط, الملز',
        deliveryAddress: 'شارع جرير, جرير',
        type: 'طرد',
      ),
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: padding,
        horizontal: padding,
      ),
      itemCount: shipments.length,
      itemBuilder: (context, index) {
        final shipment = shipments[index];
        return ShipmentsCard(
          shipment: shipment,
        );
      },
    );
  }
}
