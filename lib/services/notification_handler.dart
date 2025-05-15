import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider_test/blocs/nav_bar/navigation_cubit.dart';

class NotificationHandler {
  static final NotificationHandler _instance = NotificationHandler._internal();
  factory NotificationHandler() => _instance;
  NotificationHandler._internal();

  void handleNotificationAction(
      BuildContext context, String actionId, Map<String, dynamic>? data) {
    switch (actionId) {
      case 'accept':
        _handleAcceptShipment(context, data);
        break;
      case 'reject':
        _handleRejectShipment(context, data);
        break;
      case 'view':
        _handleViewShipment(context, data);
        break;
      case 'view_earnings':
        _handleViewEarnings(context);
        break;
      case 'dismiss':
        // Dismiss notification - no action needed
        break;
    }
  }

  void _handleAcceptShipment(BuildContext context, Map<String, dynamic>? data) {
    if (data == null) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Remove loading indicator

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم قبول الشحنة بنجاح'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to shipments page
      context.read<NavigationCubit>().changeTab(1);
    });
  }

  void _handleRejectShipment(BuildContext context, Map<String, dynamic>? data) {
    if (data == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('رفض الشحنة'),
        content: const Text('هل أنت متأكد من رفض هذه الشحنة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _processRejection(context, data);
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _processRejection(BuildContext context, Map<String, dynamic> data) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Remove loading indicator

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم رفض الشحنة'),
          backgroundColor: Colors.orange,
        ),
      );
    });
  }

  void _handleViewShipment(BuildContext context, Map<String, dynamic>? data) {
    if (data == null) return;

    // Navigate to shipments page
    context.read<NavigationCubit>().changeTab(1);

    // Show shipment details
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => ShipmentDetailsSheet(
          data: data,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _handleViewEarnings(BuildContext context) {
    // Navigate to earnings page
    context.read<NavigationCubit>().changeTab(2);
  }
}

class ShipmentDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> data;
  final ScrollController scrollController;

  const ShipmentDetailsSheet({
    super.key,
    required this.data,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل الشحنة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                _buildDetailRow('رقم الشحنة', data['shipmentId'] ?? 'N/A'),
                _buildDetailRow('الوجهة', data['destination'] ?? 'N/A'),
                _buildDetailRow('المسافة', '${data['distance'] ?? 0} كم'),
                _buildDetailRow('الوزن', '${data['weight'] ?? 0} كجم'),
                _buildDetailRow('السعر', '${data['price'] ?? 0} ريال'),
                _buildDetailRow('الحالة', data['status'] ?? 'N/A'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
