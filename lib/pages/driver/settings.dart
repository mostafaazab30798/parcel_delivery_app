import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:provider_test/blocs/auth/bloc.dart';
import 'package:provider_test/blocs/auth/event.dart';
import 'package:provider_test/blocs/auth/state.dart';
import 'package:provider_test/components/saudi_plate.dart';
import 'package:provider_test/services/firestore_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class DriverSettingsScreen extends StatelessWidget {
  const DriverSettingsScreen({super.key});

  Future<void> _loadUserData(BuildContext context) async {
    final firestore = FirestoreService();
    final data = await firestore.getUserData();
    context.read<AuthBloc>().add(LoadUserData(data));
  }

  Future<void> _pickAndUpdateProfilePicture(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        // Get the temporary directory
        final directory = await getTemporaryDirectory();
        final String fileName =
            'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String filePath = path.join(directory.path, fileName);

        // Convert the image to JPEG format
        final File convertedImage = File(filePath);
        final bytes = await image.readAsBytes();
        await convertedImage.writeAsBytes(bytes);

        // Save the converted image path to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_picture', convertedImage.path);

        // Update the profile picture in Firestore
        context.read<AuthBloc>().add(UpdateProfilePicture(convertedImage.path));
      }
    } catch (e) {
      _showSnackBar(context, 'حدث خطأ أثناء اختيار الصورة', isError: true);
    }
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _showSnackBar(context, state.message, isError: true);
        } else if (state is UserDataLoaded && state.isProfilePictureUpdate) {
          _showSnackBar(context, 'تم تحديث صورة الملف الشخصي بنجاح');
        }
      },
      builder: (context, state) {
        if (state is AuthInitial) {
          _loadUserData(context);
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = state is UserDataLoaded ? state.userData : null;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, isSmallScreen),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final padding =
                            screenSize.width * (isSmallScreen ? 0.02 : 0.03);
                        final iconSize =
                            screenSize.width * (isSmallScreen ? 0.045 : 0.05);
                        final fontSize =
                            screenSize.width * (isSmallScreen ? 0.03 : 0.045);
                        final titleFontSize =
                            screenSize.width * (isSmallScreen ? 0.04 : 0.075);
                        final spacing =
                            screenSize.width * (isSmallScreen ? 0.01 : 0.015);
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildProfileSection(
                                  context,
                                  userData,
                                  isSmallScreen,
                                  padding,
                                  iconSize,
                                  fontSize,
                                  titleFontSize,
                                  spacing),
                              _buildSettingsSection(
                                  context,
                                  isSmallScreen,
                                  padding,
                                  iconSize,
                                  fontSize,
                                  titleFontSize,
                                  spacing),
                              _buildSupportSection(
                                  context,
                                  isSmallScreen,
                                  padding,
                                  iconSize,
                                  fontSize,
                                  titleFontSize,
                                  spacing),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    final screenSize = MediaQuery.of(context).size;
    final padding = screenSize.width * (isSmallScreen ? 0.02 : 0.03);
    final fontSize = screenSize.width * (isSmallScreen ? 0.06 : 0.075);

    return Padding(
      padding: EdgeInsets.only(
        top: padding * 2,
        right: padding * 3,
        bottom: padding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'الإعدادات',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: fontSize,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(
      BuildContext context,
      Map<String, dynamic>? userData,
      bool isSmallScreen,
      double padding,
      double iconSize,
      double fontSize,
      double titleFontSize,
      double spacing) {
    final name = userData?['name'] ?? 'Mostafa Mahmoud';
    final capitalizedName = name
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
    final phone = userData?['phone'] ?? '';
    final formattedPhone = phone.isNotEmpty ? '+966 $phone' : '+966537181037';

    return Padding(
      padding: EdgeInsets.all(padding * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: spacing * 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _showUpdateProfileDialog(
                              context,
                              isSmallScreen,
                              padding,
                              iconSize,
                              fontSize,
                              titleFontSize,
                              spacing),
                          icon: Icon(
                            Icons.edit,
                            color: Colors.orange.withOpacity(0.5),
                            size: iconSize * 0.8,
                          ),
                          label: Text(
                            'تعديل الملف الشخصي',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  fontSize: fontSize * 0.9,
                                  color: Colors.black87,
                                ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(spacing * 2),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing * 2,
                              vertical: spacing * 1.6,
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              width: iconSize * 3,
                              height: iconSize * 3,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.blue.withOpacity(0.2),
                                    width: spacing * 0.4),
                                image: userData?['profilePicture'] != null
                                    ? DecorationImage(
                                        image: FileImage(
                                            File(userData!['profilePicture'])),
                                        fit: BoxFit.cover,
                                      )
                                    : const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/courier.png'),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () =>
                                    _pickAndUpdateProfilePicture(context),
                                child: Container(
                                  padding: EdgeInsets.all(spacing * 0.6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: spacing * 0.4,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: iconSize * 0.8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: spacing * 2),
                    Text(
                      capitalizedName,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: titleFontSize * 0.9,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                overflow: TextOverflow.ellipsis,
                              ),
                    ),
                    SizedBox(height: spacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SaudiLicensePlate(
                          initialNumbers:
                              userData?['vehiclePlateNumber'] != null
                                  ? userData!['vehiclePlateNumber']
                                          .toString()
                                          .split(' ')
                                          .firstOrNull ??
                                      '9923'
                                  : '9923',
                          initialLetters:
                              userData?['vehiclePlateNumber'] != null
                                  ? userData!['vehiclePlateNumber']
                                              .toString()
                                              .split(' ')
                                              .length >
                                          1
                                      ? userData['vehiclePlateNumber']
                                          .toString()
                                          .split(' ')[1]
                                      : 'لما'
                                  : 'لما',
                          onChanged: (numbers, letters) {
                            context.read<AuthBloc>().add(
                                  UpdateUserProfile(
                                    vehiclePlateNumber: '$numbers $letters',
                                  ),
                                );
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (formattedPhone.isNotEmpty) ...[
                              SizedBox(height: spacing * 0.4),
                              Text(
                                formattedPhone,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      fontSize: fontSize,
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                            SizedBox(height: spacing * 0.4),
                            Text(
                              'سائق توصيل',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    fontSize: fontSize * 0.9,
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildSettingsSection(
      BuildContext context,
      bool isSmallScreen,
      double padding,
      double iconSize,
      double fontSize,
      double titleFontSize,
      double spacing) {
    return Padding(
      padding: EdgeInsets.all(padding * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'إعدادات الحساب',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: titleFontSize * 0.8,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          SizedBox(height: spacing * 2),
          _buildSettingCard(
            'تغيير كلمة المرور',
            Icons.lock_outline,
            Colors.blue,
            context,
            isSmallScreen,
            padding,
            iconSize,
            fontSize,
            spacing,
            onTap: () => _showChangePasswordDialog(context, isSmallScreen,
                padding, iconSize, fontSize, titleFontSize, spacing),
          ),
          _buildSettingCard(
            'تغيير رقم الهاتف',
            Icons.phone_outlined,
            Colors.green,
            context,
            isSmallScreen,
            padding,
            iconSize,
            fontSize,
            spacing,
            onTap: () => _showChangePhoneDialog(context, isSmallScreen, padding,
                iconSize, fontSize, titleFontSize, spacing),
          ),
          _buildSettingCard(
            'المستندات',
            Icons.document_scanner,
            Colors.orange,
            context,
            isSmallScreen,
            padding,
            iconSize,
            fontSize,
            spacing,
            onTap: () => _showDocumentsDialog(context, isSmallScreen, padding,
                iconSize, fontSize, titleFontSize, spacing),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(
      BuildContext context,
      bool isSmallScreen,
      double padding,
      double iconSize,
      double fontSize,
      double titleFontSize,
      double spacing) {
    return Padding(
      padding: EdgeInsets.all(padding * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'الدعم',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: titleFontSize * 0.8,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          SizedBox(height: spacing * 2),
          _buildSettingCard(
            'مركز المساعدة',
            Icons.help_outline,
            Colors.teal,
            context,
            isSmallScreen,
            padding,
            iconSize,
            fontSize,
            spacing,
            onTap: () {},
          ),
          _buildSettingCard(
            'الشروط والأحكام',
            Icons.description_outlined,
            Colors.brown,
            context,
            isSmallScreen,
            padding,
            iconSize,
            fontSize,
            spacing,
            onTap: () {},
          ),
          _buildSettingCard(
            'تسجيل الخروج',
            Icons.logout,
            Colors.red,
            context,
            isSmallScreen,
            padding,
            iconSize,
            fontSize,
            spacing,
            onTap: () => _showLogoutDialog(context, isSmallScreen, padding,
                iconSize, fontSize, titleFontSize, spacing),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard(
    String title,
    IconData icon,
    Color color,
    BuildContext context,
    bool isSmallScreen,
    double padding,
    double iconSize,
    double fontSize,
    double spacing, {
    required VoidCallback onTap,
  }) {
    return Card(
      color: Color(0xFFE3ECF5),
      margin: EdgeInsets.only(bottom: spacing * 2),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spacing * 2),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing * 3,
          vertical: spacing * 0.8,
        ),
        trailing: Container(
          width: iconSize * 1.6,
          height: iconSize * 1.6,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(spacing * 2),
          ),
          child: Icon(icon, color: color, size: iconSize * 0.8),
        ),
        title: Text(
          title,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: fontSize,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  void _showLogoutDialog(
      BuildContext context,
      bool isSmallScreen,
      double padding,
      double iconSize,
      double fontSize,
      double titleFontSize,
      double spacing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'تسجيل الخروج',
          textAlign: TextAlign.right,
          style: GoogleFonts.cairo(
            fontSize: titleFontSize * 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text('هل أنت متأكد من تسجيل الخروج؟',
            style: GoogleFonts.cairo(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء',
                style: GoogleFonts.cairo(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.right),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(spacing * 2),
              ),
            ),
            onPressed: () {
              // context.read<AuthBloc>().add(LogoutRequested());
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(builder: (context) => AuthPage()),
              //   (route) => false,
              // );
            },
            child: Text('تأكيد',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  void _showUpdateProfileDialog(
      BuildContext context,
      bool isSmallScreen,
      double padding,
      double iconSize,
      double fontSize,
      double titleFontSize,
      double spacing) {
    final state = context.read<AuthBloc>().state;
    final userData = state is UserDataLoaded ? state.userData : null;
    final nameController = TextEditingController(text: userData?['name']);

    final vehicleTypeController =
        TextEditingController(text: userData?['vehicleType']);

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing * 4)),
        child: Container(
          padding: EdgeInsets.all(padding * 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(spacing * 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('تحديث الملف الشخصي',
                  style: GoogleFonts.alexandria(
                    fontSize: titleFontSize * 0.8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right),
              SizedBox(height: spacing * 4),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'الاسم',
                  labelStyle: GoogleFonts.cairo(fontSize: fontSize * 0.8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(spacing * 2)),
                  prefixIcon: Icon(Icons.person_outline, size: iconSize * 0.8),
                ),
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(fontSize: fontSize),
              ),
              SizedBox(height: spacing * 3),
              TextField(
                style: GoogleFonts.cairo(fontSize: fontSize),
                controller: vehicleTypeController,
                decoration: InputDecoration(
                  labelText: 'نوع المركبة',
                  labelStyle: GoogleFonts.cairo(fontSize: fontSize * 0.8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(spacing * 2)),
                  prefixIcon:
                      Icon(Icons.directions_car_outlined, size: iconSize * 0.8),
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: spacing * 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text('إلغاء',
                        style: GoogleFonts.cairo(
                            color: Colors.red[600], fontSize: fontSize)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final firestore = FirestoreService();
                      final success = await firestore.updateUserProfile(
                        name: nameController.text,
                        vehicleType: vehicleTypeController.text,
                      );

                      if (!dialogContext.mounted) return;

                      Navigator.pop(dialogContext);
                      _loadUserData(context);

                      if (success) {
                        _showSnackBar(context, 'تم تحديث الملف الشخصي بنجاح');
                      } else {
                        _showSnackBar(context, 'فشل تحديث الملف الشخصي',
                            isError: true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.8),
                      padding: EdgeInsets.symmetric(
                          horizontal: padding * 8, vertical: padding * 3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(spacing * 2)),
                    ),
                    child: Text('حفظ',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                        textAlign: TextAlign.right),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(
      BuildContext context,
      bool isSmallScreen,
      double padding,
      double iconSize,
      double fontSize,
      double titleFontSize,
      double spacing) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing * 4)),
        child: Container(
          padding: EdgeInsets.all(padding * 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(spacing * 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('تغيير كلمة المرور',
                    style: GoogleFonts.alexandria(
                      fontSize: titleFontSize * 0.8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right),
                SizedBox(height: spacing * 4),
                TextFormField(
                  controller: currentPasswordController,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الحالية',
                    labelStyle: GoogleFonts.cairo(fontSize: fontSize * 0.8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(spacing * 2)),
                    prefixIcon: Icon(Icons.lock_outline, size: iconSize * 0.8),
                  ),
                  obscureText: true,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(fontSize: fontSize),
                  validator: (value) => value == null || value.isEmpty
                      ? 'الرجاء إدخال كلمة المرور الحالية'
                      : null,
                ),
                SizedBox(height: spacing * 3),
                TextFormField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الجديدة',
                    labelStyle: GoogleFonts.cairo(fontSize: fontSize * 0.8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(spacing * 2)),
                    prefixIcon: Icon(Icons.lock_outline, size: iconSize * 0.8),
                  ),
                  obscureText: true,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(fontSize: fontSize),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور الجديدة';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                SizedBox(height: spacing * 3),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'تأكيد كلمة المرور الجديدة',
                    labelStyle: GoogleFonts.cairo(fontSize: fontSize * 0.8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(spacing * 2)),
                    prefixIcon: Icon(Icons.lock_outline, size: iconSize * 0.8),
                  ),
                  obscureText: true,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(fontSize: fontSize),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء تأكيد كلمة المرور الجديدة';
                    }
                    if (value != newPasswordController.text) {
                      return 'كلمة المرور غير متطابقة';
                    }
                    return null;
                  },
                ),
                SizedBox(height: spacing * 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text('إلغاء',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[600],
                              )),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (!dialogContext.mounted) return;

                          context.read<AuthBloc>().add(
                                ChangePassword(
                                  currentPassword:
                                      currentPasswordController.text,
                                  newPassword: newPasswordController.text,
                                ),
                              );
                          Navigator.pop(dialogContext);
                          _showSnackBar(context, 'تم تغيير كلمة المرور بنجاح');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.8),
                        padding: EdgeInsets.symmetric(
                            horizontal: padding * 8, vertical: padding * 3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(spacing * 2)),
                      ),
                      child: Text('تغيير',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChangePhoneDialog(
      BuildContext context,
      bool isSmallScreen,
      double padding,
      double iconSize,
      double fontSize,
      double titleFontSize,
      double spacing) {
    final state = context.read<AuthBloc>().state;
    final userData = state is UserDataLoaded ? state.userData : null;
    final phoneController =
        TextEditingController(text: userData?['phone'] ?? '');
    bool isValidating = false;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing * 4)),
        child: Container(
          padding: EdgeInsets.all(padding * 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(spacing * 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'تغيير رقم الهاتف',
                style: GoogleFonts.alexandria(
                  fontSize: titleFontSize * 0.8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: spacing * 4),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(spacing * 2),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextFormField(
                  controller: phoneController,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: '5XXXXXXXX',
                    hintStyle: GoogleFonts.cairo(
                      color: Colors.grey[400],
                      fontSize: fontSize,
                    ),
                    prefixIcon: Container(
                      padding: EdgeInsets.symmetric(horizontal: spacing * 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '+966',
                            style: GoogleFonts.cairo(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: spacing * 4,
                      vertical: spacing * 3,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(9),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              SizedBox(height: spacing * 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(
                      'إلغاء',
                      style: GoogleFonts.cairo(
                        color: Colors.red[600],
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                  StatefulBuilder(
                    builder: (context, setState) => ElevatedButton(
                      onPressed: isValidating
                          ? null
                          : () async {
                              if (phoneController.text.isEmpty) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'الرجاء إدخال رقم الهاتف',
                                        style: GoogleFonts.cairo(
                                            fontSize: fontSize),
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(padding * 4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(spacing * 2),
                                      ),
                                    ),
                                  );
                                }
                                return;
                              }

                              if (phoneController.text.length != 9) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'رقم الهاتف يجب أن يكون 9 أرقام',
                                        style: GoogleFonts.cairo(
                                            fontSize: fontSize),
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(padding * 4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(spacing * 2),
                                      ),
                                    ),
                                  );
                                }
                                return;
                              }

                              setState(() => isValidating = true);

                              try {
                                if (context.mounted) {
                                  context.read<AuthBloc>().add(
                                        UpdateUserProfile(
                                          phone: phoneController.text,
                                        ),
                                      );
                                }

                                if (dialogContext.mounted) {
                                  Navigator.pop(dialogContext);
                                }

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'تم تحديث رقم الهاتف بنجاح',
                                        style: GoogleFonts.cairo(
                                            fontSize: fontSize),
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(padding * 4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(spacing * 2),
                                      ),
                                    ),
                                  );
                                }
                              } finally {
                                setState(() => isValidating = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.8),
                        padding: EdgeInsets.symmetric(
                            horizontal: padding * 8, vertical: padding * 3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(spacing * 2)),
                      ),
                      child: isValidating
                          ? SizedBox(
                              width: iconSize,
                              height: iconSize,
                              child: CircularProgressIndicator(
                                strokeWidth: spacing * 0.4,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'حفظ',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDocumentsDialog(
      BuildContext context,
      bool isSmallScreen,
      double padding,
      double iconSize,
      double fontSize,
      double titleFontSize,
      double spacing) {
    final state = context.read<AuthBloc>().state;
    final userData = state is UserDataLoaded ? state.userData : null;
    final iqamaController =
        TextEditingController(text: userData?['iqamaNumber'] ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing * 4)),
        child: Container(
          padding: EdgeInsets.all(padding * 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(spacing * 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'المستندات',
                style: GoogleFonts.alexandria(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: spacing * 4),
              Text(
                'رقم الإقامة',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.black87,
                      fontSize: fontSize,
                    ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: spacing * 2),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(spacing * 2),
                  border: DashedBorder.fromBorderSide(
                    dashLength: spacing * 2,
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: TextFormField(
                  controller: iqamaController,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.black87,
                        fontSize: fontSize,
                      ),
                  decoration: InputDecoration(
                    hintText: '٢٢٣٣٤٤٥٥٦٦',
                    hintStyle: GoogleFonts.cairo(
                      color: Colors.grey[400],
                      fontSize: fontSize,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: spacing * 4,
                      vertical: spacing * 3,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    if (!dialogContext.mounted) return;
                    context.read<AuthBloc>().add(
                          UpdateUserProfile(
                            iqamaNumber: value,
                          ),
                        );
                  },
                ),
              ),
              SizedBox(height: spacing * 4),
              Text(
                'لوحة المركبة',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.black87,
                      fontSize: fontSize,
                    ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: spacing * 2),
              Center(
                child: SaudiLicensePlate(
                  initialNumbers: userData?['vehiclePlateNumber'] != null
                      ? userData!['vehiclePlateNumber']
                              .toString()
                              .split(' ')
                              .firstOrNull ??
                          ''
                      : '',
                  initialLetters: userData?['vehiclePlateNumber'] != null
                      ? userData!['vehiclePlateNumber']
                                  .toString()
                                  .split(' ')
                                  .length >
                              1
                          ? userData['vehiclePlateNumber']
                              .toString()
                              .split(' ')[1]
                          : ''
                      : '',
                  onChanged: (numbers, letters) {
                    if (!dialogContext.mounted) return;

                    context.read<AuthBloc>().add(
                          UpdateUserProfile(
                            vehiclePlateNumber: '$numbers $letters',
                          ),
                        );
                  },
                ),
              ),
              SizedBox(height: spacing * 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.8),
                      padding: EdgeInsets.symmetric(
                          horizontal: padding * 8, vertical: padding * 3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(spacing * 2)),
                    ),
                    child: Text(
                      'تم',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
