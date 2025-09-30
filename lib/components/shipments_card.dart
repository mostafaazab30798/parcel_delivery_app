import 'package:flutter/material.dart';
import 'package:provider_test/models/shipment.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../utils/shipment_translations.dart';

class ShipmentsCard extends StatelessWidget {
  final Shipment shipment;

  const ShipmentsCard({
    super.key,
    required this.shipment,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    final padding = screenSize.width * (isSmallScreen ? 0.02 : 0.03);
    final fontSize = screenSize.width * (isSmallScreen ? 0.04 : 0.045);

    final spacing = screenSize.width * (isSmallScreen ? 0.01 : 0.015);
    final borderRadius = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    final dotSize = screenSize.width * (isSmallScreen ? 0.03 : 0.035);

    return Padding(
      padding: EdgeInsets.all(padding * 0.5),
      child: Container(
        padding: EdgeInsets.all(padding * 1.2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius * 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Pickup & Destination
                _RouteColumn(
                  fromCity: shipment.pickupAddress!,
                  toCity: shipment.deliveryAddress!,
                  fontSize: fontSize,
                  spacing: spacing,
                  dotSize: dotSize,
                ),
                SizedBox(width: spacing * 2),
                // Right: Distance & Payment
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: dotSize * 4,
                            height: dotSize * 2.5,
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.7),
                              borderRadius:
                                  BorderRadius.circular(borderRadius * 0.5),
                            ),
                            child: Center(
                              child: Text(
                                ShipmentTranslations.translateShipmentType(shipment.type),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSize * 0.8,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacing * 2),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    QuickAlert.show(
                      confirmBtnTextStyle:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontSize: fontSize,
                              ),
                      cancelBtnTextStyle:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.red.withOpacity(0.8),
                                fontSize: fontSize,
                              ),
                      context: context,
                      type: QuickAlertType.custom,
                      confirmBtnText: 'قبول',
                      cancelBtnText: 'إلغاء',
                      confirmBtnColor: Colors.green.withOpacity(0.8),
                      showCancelBtn: true,
                      barrierDismissible: true,
                      customAsset: 'assets/images/confirm.jpg',
                      widget: Center(
                        child: Text(
                          'هل أنت مستعد لبداية هذه الشحنة؟',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize * 1.1,
                              ),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.withOpacity(0.8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: padding * 1.5,
                      vertical: padding,
                    ),
                  ),
                  child: Text(
                    'إبدأ الشحنة',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontSize: fontSize,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;
  const _Dot({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: size * 0.15,
        ),
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  final double height;
  final double spacing;
  const _DashedLine({
    required this.height,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: spacing),
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            (height / (spacing * 1.5)).floor(),
            (index) => Container(
              width: spacing * 0.6,
              height: spacing * 1,
              margin: EdgeInsets.symmetric(vertical: spacing * 0.15),
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}

// Route column with icons, dashed line, and addresses
class _RouteColumn extends StatelessWidget {
  final String fromCity;
  final String toCity;
  final double fontSize;
  final double spacing;
  final double dotSize;

  const _RouteColumn({
    required this.fromCity,
    required this.toCity,
    required this.fontSize,
    required this.spacing,
    required this.dotSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Dot(color: Colors.teal, size: dotSize),
            SizedBox(width: spacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fromCity,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: fontSize * 0.9,
                      ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: spacing * 0.5),
            _DashedLine(
              height: spacing * 3,
              spacing: spacing,
            ),
          ],
        ),
        Row(
          children: [
            _Dot(color: Colors.black, size: dotSize),
            SizedBox(width: spacing * 0.5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toCity,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: fontSize * 0.9,
                      ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
