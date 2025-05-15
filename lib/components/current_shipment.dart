import 'package:flutter/material.dart';

class CurrentShipmentCard extends StatelessWidget {
  final String pickupLocation;
  final String deliveryLocation;
  final VoidCallback? onDetails;

  const CurrentShipmentCard({
    super.key,
    required this.pickupLocation,
    required this.deliveryLocation,
    this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final theme = Theme.of(context);

    final padding = screenSize.width * (isSmallScreen ? 0.02 : 0.03);
    final fontSize = screenSize.width * (isSmallScreen ? 0.03 : 0.045);
    final titleFontSize = screenSize.width * (isSmallScreen ? 0.04 : 0.06);
    final iconSize = screenSize.width * (isSmallScreen ? 0.06 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.01 : 0.015);
    final borderRadius = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    final buttonPadding = screenSize.width * (isSmallScreen ? 0.02 : 0.025);

    return Container(
      margin: EdgeInsets.only(
        top: spacing,
        right: padding * 1.5,
        left: padding * 1.5,
        bottom: spacing,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: padding * 1.5,
        vertical: padding * 1.5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius * 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: spacing * 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icons and line
              Column(
                children: [
                  _LocationIcon(
                    color: const Color(0xFF3EC1B6),
                    size: iconSize * 0.8,
                  ),
                  _DashedLine(
                    height: spacing * 8,
                    spacing: spacing * 0.2,
                  ),
                  _LocationIcon(
                    color: const Color(0xFFFFA726),
                    size: iconSize * 0.8,
                  ),
                ],
              ),
              SizedBox(width: spacing),
              // Pickup & Delivery info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'موقع الاستلام',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF18314F),
                        fontSize: titleFontSize * 0.9,
                      ),
                    ),
                    SizedBox(height: spacing),
                    Text(
                      pickupLocation,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: const Color(0xFF4B6478),
                        fontSize: fontSize,
                      ),
                    ),
                    SizedBox(height: spacing * 3),
                    Text(
                      'موقع التوصيل',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF18314F),
                        fontSize: titleFontSize * 0.9,
                      ),
                    ),
                    SizedBox(height: spacing),
                    Text(
                      deliveryLocation,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: const Color(0xFF4B6478),
                        fontSize: fontSize,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing * 2),
              // Details button
              Column(
                children: [
                  ElevatedButton(
                    onPressed: onDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE3ECF5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius * 0.5),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonPadding,
                        vertical: buttonPadding * 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: iconSize * 0.6,
                        ),
                        SizedBox(width: spacing),
                        Text(
                          'تشغيل الخريطة',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: const Color(0xFF18314F),
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize * 0.9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing),
                  ElevatedButton(
                    onPressed: onDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE3ECF5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius * 0.5),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonPadding,
                        vertical: buttonPadding * 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone_rounded,
                          size: iconSize * 0.6,
                        ),
                        SizedBox(width: spacing),
                        Text(
                          'الإتصال بالعميل',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: const Color(0xFF18314F),
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize * 0.9,
                          ),
                        ),
                      ],
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

class _LocationIcon extends StatelessWidget {
  final Color color;
  final double size;
  const _LocationIcon({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.place_rounded,
      color: color,
      size: size,
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
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          (height / (spacing * 2)).floor(),
          (index) => Container(
            width: 2,
            height: spacing,
            margin: EdgeInsets.symmetric(vertical: spacing * 0.2),
            color: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
