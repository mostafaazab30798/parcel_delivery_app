import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/api_shipment.dart';
import '../../models/address.dart';
import '../../utils/shipment_translations.dart';

class ShipmentDetailsScreen extends StatelessWidget {
  final ApiShipment shipment;

  const ShipmentDetailsScreen({
    Key? key,
    required this.shipment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    // Primary color from the app
    const primaryColor = Color(0xFF9B652E);
    const secondaryColor = Color(0xFFF9B233);
    const backgroundColor = Color(0xFFF5F5F5);
    const cardColor = Colors.white;
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Clean App Bar - matching create shipment screen
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: primaryColor,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: primaryColor.withOpacity(0.1),
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'تفاصيل الشحنة',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF222831),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'معلومات الشحنة الكاملة',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF8B572A),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.local_shipping_outlined,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  child: Column(
                    children: [
                      // Quick Status Card
                      _buildQuickStatusCard(context),
                      SizedBox(height: 20),
                    
                    // Main Info Cards Grid
                    _buildInfoGrid(context),
                    SizedBox(height: 20),
                    
                    // Tracking Timeline Card
                    _buildTrackingCard(context),
                    SizedBox(height: 20),
                    
                    // Contact Cards
                    _buildContactCards(context),
                    SizedBox(height: 20),
                    
                      // Additional Details
                      if (shipment.notes != null && shipment.notes!.isNotEmpty)
                        _buildNotesCard(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatusCard(BuildContext context) {
    final status = shipment.status ?? 'pending';
    final statusText = _getStatusText(status);
    final statusColor = _getStatusColor(status);
    final trackingNumber = shipment.trackingNumber ?? 'غير محدد';
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9B652E).withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge at top right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B652E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.qr_code_scanner,
                  color: const Color(0xFF9B652E),
                  size: 24,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Tracking Number Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'رقم التتبع',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFAF3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF9B652E).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '#$trackingNumber',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF222831),
                          letterSpacing: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 12),
                    InkWell(
                      onTap: () => _copyToClipboard(context, trackingNumber),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9B652E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.copy_rounded,
                          size: 18,
                          color: const Color(0xFF9B652E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    final weight = shipment.weight != null ? '${shipment.weight} كجم' : 'غير محدد';
    final type = ShipmentTranslations.translateShipmentType(shipment.shipmentType);
    final nature = ShipmentTranslations.translateShipmentNature(shipment.nature);
    final createdAt = shipment.createdAt != null 
        ? _formatDate(shipment.createdAt!) 
        : 'غير محدد';
    
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.8,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildInfoCard(
          icon: Icons.category_outlined,
          label: 'نوع الشحنة',
          value: type,
          color: const Color(0xFF9B652E),
        ),
        _buildInfoCard(
          icon: Icons.scale_outlined,
          label: 'الوزن',
          value: weight,
          color: Colors.blue,
        ),
        _buildInfoCard(
          icon: Icons.inventory_2_outlined,
          label: 'طبيعة الشحنة',
          value: nature,
          color: Colors.orange,
        ),
        _buildInfoCard(
          icon: Icons.calendar_today_outlined,
          label: 'تاريخ الإنشاء',
          value: createdAt,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF222831),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingCard(BuildContext context) {
    final steps = _getTrackingSteps(
      shipment.status ?? 'pending',
      shipment.createdAt != null ? _formatDate(shipment.createdAt!) : '',
    );
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9B652E).withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9B233).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.timeline,
                  color: const Color(0xFFF9B233),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'تتبع الشحنة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222831),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Using ListView.builder instead of List.generate for better performance
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final isActive = steps[index]['active'] == true;
              final isLast = index == steps.length - 1;
              
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline indicator column
                    SizedBox(
                      width: 40,
                      child: Column(
                        children: [
                          // Circle indicator
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF9B652E)
                                  : Colors.grey[300],
                              shape: BoxShape.circle,
                              border: isActive
                                  ? null
                                  : Border.all(
                                      color: Colors.grey[400]!,
                                      width: 1.5,
                                    ),
                            ),
                            child: Center(
                              child: isActive
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    )
                                  : Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          // Connecting line
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 40,
                              margin: EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF9B652E).withOpacity(0.3)
                                    : Colors.grey[300],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    // Step content
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              steps[index]['title'] as String,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                color: isActive
                                    ? const Color(0xFF222831)
                                    : Colors.grey[600],
                              ),
                            ),
                            if ((steps[index]['subtitle'] as String).isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Text(
                                  steps[index]['subtitle'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactCards(BuildContext context) {
    return Column(
      children: [
        _buildContactCard(
          title: 'المرسل',
          name: shipment.sender.name,
          phone: shipment.sender.phone,
          address: _formatAddress(shipment.sender.address),
          notes: shipment.sender.notes,
          icon: Icons.person_outline,
          color: Colors.blue,
        ),
        SizedBox(height: 12),
        _buildContactCard(
          title: 'المستلم',
          name: shipment.recipient.name,
          phone: shipment.recipient.phone,
          address: _formatAddress(shipment.recipient.address),
          notes: shipment.recipient.notes,
          icon: Icons.location_on_outlined,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required String title,
    required String name,
    required String phone,
    required String address,
    String? notes,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222831),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.person, size: 18, color: Colors.grey[600]),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF222831),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone, size: 18, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF9B652E),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          if (notes != null && notes.isNotEmpty) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      notes,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF9B233).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: const Color(0xFFF9B233),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'ملاحظات إضافية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222831),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            shipment.notes!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('تم نسخ رقم التتبع'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
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
      final parts = <String>[];
      
      if (national.buildingNumber.isNotEmpty) {
        parts.add('مبنى ${national.buildingNumber}');
      }
      if (national.street.isNotEmpty) {
        parts.add(national.street);
      }
      if (national.district.isNotEmpty) {
        parts.add(national.district);
      }
      if (national.city.isNotEmpty) {
        parts.add(national.city);
      }
      
      if (parts.isNotEmpty) {
        return parts.join('، ');
      }
    }
    
    if (address.shortCode != null && address.shortCode!.isNotEmpty) {
      return 'العنوان المختصر: ${address.shortCode}';
    }
    
    return 'العنوان غير محدد';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<Map<String, dynamic>> _getTrackingSteps(String status, String createdAt) {
    final baseSteps = [
      {
        'title': 'تم إنشاء الشحنة',
        'subtitle': createdAt,
        'active': true,
      },
    ];

    switch (status.toLowerCase()) {
      case 'pending':
        return baseSteps;
      case 'assigned':
        return [
          ...baseSteps,
          {
            'title': 'تم تعيين سائق',
            'subtitle': '',
            'active': true,
          },
        ];
      case 'picked_up':
        return [
          ...baseSteps,
          {
            'title': 'تم تعيين سائق',
            'subtitle': '',
            'active': true,
          },
          {
            'title': 'تم استلام الشحنة',
            'subtitle': '',
            'active': true,
          },
        ];
      case 'in_transit':
        return [
          ...baseSteps,
          {
            'title': 'تم تعيين سائق',
            'subtitle': '',
            'active': true,
          },
          {
            'title': 'تم استلام الشحنة',
            'subtitle': '',
            'active': true,
          },
          {
            'title': 'الشحنة في الطريق',
            'subtitle': '',
            'active': true,
          },
        ];
      case 'out_for_delivery':
        return [
          ...baseSteps,
          {
            'title': 'تم تعيين سائق',
            'subtitle': '',
            'active': true,
          },
          {
            'title': 'تم استلام الشحنة',
            'subtitle': '',
            'active': true,
          },
          {
            'title': 'الشحنة في الطريق',
            'subtitle': '',
            'active': true,
          },
          {
            'title': 'خرجت للتسليم',
            'subtitle': '',
            'active': true,
          },
        ];
      case 'delivered':
        return [
          ...baseSteps,
          {
            'title': 'تم تعيين سائق',
            'subtitle': '',
            'active': true,
          },
          {
            'title': 'تم استلام الشحنة',
            'subtitle': '',
            'active': true,
          },
          {
            'title': 'الشحنة في الطريق',
            'subtitle': '',
            'active': true,
          },
          {
            'title': 'خرجت للتسليم',
            'subtitle': '',
            'active': true,
          },
          {
            'title': 'تم التسليم بنجاح',
            'subtitle': '',
            'active': true,
          },
        ];
      case 'cancelled':
        return [
          ...baseSteps,
          {
            'title': 'تم إلغاء الشحنة',
            'subtitle': '',
            'active': true,
          },
        ];
      case 'returned':
        return [
          ...baseSteps,
          {
            'title': 'تم إرجاع الشحنة',
            'subtitle': '',
            'active': true,
          },
        ];
      default:
        return baseSteps;
    }
  }
}