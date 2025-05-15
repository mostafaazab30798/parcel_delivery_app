import 'package:flutter/material.dart';
import '../../pages/user/shipment_details.dart';

Widget buildShippingItem(
    BuildContext context, String image, String status, String type,
    {BorderRadius? borderRadius}) {
  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.width < 600;
  final padding = screenSize.width * (isSmallScreen ? 0.02 : 0.03);
  final iconSize = screenSize.width * (isSmallScreen ? 0.045 : 0.05);
  final fontSize = screenSize.width * (isSmallScreen ? 0.04 : 0.045);
  final spacing = screenSize.width * (isSmallScreen ? 0.01 : 0.015);
  final cardRadius = screenSize.width * (isSmallScreen ? 0.06 : 0.07);
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShipmentDetailsScreen(
            shipmentId: '#5R9G87R',
            status: status,
            type: type,
          ),
        ),
      );
    },
    child: LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFAF3),
            borderRadius: borderRadius ?? BorderRadius.circular(cardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Box image
              Container(
                width: iconSize * 2,
                height: iconSize * 2,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: padding),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '#5R9G87R',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF222831),
                                  fontSize: fontSize),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                    SizedBox(height: spacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'شارع الملك فهد, المدينة المنورة',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Color(0xFF222831),
                                    fontWeight: FontWeight.w500,
                                  ),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(width: spacing),
                        Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFFF9B233),
                          size: iconSize,
                        ),
                      ],
                    ),
                    SizedBox(height: spacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: padding * 0.8,
                              vertical: padding * 0.3),
                          decoration: BoxDecoration(
                            color: Color(0xFFB65D09).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            type,
                            style: TextStyle(
                              fontFamily: 'Dubai-Regular',
                              color: Color(0xffFDDDAA),
                              fontWeight: FontWeight.w600,
                              fontSize: fontSize * 0.8,
                            ),
                          ),
                        ),
                        SizedBox(width: spacing),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: padding * 0.8,
                              vertical: padding * 0.3),
                          decoration: BoxDecoration(
                            color: Color(0xFF2D7C38).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontFamily: 'Dubai-Regular',
                              color: Color(0xFFCDE7CD),
                              fontWeight: FontWeight.w600,
                              fontSize: fontSize * 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
