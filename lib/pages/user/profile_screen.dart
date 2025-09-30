import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider_test/services/auth_service.dart';
import 'package:provider_test/services/user_data_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthService _authService = AuthService();
  final UserDataService _userDataService = UserDataService.instance;
  
  Map<String, dynamic>? _userData;
  Map<String, String> _senderData = {};
  bool _isLoading = true;
  bool _isEditing = false;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserData() async {
    try {
      // Get current user from AuthService (the real authenticated user)
      final currentUser = await _authService.getCurrentUser();
      Map<String, dynamic>? userData;
      
      if (currentUser != null) {
        userData = currentUser.userData;
      }
      
      final senderData = await _userDataService.getSenderDataAsMap();
      
      setState(() {
        _userData = userData;
        _senderData = senderData;
        _isLoading = false;
        
        // Use actual user data from authentication, not sender data
        final displayName = userData?['name'] ?? '';
        final displayPhone = userData?['phone'] ?? '';
            
        _nameController.text = displayName;
        _phoneController.text = displayPhone;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى ملء جميع الحقول المطلوبة',
            textAlign: TextAlign.right,
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    try {
      // Save to sender data
      await _userDataService.saveSenderDataFromMap(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        shortAddress: _senderData['shortAddress'] ?? '',
        buildingNumber: _senderData['buildingNumber'] ?? '',
        unitNumber: _senderData['unitNumber'] ?? '',
        postalCode: _senderData['postalCode'] ?? '',
        address: _senderData['address'] ?? '',
        notes: _senderData['notes'] ?? '',
      );
      
      setState(() {
        _senderData['name'] = _nameController.text.trim();
        _senderData['phone'] = _phoneController.text.trim();
        _isEditing = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم حفظ التغييرات بنجاح',
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'حدث خطأ أثناء حفظ التغييرات: ${e.toString()}',
              textAlign: TextAlign.right,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 32,
                width: 48,
                padding: const EdgeInsets.all(4),
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
                'الملف الشخصي',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 20,
                  color: Theme.of(context).cardColor,
                ),
              ),
            ],
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = screenSize.width * (isSmallScreen ? 0.05 : 0.07);
    final spacing = screenSize.width * (isSmallScreen ? 0.03 : 0.04);
    final titleFontSize = screenSize.width * (isSmallScreen ? 0.06 : 0.045);
    final primaryColor = theme.primaryColor;
    final cardColor = theme.cardColor;
    final backgroundColor = theme.scaffoldBackgroundColor;

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
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Text(
              'الملف الشخصي',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: titleFontSize,
                    color: Theme.of(context).cardColor,
                  ),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                children: [
                  _buildProfileHeader(
                      context, theme, primaryColor, cardColor, spacing),
                  SizedBox(height: spacing * 6),

                  // Action Buttons
                  _buildActionButton(
                    context,
                    icon: _isEditing ? Icons.save : Icons.edit,
                    label: _isEditing ? 'حفظ التغييرات' : 'تعديل البيانات الشخصية',
                    spacing: spacing,
                    onTap: _isEditing ? _saveChanges : () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                  ),
                  if (_isEditing)
                    _buildActionButton(
                      context,
                      icon: Icons.cancel,
                      label: 'إلغاء التعديل',
                      spacing: spacing,
                      onTap: () {
                        setState(() {
                          _isEditing = false;
                          // Reset the text controllers
                          if (_userData != null) {
                            _nameController.text = _userData!['name'] ?? '';
                            _phoneController.text = _userData!['phone'] ?? '';
                          }
                        });
                      },
                    ),
                  _buildActionButton(
                    context,
                    icon: Icons.location_on,
                    label: 'إدارة عناوين التوصيل',
                    spacing: spacing,
                    onTap: () {
                      context.push('/user-profile/addresses');
                    },
                  ),

                  SizedBox(height: spacing * 4),
                  _buildLogoutButton(context, primaryColor),
                  SizedBox(height: spacing * 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ThemeData theme,
      Color primaryColor, Color cardColor, double spacing) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final headerFontSize = screenSize.width * (isSmallScreen ? 0.06 : 0.055);
    final bodyFontSize = screenSize.width * (isSmallScreen ? 0.035 : 0.035);
    
    // Use actual authenticated user data
    final String displayName = _userData?['name'] ?? 'مستخدم';
    final String displayPhone = _userData?['phone'] ?? '';
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/prof_card.png',
            width: double.infinity,
            height: isSmallScreen ? 200 : 220,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: -spacing * 4,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: spacing),
            padding: EdgeInsets.symmetric(
                vertical: spacing * (isSmallScreen ? 1.2 : 2),
                horizontal: spacing * (isSmallScreen ? 1.5 : 2.5)),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen ? 60 : 80,
                  height: isSmallScreen ? 60 : 80,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person,
                      size: isSmallScreen ? 40 : 56, color: primaryColor),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_isEditing) ...[
                        TextField(
                          controller: _nameController,
                          textAlign: TextAlign.right,
                          style: theme.textTheme.displayLarge?.copyWith(
                              color: primaryColor, fontSize: headerFontSize * 0.9),
                          decoration: InputDecoration(
                            hintText: 'الاسم',
                            hintStyle: TextStyle(
                              color: primaryColor.withOpacity(0.5),
                              fontFamily: 'Cairo',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                        SizedBox(height: spacing * 0.5),
                        TextField(
                          controller: _phoneController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.phone,
                          style: theme.textTheme.bodyLarge?.copyWith(
                              color: primaryColor.withOpacity(0.8),
                              fontSize: bodyFontSize),
                          decoration: InputDecoration(
                            hintText: 'رقم الجوال',
                            hintStyle: TextStyle(
                              color: primaryColor.withOpacity(0.5),
                              fontFamily: 'Cairo',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ] else ...[
                        Text(
                          displayName,
                          style: theme.textTheme.displayLarge?.copyWith(
                              color: primaryColor, fontSize: headerFontSize),
                        ),
                        SizedBox(height: spacing * 0.1),
                        Text(
                          displayPhone,
                          style: theme.textTheme.bodyLarge?.copyWith(
                              color: primaryColor.withOpacity(0.7),
                              fontSize: bodyFontSize),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required double spacing,
      VoidCallback? onTap}) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final cardColor = theme.cardColor;
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final buttonFontSize = screenSize.width * (isSmallScreen ? 0.045 : 0.035);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: spacing * 1.2, horizontal: spacing * 1.5),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: primaryColor),
              const Spacer(),
              Text(
                label,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: primaryColor, fontSize: buttonFontSize),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignOut(BuildContext context) async {
    // Show confirmation dialog first
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'تأكيد تسجيل الخروج',
            textAlign: TextAlign.right,
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          content: const Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
            textAlign: TextAlign.right,
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
            ),
          ],
        );
      },
    );

    if (shouldSignOut == true && context.mounted) {
      try {
        // Perform sign out first
        final authService = AuthService();
        await authService.logout();

        // Navigate to login screen immediately without showing loading
        if (context.mounted) {
          context.go('/login');
        }
      } catch (e) {
        // Show error message only if sign out fails
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'حدث خطأ أثناء تسجيل الخروج: ${e.toString()}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  Widget _buildLogoutButton(BuildContext context, Color primaryColor) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final buttonFontSize = screenSize.width * (isSmallScreen ? 0.045 : 0.035);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton.icon(
        icon: Icon(Icons.logout_rounded, color: Colors.red.shade400),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).cardColor,
          foregroundColor: primaryColor,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 1,
        ),
        label: Text(
          'تسجيل الخروج',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontSize: buttonFontSize,
          ),
        ),
        onPressed: () => _handleSignOut(context),
      ),
    );
  }
}
