import 'package:flutter/material.dart';
import '../../pages/user/shipment_details.dart';
import '../../models/api_shipment.dart';
import '../../models/address.dart';
import '../../utils/shipment_translations.dart';

Widget buildShippingItem(
    BuildContext context, 
    ApiShipment shipment,
    {BorderRadius? borderRadius}) {
  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.width < 600;
  final padding = screenSize.width * (isSmallScreen ? 0.02 : 0.03);
  final iconSize = screenSize.width * (isSmallScreen ? 0.045 : 0.05);
  final fontSize = screenSize.width * (isSmallScreen ? 0.04 : 0.045);
  final spacing = screenSize.width * (isSmallScreen ? 0.01 : 0.015);
  final cardRadius = screenSize.width * (isSmallScreen ? 0.06 : 0.07);
  
  // Extract data from shipment
  final trackingNumber = shipment.trackingNumber ?? 'غير محدد';
  final status = _getStatusText(shipment.status ?? 'pending');
  final shipmentType = ShipmentTranslations.translateShipmentType(shipment.shipmentType);
  final weight = shipment.weight != null ? '${shipment.weight} كجم' : 'غير محدد';
  final description = shipment.description ?? 'لا يوجد وصف';
  final nature = ShipmentTranslations.translateShipmentNature(shipment.nature);
  final notes = shipment.notes ?? 'لا توجد ملاحظات';
  
  // Address information
  final senderAddress = _formatAddress(shipment.sender.address);
  final recipientAddress = _formatAddress(shipment.recipient.address);
  
  // Dates
  final createdAt = shipment.createdAt != null 
      ? _formatDate(shipment.createdAt!) 
      : 'غير محدد';
  final updatedAt = shipment.updatedAt != null 
      ? _formatDate(shipment.updatedAt!) 
      : 'غير محدد';

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShipmentDetailsScreen(
            shipment: shipment,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Header row with tracking number and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: padding * 0.8,
                        vertical: padding * 0.3),
                    decoration: BoxDecoration(
                      color: _getStatusColor(shipment.status ?? 'pending').withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontFamily: 'Dubai-Regular',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize * 0.6,
                      ),
                    ),
                  ),
                  Text(
                    '#$trackingNumber',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF222831),
                            fontSize: fontSize * 0.8),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              SizedBox(height: spacing * 1.5),
              
              // Shipment type and weight
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      shipmentType,
                      style: TextStyle(
                        fontFamily: 'Dubai-Regular',
                        color: Color(0xffFDDDAA),
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize * 0.6,
                      ),
                    ),
                  ),
                  Text(
                    'الوزن: $weight',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Color(0xFF222831),
                      fontWeight: FontWeight.w500,
                      fontSize: fontSize * 0.7,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing * 1.5),
              
              // Sender and recipient info
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'من: ${shipment.sender.name}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Color(0xFF222831),
                            fontWeight: FontWeight.w600,
                            fontSize: fontSize * 0.7,
                          ),
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: spacing * 0.5),
                        Text(
                          senderAddress,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Color(0xFF222831).withOpacity(0.7),
                            fontSize: fontSize * 0.6,
                          ),
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: spacing),
                  Icon(
                    Icons.arrow_forward,
                    color: Color(0xFFF9B233),
                    size: iconSize * 0.8,
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'إلى: ${shipment.recipient.name}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Color(0xFF222831),
                            fontWeight: FontWeight.w600,
                            fontSize: fontSize * 0.7,
                          ),
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: spacing * 0.5),
                        Text(
                          recipientAddress,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Color(0xFF222831).withOpacity(0.7),
                            fontSize: fontSize * 0.6,
                          ),
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing * 1.5),
              
              // Description and nature
              if (description.isNotEmpty && description != 'لا يوجد وصف') ...[
                Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      color: Color(0xFF6C63FF),
                      size: iconSize * 0.6,
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Color(0xFF222831).withOpacity(0.8),
                          fontSize: fontSize * 0.65,
                        ),
                        textDirection: TextDirection.rtl,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),
              ],
              
              // Nature and notes
              if (nature.isNotEmpty && nature != 'غير محدد') ...[
                Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      color: Color(0xFF2D7C38),
                      size: iconSize * 0.6,
                    ),
                    SizedBox(width: spacing),
                    Text(
                      'النوع: $nature',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Color(0xFF2D7C38),
                        fontWeight: FontWeight.w500,
                        fontSize: fontSize * 0.65,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),
              ],
              
              // Notes
              if (notes.isNotEmpty && notes != 'لا توجد ملاحظات') ...[
                Row(
                  children: [
                    Icon(
                      Icons.note_outlined,
                      color: Color(0xFFF9B233),
                      size: iconSize * 0.6,
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: Text(
                        notes,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Color(0xFFF9B233),
                          fontSize: fontSize * 0.65,
                        ),
                        textDirection: TextDirection.rtl,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),
              ],
              
              // Dates
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تم الإنشاء: $createdAt',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Color(0xFF222831).withOpacity(0.6),
                      fontSize: fontSize * 0.55,
                    ),
                  ),
                  if (updatedAt != createdAt)
                    Text(
                      'آخر تحديث: $updatedAt',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Color(0xFF222831).withOpacity(0.6),
                        fontSize: fontSize * 0.55,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}

String _getStatusText(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return 'في الانتظار';
    case 'in_transit':
      return 'جاري الشحن';
    case 'delivered':
      return 'تم التوصيل';
    case 'cancelled':
      return 'ملغي';
    case 'returned':
      return 'مرتجع';
    case 'assigned':
      return 'تم التعيين';
    case 'picked_up':
      return 'تم الاستلام';
    case 'out_for_delivery':
      return 'خرج للتسليم';
    default:
      return 'غير محدد';
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'in_transit':
      return Colors.blue;
    case 'delivered':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    case 'returned':
      return Colors.purple;
    case 'assigned':
      return Colors.indigo;
    case 'picked_up':
      return Colors.teal;
    case 'out_for_delivery':
      return Colors.amber;
    default:
      return Colors.grey;
  }
}

String _formatAddress(Address address) {
  if (address.national != null) {
    final national = address.national!;
    final city = national.city;
    final street = national.street;
    final district = national.district;
    
    if (city.isNotEmpty && street.isNotEmpty && district.isNotEmpty) {
      return '$street, $district, $city';
    } else if (city.isNotEmpty && street.isNotEmpty) {
      return '$street, $city';
    } else if (city.isNotEmpty) {
      return city;
    } else if (street.isNotEmpty) {
      return street;
    }
  }
  return 'العنوان غير محدد';
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
