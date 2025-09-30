import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/shipment_api/shipment_api_bloc.dart';
import '../../blocs/shipment_api/shipment_api_event.dart';
import '../../repos/shipment_repository.dart';
import '../../services/shipment_api_service.dart';
import '../../components/user/recent_shipments.dart';

class UserShipmentScreen extends StatelessWidget {
  const UserShipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    final fontSize = screenSize.width * (isSmallScreen ? 0.06 : 0.07);
    
    return BlocProvider(
      create: (context) => ShipmentApiBloc(
        repository: ShipmentRepository(
          apiService: ShipmentApiService(),
        ),
      )..add(const ShipmentApiLoadRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: spacing * 4,
                width: spacing * 6,
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
              Text(
                'شحناتك',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: fontSize * 1.2,
                      color: Theme.of(context).cardColor,
                    ),
              ),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<ShipmentApiBloc>().add(const ShipmentApiLoadRequested());
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      vertical: padding * 0.5, horizontal: padding * 0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      RecentShipments(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
