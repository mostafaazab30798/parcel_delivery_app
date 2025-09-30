import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider_test/services/user_data_service.dart';

class EditAddressScreen extends StatefulWidget {
  final String addressIndex;
  
  const EditAddressScreen({
    super.key,
    required this.addressIndex,
  });

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> with SingleTickerProviderStateMixin {
  final UserDataService _userDataService = UserDataService.instance;
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _shortAddressController = TextEditingController();
  final TextEditingController _buildingNumberController = TextEditingController();
  final TextEditingController _unitNumberController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  bool _isLoading = false;
  bool _isLoadingData = true;
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
    _loadAddressData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _shortAddressController.dispose();
    _buildingNumberController.dispose();
    _unitNumberController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadAddressData() async {
    try {
      final addresses = await _userDataService.loadAllAddresses();
      final index = int.parse(widget.addressIndex);
      
      if (index < addresses.length) {
        final address = addresses[index];
        setState(() {
          _nameController.text = address['name'] ?? '';
          _phoneController.text = address['phone'] ?? '';
          _shortAddressController.text = address['shortAddress'] ?? '';
          _buildingNumberController.text = address['buildingNumber'] ?? '';
          _unitNumberController.text = address['unitNumber'] ?? '';
          _postalCodeController.text = address['postalCode'] ?? '';
          _cityController.text = address['city'] ?? '';
          _districtController.text = address['district'] ?? '';
          _addressController.text = address['address'] ?? '';
          _isLoadingData = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingData = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('حدث خطأ في تحميل بيانات العنوان'),
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

  Future<void> _updateAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final addressData = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'shortAddress': _shortAddressController.text.trim(),
        'buildingNumber': _buildingNumberController.text.trim(),
        'unitNumber': _unitNumberController.text.trim(),
        'postalCode': _postalCodeController.text.trim(),
        'city': _cityController.text.trim(),
        'district': _districtController.text.trim(),
        'address': _addressController.text.trim(),
        'notes': '',
      };
      
      final index = int.parse(widget.addressIndex);
      final success = await _userDataService.updateAddressAtIndex(index, addressData);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('تم تحديث العنوان بنجاح'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        context.pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('فشل في تحديث العنوان'),
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('حدث خطأ: ${e.toString()}'),
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                              'تعديل العنوان',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: darkTextColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'تحديث معلومات العنوان',
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
                          Icons.edit_location_alt_outlined,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Content
                Expanded(
                  child: _isLoadingData
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: primaryColor),
                              SizedBox(height: 16),
                              Text(
                                'جاري تحميل بيانات العنوان...',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Personal Information Section
                                _buildSectionHeader(
                                  'المعلومات الشخصية',
                                  Icons.person_outline,
                                  primaryColor,
                                ),
                                SizedBox(height: 16),
                                _buildModernTextField(
                                  controller: _nameController,
                                  label: 'الاسم الكامل',
                                  icon: Icons.person_outline,
                                  required: true,
                                  hintText: 'أدخل اسمك الكامل',
                                ),
                                SizedBox(height: 16),
                                _buildModernTextField(
                                  controller: _phoneController,
                                  label: 'رقم الجوال',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  required: true,
                                  hintText: '05XXXXXXXX',
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'رقم الجوال مطلوب';
                                    }
                                    if (!RegExp(r'^05\d{8}$').hasMatch(value.trim())) {
                                      return 'يجب أن يبدأ الرقم بـ 05 ويكون 10 أرقام';
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 32),

                                // Address Information Section
                                _buildSectionHeader(
                                  'معلومات العنوان',
                                  Icons.location_on_outlined,
                                  primaryColor,
                                ),
                                SizedBox(height: 16),
                                
                                // Quick Address Code (Optional)
                                _buildModernTextField(
                                  controller: _shortAddressController,
                                  label: 'الرمز المختصر للعنوان',
                                  icon: Icons.qr_code_2_outlined,
                                  hintText: 'مثال: RRD1234567',
                                  isOptional: true,
                                ),
                                SizedBox(height: 16),

                                // City and District Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: _cityController,
                                        label: 'المدينة',
                                        icon: Icons.location_city_outlined,
                                        required: true,
                                        hintText: 'الرياض، جدة...',
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: _districtController,
                                        label: 'الحي',
                                        icon: Icons.map_outlined,
                                        required: true,
                                        hintText: 'العليا، النخيل...',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),

                                // Building and Unit Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: _buildingNumberController,
                                        label: 'رقم المبنى',
                                        icon: Icons.apartment_outlined,
                                        hintText: '1234',
                                        isOptional: true,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: _unitNumberController,
                                        label: 'رقم الوحدة',
                                        icon: Icons.door_front_door_outlined,
                                        hintText: '12، A، الأول...',
                                        isOptional: true,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),

                                _buildModernTextField(
                                  controller: _postalCodeController,
                                  label: 'الرمز البريدي',
                                  icon: Icons.markunread_mailbox_outlined,
                                  keyboardType: TextInputType.number,
                                  hintText: '12345',
                                  isOptional: true,
                                  validator: (value) {
                                    if (value != null && value.trim().isNotEmpty) {
                                      if (!RegExp(r'^\d{5}$').hasMatch(value.trim())) {
                                        return 'الرمز البريدي يجب أن يكون 5 أرقام';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),

                                _buildModernTextField(
                                  controller: _addressController,
                                  label: 'تفاصيل إضافية',
                                  icon: Icons.note_outlined,
                                  maxLines: 3,
                                  hintText: 'معلومات إضافية تساعد في الوصول للعنوان',
                                  isOptional: true,
                                ),

                                SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                ),

                // Update Button
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: _buildModernUpdateButton(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: darkTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
    bool isOptional = false,
    int maxLines = 1,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: darkTextColor,
              ),
            ),
            if (required) ...[
              SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
            if (isOptional) ...[
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'اختياري',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          textAlign: TextAlign.right,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            color: darkTextColor,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 12, right: 8),
              child: Icon(
                icon,
                color: lightBrownColor,
                size: 20,
              ),
            ),
            filled: true,
            fillColor: Color(0xFFFFFAF3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: secondaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: secondaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 14,
            ),
            errorStyle: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
          validator: validator ?? (required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'هذا الحقل مطلوب';
                  }
                  return null;
                }
              : null),
        ),
      ],
    );
  }

  Widget _buildModernUpdateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateAddress,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'جاري التحديث...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.update_outlined, size: 20, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'تحديث العنوان',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}