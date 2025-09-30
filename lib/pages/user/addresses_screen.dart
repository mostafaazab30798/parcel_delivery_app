import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider_test/services/user_data_service.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> with SingleTickerProviderStateMixin {
  final UserDataService _userDataService = UserDataService.instance;
  List<Map<String, String>> _savedAddresses = [];
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // App color scheme
  static const primaryColor = Color(0xFF9B652E);
  static const secondaryColor = Color(0xFFF9B233);
  static const backgroundColor = Color(0xFFF5F5F5);
  static const darkTextColor = Color(0xFF222831);
  static const lightBrownColor = Color(0xFF8B572A);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _loadAddresses();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAddresses() async {
    try {
      final addresses = await _userDataService.loadAllAddresses();
      if (mounted) {
        setState(() {
          _savedAddresses = addresses;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteAddress(int index) async {
    try {
      await _userDataService.deleteAddressAtIndex(index);
      setState(() {
        _savedAddresses.removeAt(index);
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('تم حذف العنوان بنجاح'),
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('حدث خطأ أثناء حذف العنوان'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'تأكيد الحذف',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'هل أنت متأكد من رغبتك في حذف هذا العنوان؟',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _deleteAddress(index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'حذف',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Clean App Bar - matching other screens
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
                        onPressed: () => context.pop(),
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
                              'العناوين المحفوظة',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: darkTextColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'إدارة عناوين التوصيل',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: lightBrownColor,
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
                          Icons.location_on_outlined,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : _savedAddresses.isEmpty
                          ? _buildEmptyState(context)
                          : _buildAddressList(context),
                ),
              ],
            ),
          ),
        ),
        
        // Modern FAB
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.push('/user-profile/addresses/add').then((_) => _loadAddresses());
          },
          backgroundColor: primaryColor,
          icon: Icon(Icons.add_location_alt_outlined, color: Colors.white),
          label: Text(
            'إضافة عنوان',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off_outlined,
                size: 64,
                color: primaryColor.withOpacity(0.4),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'لا توجد عناوين محفوظة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: darkTextColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'قم بإضافة عناوين التوصيل المفضلة لديك\nلاستخدامها بسرعة في الشحنات القادمة',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.push('/user-profile/addresses/add').then((_) => _loadAddresses());
              },
              icon: Icon(Icons.add_location_alt_outlined),
              label: Text('إضافة أول عنوان'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressList(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _savedAddresses.length,
      itemBuilder: (context, index) {
        final address = _savedAddresses[index];
        return _buildModernAddressCard(context, address, index);
      },
    );
  }

  Widget _buildModernAddressCard(BuildContext context, Map<String, String> address, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Could navigate to edit screen or show details
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with name and actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address['name'] ?? 'غير محدد',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: darkTextColor,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  address['phone'] ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Action buttons
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Edit functionality
                            context.push('/user-profile/addresses/edit/$index')
                                .then((_) => _loadAddresses());
                          },
                          icon: Icon(Icons.edit_outlined),
                          color: primaryColor,
                          iconSize: 20,
                        ),
                        IconButton(
                          onPressed: () => _showDeleteConfirmation(index),
                          icon: Icon(Icons.delete_outline),
                          color: Colors.red[400],
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // Address details
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFAF3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: secondaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      if (address['shortAddress']?.isNotEmpty == true)
                        _buildDetailRow(
                          Icons.qr_code_2,
                          'الرمز المختصر',
                          address['shortAddress']!,
                        ),
                      if (address['city']?.isNotEmpty == true)
                        _buildDetailRow(
                          Icons.location_city,
                          'المدينة',
                          address['city']!,
                        ),
                      if (address['district']?.isNotEmpty == true)
                        _buildDetailRow(
                          Icons.map,
                          'الحي',
                          address['district']!,
                        ),
                      if (address['buildingNumber']?.isNotEmpty == true ||
                          address['unitNumber']?.isNotEmpty == true)
                        _buildDetailRow(
                          Icons.apartment,
                          'المبنى/الوحدة',
                          '${address['buildingNumber'] ?? ''} ${address['unitNumber'] != null ? '/ ${address['unitNumber']}' : ''}',
                        ),
                      if (address['postalCode']?.isNotEmpty == true)
                        _buildDetailRow(
                          Icons.markunread_mailbox_outlined,
                          'الرمز البريدي',
                          address['postalCode']!,
                        ),
                      if (address['address']?.isNotEmpty == true)
                        _buildDetailRow(
                          Icons.note,
                          'ملاحظات',
                          address['address']!,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: lightBrownColor,
          ),
          SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 12,
              color: lightBrownColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: darkTextColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}