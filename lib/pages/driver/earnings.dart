import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider_test/blocs/driver/bloc/driver_bloc.dart';
import 'package:provider_test/components/riyal.dart';
import 'package:provider_test/components/shipping_card.dart';
import 'package:provider_test/models/shipment.dart';

class DriverEarningsScreen extends StatelessWidget {
  const DriverEarningsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
            final fontSize = screenSize.width * (isSmallScreen ? 0.04 : 0.045);
            final titleFontSize =
                screenSize.width * (isSmallScreen ? 0.06 : 0.07);
            final iconSize = screenSize.width * (isSmallScreen ? 0.04 : 0.045);
            final spacing = screenSize.width * (isSmallScreen ? 0.01 : 0.015);
            final cardMinHeight =
                screenSize.height * (isSmallScreen ? 0.12 : 0.15);
            final borderRadius =
                screenSize.width * (isSmallScreen ? 0.03 : 0.04);

            return BlocBuilder<DriverBloc, DriverState>(
              builder: (context, state) {
                if (state is DriverInitial) {
                  context.read<DriverBloc>().add(const DriverCompletedShipmentsLoaded());
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
                      _buildHeader(context, isSmallScreen, padding, titleFontSize),
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(borderRadius * 2),
                              topRight: Radius.circular(borderRadius * 2),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildEarningsStats(
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
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: padding),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(height: spacing * 2),
                                      Expanded(
                                        child: _CompletedShipmentsList(
                                          padding: padding,
                                          spacing: spacing,
                                          shipments: state.completedShipments,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
            'الشحنات المكتملة',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: titleFontSize * 1.4,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsStats(
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
    final monthlyEarnings = earnings['monthlyEarnings'] ?? 0.0;
    final dailyEarnings = earnings['dailyEarnings'] ?? 0.0;
    
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildEarningsCard(
                  'الأجر المحقق لهذا الشهر',
                  monthlyEarnings.toStringAsFixed(0),
                  Colors.green,
                  Icons.account_balance_wallet,
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
                child: _buildEarningsCard(
                  'الأجر المحقق لهذا اليوم',
                  dailyEarnings.toStringAsFixed(0),
                  Colors.blue,
                  Icons.monetization_on,
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
        ],
      ),
    );
  }

  Widget _buildEarningsCard(
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
                      fontSize: fontSize * 0.9,
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
              Row(
                children: [
                  Riyal(
                    color: color,
                    size: iconSize,
                  ),
                  SizedBox(width: spacing),
                  Text(
                    amount,
                    textDirection: TextDirection.rtl,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: fontSize * 0.9,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompletedShipmentsList extends StatelessWidget {
  final double padding;
  final double spacing;
  final List<Map<String, dynamic>> shipments;

  const _CompletedShipmentsList({
    required this.padding,
    required this.spacing,
    required this.shipments,
  });

  @override
  Widget build(BuildContext context) {
    if (shipments.isEmpty) {
      return Center(
        child: Text(
          'لا توجد شحنات مكتملة',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: shipments.length,
      itemBuilder: (context, index) {
        final shipmentData = shipments[index];
        
        // Extract address from API format
        final senderCity = shipmentData['sender']?['address']?['national']?['city'] ?? 'غير محدد';
        final recipientCity = shipmentData['recipient']?['address']?['national']?['city'] ?? 'غير محدد';
        
        final shipment = Shipment(
          id: shipmentData['_id'] != null ? shipmentData['_id'].hashCode : null,
          trackingNumber: shipmentData['trackingNumber'],
          status: 'مكتمل', // Always completed for this screen
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
        
        return CompletedShipmentCard(
          shipment: shipment,
        );
      },
    );
  }
}
