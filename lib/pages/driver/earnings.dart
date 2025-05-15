import 'package:flutter/material.dart';
import 'package:provider_test/components/riyal.dart';
import 'package:provider_test/components/shipping_card.dart';
import 'package:provider_test/models/shipment.dart';

class DriverEarningsScreen extends StatelessWidget {
  DriverEarningsScreen({super.key});
  final List<Shipment> shipments = [
    const Shipment(
      pickupAddress: '456 Elm Street, Springfield',
      deliveryAddress: '739 Main Street, Springfield',
      type: 'مستند',
      status: 'مكتمل',
    ),
    const Shipment(
      pickupAddress: 'شارع الملك فهد, المدينة المنورة',
      deliveryAddress: 'شارع الملك فيصل, المدينة المنورة',
      type: 'مستند',
      status: 'مكتمل',
    ),
    const Shipment(
      pickupAddress: 'حي الضباط, الملز',
      deliveryAddress: 'شارع جرير, جرير',
      type: 'طرد',
      status: 'مكتمل',
    ),
    const Shipment(
      pickupAddress: 'حي العليا, الرياض',
      deliveryAddress: 'شارع الملك عبد العزيز, الرياض',
      type: 'طرد',
      status: 'مكتمل',
    ),
  ];
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

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: padding * 1.2,
                    right: padding * 1.5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'الشحنات المكتملة',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: titleFontSize * 1.4,
                                ),
                      ),
                    ],
                  ),
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
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(padding),
                                      constraints: BoxConstraints(
                                        minHeight: cardMinHeight * 0.8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(borderRadius),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'الأجر المحقق لهذا الشهر',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium
                                                    ?.copyWith(
                                                      fontSize: fontSize * 0.9,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                              ),
                                              SizedBox(width: spacing),
                                              Icon(
                                                Icons.account_balance_wallet,
                                                color: Colors.green,
                                                size: iconSize,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: spacing * 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Riyal(
                                                    color: Colors.green,
                                                    size: iconSize,
                                                  ),
                                                  SizedBox(width: spacing),
                                                  Text(
                                                    '1,250',
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium
                                                        ?.copyWith(
                                                          fontSize:
                                                              fontSize * 0.9,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.green,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: spacing * 2),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(padding),
                                      constraints: BoxConstraints(
                                        minHeight: cardMinHeight * 0.8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(borderRadius),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'الأجر المحقق لهذا اليوم',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium
                                                    ?.copyWith(
                                                      fontSize: fontSize * 0.9,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                              ),
                                              SizedBox(width: spacing),
                                              Icon(
                                                Icons.monetization_on,
                                                color: Colors.blue,
                                                size: iconSize,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: spacing * 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Riyal(
                                                    color: Colors.blue,
                                                    size: iconSize,
                                                  ),
                                                  SizedBox(width: spacing),
                                                  Text(
                                                    '85',
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium
                                                        ?.copyWith(
                                                          fontSize:
                                                              fontSize * 0.9,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: padding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: spacing * 2),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: shipments.length,
                                    itemBuilder: (context, index) {
                                      return CompletedShipmentCard(
                                        shipment: shipments[index],
                                      );
                                    },
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
          },
        ),
      ),
    );
  }
}
