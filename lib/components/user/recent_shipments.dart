import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/shipment_api/shipment_api_bloc.dart';
import '../../blocs/shipment_api/shipment_api_event.dart';
import '../../blocs/shipment_api/shipment_api_state.dart';
import '../../models/api_shipment.dart';
import 'shipment.dart';

class RecentShipments extends StatelessWidget {
  const RecentShipments({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final borderRadiusValue = screenSize.width * (isSmallScreen ? 0.02 : 0.025);

    return BlocBuilder<ShipmentApiBloc, ShipmentApiState>(
      builder: (context, state) {
        return switch (state) {
          ShipmentApiInitial() => _buildEmptyState(context, 'اضغط لتحديث الشحنات'),
          ShipmentApiLoading() => _buildLoadingState(context),
          ShipmentApiSuccess() => _buildShipmentsList(
            context, 
            state.shipments, 
            borderRadiusValue,
            isSmallScreen,
          ),
          ShipmentApiFailure() => _buildErrorState(context, state.message),
        };
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            if (message == 'اضغط لتحديث الشحنات') ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<ShipmentApiBloc>().add(const ShipmentApiLoadRequested());
                },
                icon: const Icon(Icons.refresh),
                label: const Text('تحديث'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('جاري تحميل الشحنات...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ أثناء تحميل الشحنات',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.red.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SelectableText.rich(
              TextSpan(
                text: errorMessage,
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ShipmentApiBloc>().add(const ShipmentApiLoadRequested());
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentsList(
    BuildContext context,
    List<ApiShipment> shipments,
    double borderRadiusValue,
    bool isSmallScreen,
  ) {
    if (shipments.isEmpty) {
      return _buildEmptyState(context, 'لا توجد شحنات حالياً');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Header with shipment count
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إجمالي الشحنات: ${shipments.length}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Icon(
                Icons.local_shipping_outlined,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ],
          ),
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: shipments.length,
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey.shade300,
              height: 1,
            );
          },
          itemBuilder: (context, index) {
            final shipment = shipments[index];
            BorderRadius borderRadius = BorderRadius.zero;
            
            if (index == 0) {
              borderRadius = BorderRadius.only(
                topLeft: Radius.circular(borderRadiusValue * 1.5),
                topRight: Radius.circular(borderRadiusValue * 1.5),
              );
            } else if (index == shipments.length - 1) {
              borderRadius = BorderRadius.only(
                bottomLeft: Radius.circular(borderRadiusValue * 1.5),
                bottomRight: Radius.circular(borderRadiusValue * 1.5),
              );
            }

            return _buildShipmentItem(
              context,
              shipment,
              borderRadius,
              isSmallScreen,
            );
          },
        ),
      ],
    );
  }

  Widget _buildShipmentItem(
    BuildContext context,
    ApiShipment shipment,
    BorderRadius borderRadius,
    bool isSmallScreen,
  ) {
    return buildShippingItem(
      context,
      shipment,
      borderRadius: borderRadius,
    );
  }
}
