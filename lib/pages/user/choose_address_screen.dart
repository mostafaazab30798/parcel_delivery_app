import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider_test/services/user_data_service.dart';

class ChooseAddressScreen extends StatefulWidget {
  const ChooseAddressScreen({super.key});

  @override
  State<ChooseAddressScreen> createState() => _ChooseAddressScreenState();
}

class _ChooseAddressScreenState extends State<ChooseAddressScreen> {
  final UserDataService _userDataService = UserDataService.instance;
  List<Map<String, String>> _savedAddresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final addresses = await _userDataService.loadAllAddresses();
      setState(() {
        _savedAddresses = addresses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectAddress(Map<String, String> address) {
    print('🎯 Address selected in ChooseAddressScreen:');
    print('  Name: ${address['name']}');
    print('  Phone: ${address['phone']}');
    print('  Short Address: ${address['shortAddress']}');
    print('  Building Number: ${address['buildingNumber']}');
    print('  Unit Number: ${address['unitNumber']}');
    print('  Postal Code: ${address['postalCode']}');
    print('  City: ${address['city']}');
    print('  District: ${address['district']}');
    print('  Address: ${address['address']}');
    
    Navigator.of(context).pop(address);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    final titleFontSize = screenSize.width * (isSmallScreen ? 0.06 : 0.045);

    return Scaffold(
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
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Text(
              'اختيار عنوان',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: titleFontSize,
                color: Theme.of(context).cardColor,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: _savedAddresses.isEmpty
                      ? _buildEmptyState(context, spacing)
                      : ListView.builder(
                          padding: EdgeInsets.all(padding),
                          itemCount: _savedAddresses.length,
                          itemBuilder: (context, index) {
                            final address = _savedAddresses[index];
                            return _buildAddressCard(context, address, spacing);
                          },
                        ),
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, double spacing) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.all(spacing * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: spacing * 8,
            color: theme.primaryColor.withOpacity(0.3),
          ),
          SizedBox(height: spacing * 2),
          Text(
            'لا توجد عناوين محفوظة',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.primaryColor.withOpacity(0.7),
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: spacing),
          Text(
            'يمكنك إضافة عناوين جديدة من صفحة إدارة العناوين',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.primaryColor.withOpacity(0.5),
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, Map<String, String> address, double spacing) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Card(
      margin: EdgeInsets.only(bottom: spacing),
      child: InkWell(
        onTap: () => _selectAddress(address),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(spacing * 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    color: primaryColor.withOpacity(0.5),
                    size: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          address['name'] ?? '',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(height: spacing * 0.5),
                        Text(
                          address['phone'] ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: primaryColor.withOpacity(0.8),
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing),
              if (address['shortAddress']?.isNotEmpty == true) ...[
                _buildAddressDetail('الرمز المختصر', address['shortAddress']!, primaryColor),
                SizedBox(height: spacing * 0.5),
              ],
              if (address['buildingNumber']?.isNotEmpty == true) ...[
                _buildAddressDetail('رقم المبنى', address['buildingNumber']!, primaryColor),
                SizedBox(height: spacing * 0.5),
              ],
              if (address['unitNumber']?.isNotEmpty == true) ...[
                _buildAddressDetail('رقم الوحدة', address['unitNumber']!, primaryColor),
                SizedBox(height: spacing * 0.5),
              ],
              if (address['postalCode']?.isNotEmpty == true) ...[
                _buildAddressDetail('الرمز البريدي', address['postalCode']!, primaryColor),
                SizedBox(height: spacing * 0.5),
              ],
              if (address['city']?.isNotEmpty == true) ...[
                _buildAddressDetail('المدينة', address['city']!, primaryColor),
                SizedBox(height: spacing * 0.5),
              ],
              if (address['district']?.isNotEmpty == true) ...[
                _buildAddressDetail('الحي', address['district']!, primaryColor),
                SizedBox(height: spacing * 0.5),
              ],
              if (address['address']?.isNotEmpty == true) ...[
                _buildAddressDetail('تفاصيل إضافية', address['address']!, primaryColor),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressDetail(String label, String value, Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(
              color: primaryColor.withOpacity(0.8),
              fontFamily: 'Cairo',
            ),
          ),
        ),
        Text(
          '$label: ',
          style: TextStyle(
            color: primaryColor.withOpacity(0.6),
            fontWeight: FontWeight.w500,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}