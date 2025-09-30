import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider_test/blocs/driver/bloc/driver_bloc.dart';
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
        child: Column(
          children: [
            _buildHeader(context, isSmallScreen),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final padding = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
                  final fontSize = screenSize.width * (isSmallScreen ? 0.03 : 0.045);
                  final iconSize = screenSize.width * (isSmallScreen ? 0.045 : 0.05);
                  final spacing = screenSize.width * (isSmallScreen ? 0.01 : 0.015);
                  final cardMinHeight =
                      screenSize.height * (isSmallScreen ? 0.12 : 0.15);
                  final borderRadius =
                      screenSize.width * (isSmallScreen ? 0.03 : 0.04);

                  return BlocBuilder<DriverBloc, DriverState>(
                    builder: (context, state) {
                      if (state is DriverInitial) {
                        context.read<DriverBloc>().add(const DriverShipmentsLoaded());
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (state is DriverLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (state is DriverError) {
                        return Padding(
                          padding: EdgeInsets.all(padding),
                          child: Text(
                            'خطأ: ${state.message}',
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      
                      if (state is DriverLoaded) {
                        return Column(
                          children: [
                            _buildShipmentStats(
                              context,
                              isSmallScreen,
                              padding,
                              fontSize,
                              iconSize,
                              spacing,
                              cardMinHeight,
                              borderRadius,
                              state.earnings,
                            ),
                            Flexible(
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
                                  shipments: state.shipments,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      
                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isSmallScreen,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final padding = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    final titleFontSize =
        screenSize.width * (isSmallScreen ? 0.06 : 0.07);

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
    Map<String, dynamic> earnings,
  ) {
    final activeShipments = earnings['activeShipments'] ?? 0;
    final totalShipments = earnings['totalShipments'] ?? 0;
    
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'الشحنات النشطة',
              activeShipments.toString(),
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
              totalShipments.toString(),
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


}

class _ShipmentsList extends StatelessWidget {
  final double padding;
  final double spacing;
  final List<Map<String, dynamic>> shipments;

  const _ShipmentsList({
    required this.padding,
    required this.spacing,
    required this.shipments,
  });

  @override
  Widget build(BuildContext context) {
    if (shipments.isEmpty) {
      return Center(
        child: Text(
          'لا توجد شحنات حالية',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: padding,
        horizontal: padding,
      ),
      itemCount: shipments.length,
      itemBuilder: (context, index) {
        final shipmentData = shipments[index];
        
        // Extract address from API format
        final senderCity = shipmentData['sender']?['address']?['national']?['city'] ?? 'غير محدد';
        final recipientCity = shipmentData['recipient']?['address']?['national']?['city'] ?? 'غير محدد';
        
        final shipment = Shipment(
          id: shipmentData['_id'] != null ? shipmentData['_id'].hashCode : null,
          trackingNumber: shipmentData['trackingNumber'],
          status: shipmentData['status'] ?? 'Pending',
          pickupAddress: senderCity,
          deliveryAddress: recipientCity,
          weight: (shipmentData['weight'] as num?)?.toDouble(),
          description: shipmentData['notes'],
          type: shipmentData['shipmentType'] ?? shipmentData['type'] ?? 'Normal',
          customerName: shipmentData['sender']?['name'] ?? 'غير محدد',
          customerPhone: shipmentData['sender']?['phone'],
          price: (shipmentData['cost'] as num?)?.toDouble() ?? 0.0,

          
          pickupDate: shipmentData['createdAt'] != null 
              ? DateTime.tryParse(shipmentData['createdAt']) 
              : DateTime.now(),
          paymentStatus: shipmentData['paymentStatus'] ?? 'Pending',
        );
        
        return ShipmentsCard(
          shipment: shipment,
        );
      },
    );
  }
}
