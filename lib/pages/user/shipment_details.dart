import 'package:flutter/material.dart';

class ShipmentDetailsScreen extends StatelessWidget {
  final String shipmentId;
  final String status;
  final String type;

  const ShipmentDetailsScreen({
    Key? key,
    required this.shipmentId,
    required this.status,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.04 : 0.03);
    final iconSize = screenSize.width * (isSmallScreen ? 0.15 : 0.19);
    final spacing = screenSize.width * (isSmallScreen ? 0.02 : 0.015);
    final fontSize = screenSize.width * (isSmallScreen ? 0.1 : 0.045);
    final cardRadius = screenSize.width * (isSmallScreen ? 0.045 : 0.03);
    final dotSize = screenSize.width * (isSmallScreen ? 0.035 : 0.025);
    final lineWidth = screenSize.width * (isSmallScreen ? 0.008 : 0.006);
    final maxContentWidth = 600.0;

    final inactiveColor = theme.dividerColor;

    // Example data
    const productName = 'Macbook pro M2';
    const trackingId = 'H123135461235';
    const from = 'Mirpur 11, Dhaka';
    const to = 'Chittagong';
    const customer = 'Murad Zaman';
    const weight = '2.40 KG';
    const statusText = 'In Transit';
    final statusColor = Color(0xFF6C63FF);
    final steps = [
      {
        'title': 'Tracking Number Created',
        'subtitle': '11/5/2025',
        'active': true,
      },
      {
        'title': 'In Transit',
        'subtitle': '12/5/2025',
        'active': true,
      },
      {
        'title': 'Out for Delivery',
        'subtitle': '12/5/2025',
        'active': false,
      },
      {
        'title': 'Delivered',
        'subtitle': '12/5/2025',
        'active': false,
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تفاصيل الشحنة',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: spacing * 2.5,
                      color: Theme.of(context).cardColor,
                    ),
              ),
              Container(
                height: iconSize * 0.8,
                width: iconSize * 1.2,
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
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Single Card: all shipment data and tracking

                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cardRadius),
                  ),
                  color: theme.cardColor,
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Icon, Name, Tracking
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(spacing * 2),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.inventory_2_rounded,
                                color: theme.primaryColor,
                                size: iconSize * 0.4,
                              ),
                            ),
                            SizedBox(width: spacing * 2),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'اسم الشحنة: $productName',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSize * 0.5,
                                    ),
                                  ),
                                  SizedBox(height: spacing),
                                  Row(
                                    children: [
                                      Text(
                                        'رقم التتبع: #$trackingId',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: theme.primaryColor,
                                          fontSize: fontSize * 0.32,
                                        ),
                                      ),
                                      SizedBox(width: spacing),
                                      Icon(
                                        Icons.copy,
                                        color: theme.primaryColor,
                                        size: iconSize * 0.18,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing * 1.5),
                        Divider(height: spacing * 2),
                        // Customer & Weight
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('العميل',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color:
                                            theme.primaryColor.withOpacity(0.7),
                                        fontSize: fontSize * 0.22,
                                      )),
                                  SizedBox(height: 2),
                                  Text(customer,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize * 0.28,
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('الوزن',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color:
                                            theme.primaryColor.withOpacity(0.7),
                                        fontSize: fontSize * 0.22,
                                      )),
                                  SizedBox(height: 2),
                                  Text(weight,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize * 0.28,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing * 1.5),
                        Divider(height: spacing * 2),
                        // From & To
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('من',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color:
                                            theme.primaryColor.withOpacity(0.7),
                                        fontSize: fontSize * 0.22,
                                      )),
                                  SizedBox(height: 2),
                                  Text(from,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize * 0.28,
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('إلى',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color:
                                            theme.primaryColor.withOpacity(0.7),
                                        fontSize: fontSize * 0.22,
                                      )),
                                  SizedBox(height: 2),
                                  Text(to,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize * 0.28,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing * 1.5),
                        Divider(height: spacing * 2),
                        // Status
                        Row(
                          children: [
                            Text('الحالة:',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.primaryColor.withOpacity(0.7),
                                  fontSize: fontSize * 0.22,
                                )),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(statusText,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize * 0.22,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing * 2),
                        // Tracking Timeline
                        Text('تتبع الشحنة',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize * 0.35,
                            )),
                        SizedBox(height: spacing * 1.5),
                        Column(
                          children: List.generate(steps.length, (index) {
                            final isActive = steps[index]['active'] == true;
                            final isLast = index == steps.length - 1;
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Timeline
                                Column(
                                  children: [
                                    Container(
                                      width: dotSize,
                                      height: dotSize,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? theme.primaryColor
                                            : inactiveColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    if (!isLast)
                                      Container(
                                        width: lineWidth,
                                        height: screenSize.width * 0.09,
                                        color: inactiveColor,
                                      ),
                                  ],
                                ),
                                SizedBox(width: spacing * 1.2),
                                // Step content
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: isLast ? 0 : spacing * 1.2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _arabicStepTitle(
                                              steps[index]['title'] as String),
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontSize * 0.28,
                                            color: isActive
                                                ? theme.primaryColor
                                                : theme
                                                    .textTheme.bodyLarge?.color,
                                          ),
                                        ),
                                        if ((steps[index]['subtitle'] as String)
                                            .isNotEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: Text(
                                              steps[index]['subtitle']
                                                  as String,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.normal,
                                                fontSize: fontSize * 0.22,
                                                color: theme
                                                    .textTheme.bodySmall?.color
                                                    ?.withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _arabicStepTitle(String title) {
    switch (title) {
      case 'Tracking Number Created':
        return 'تم إنشاء رقم التتبع';
      case 'In Transit':
        return 'قيد النقل';
      case 'Out for Delivery':
        return 'خرجت للتسليم';
      case 'Delivered':
        return 'تم التسليم';
      default:
        return title;
    }
  }
}
