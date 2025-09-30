import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider_test/blocs/driver/bloc/driver_bloc.dart';
import 'package:provider_test/services/auth_service.dart';
import 'package:provider_test/utils/clear_cache.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  
  late AnimationController _animationController;
  late AnimationController _logoAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkExistingLogin();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));
    
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));
    
    _logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    ));
    
    _logoAnimationController.forward();
    _animationController.forward();
  }

  Future<void> _checkExistingLogin() async {
    try {
      // Clear ALL cached data to ensure clean state
      // This prevents issues with wrong user data being displayed
      await CacheCleanupUtility.clearAllCachedData();
      await _authService.logout();
      debugPrint('🔑 Cleared all cached data on login screen');
    } catch (e) {
      debugPrint('❌ Error clearing session: $e');
      // Continue even if logout fails
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Debug: Print what we're about to send
      debugPrint('🔐 Login attempt:');
      debugPrint('  Phone: ${_phoneController.text.trim()}');
      debugPrint('  Password: ${_passwordController.text.trim().replaceAll(RegExp(r'.'), '*')}');
      
      // Debug: Check what's in storage before login
      await CacheCleanupUtility.debugPrintAllPreferences();
      
      final authResult = await _authService.login(
        _phoneController.text.trim(),
        _passwordController.text.trim(),
      );
      
      // Debug: Print login result
      debugPrint('📊 Login Result:');
      debugPrint('  Role: ${authResult.role}');
      debugPrint('  User Data: ${authResult.userData}');
      debugPrint('  Token: ${authResult.token.substring(0, 20)}...');
      
      // Stop loading state before navigation to prevent widget conflicts
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      
      // Add small delay to ensure state update completes before navigation
      await Future.delayed(const Duration(milliseconds: 50));
      
      if (mounted) {
        if (authResult.role == UserRole.driver) {
          debugPrint('🚗 Navigating to DRIVER HOME');
          // Navigate to driver home (DriverHomeScreen will handle BLoC initialization)
          context.pushReplacement('/driver-home');
        } else {
          debugPrint('👤 Navigating to USER HOME');
          // Navigate to user home
          context.pushReplacement('/user-home');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
        HapticFeedback.heavyImpact();
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7ED), // App's scaffold background
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.08,
                    vertical: size.height * 0.05,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.08),
                      
                      // Animated Logo Section
                      _buildLogoSection(),
                      
                      SizedBox(height: size.height * 0.08),
                      
                      // Welcome Text
                      _buildWelcomeText(),
                      
                      const SizedBox(height: 48),
                      
                      // Login Form
                      _buildLoginForm(),
                      
                      const SizedBox(height: 32),
                      
                      // Login Button
                      _buildLoginButton(),
                      
                      const SizedBox(height: 24),
                      
                      // Additional Options
                      _buildAdditionalOptions(),
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

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Transform.rotate(
            angle: _logoRotationAnimation.value * 0.1,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF9B652E), // App's primary color
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9B652E).withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                    spreadRadius: 5,
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF9B652E),
                    const Color(0xFF8B572A), // App's body medium color
                  ],
                ),
              ),
              child: const Icon(
                Icons.local_shipping_rounded,
                size: 60,
                color: Color(0xFFFFFAF3), // App's card color (off-white)
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'مرحباً بك',
          style: GoogleFonts.cairo(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B572A), // App's body medium color
            letterSpacing: 1.0,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Text(
          'أدخل رقم جوالك للدخول إلى حسابك',
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            fontSize: 16,
            color: const Color(0xFF4A4A4A), // App's body small color
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Phone Input Field
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              style: GoogleFonts.cairo(
                fontSize: 18,
                color: const Color(0xFF222831), // App's display color
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: 'رقم الجوال',
                labelStyle: GoogleFonts.cairo(
                  color: const Color(0xFF8B572A), // App's body medium color
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                hintText: '05XXXXXXXX',
                hintTextDirection: TextDirection.ltr,
                hintStyle: GoogleFonts.cairo(
                  color: const Color(0xFF4A4A4A).withOpacity(0.6),
                  fontSize: 16,
                ),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(14),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B652E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.phone_android_rounded,
                    color: const Color(0xFF9B652E), // App's primary color
                    size: 22,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFFFFAF3), // App's card color
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: const Color(0xFFE0E0E0), // App's divider color
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: const Color(0xFF9B652E), // App's primary color
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال رقم الجوال';
                }
                if (!value.startsWith('05') || value.length != 10) {
                  return 'يرجى إدخال رقم جوال سعودي صحيح';
                }
                return null;
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Password Input Field
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              style: GoogleFonts.cairo(
                fontSize: 18,
                color: const Color(0xFF222831),
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                labelStyle: GoogleFonts.cairo(
                  color: const Color(0xFF8B572A),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                hintText: '••••••••',
                hintStyle: GoogleFonts.cairo(
                  color: const Color(0xFF4A4A4A).withOpacity(0.6),
                  fontSize: 16,
                ),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(14),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B652E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    color: const Color(0xFF9B652E),
                    size: 22,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFFFFAF3),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: const Color(0xFF9B652E),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال كلمة المرور';
                }
                if (value.length < 6) {
                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                }
                return null;
              },
            ),
          ),
          
          // Error Message
          if (_errorMessage != null) ...[
            const SizedBox(height: 20),
            _buildErrorMessage(),
          ],
          
          // Remember Me
          const SizedBox(height: 20),
          _buildRememberMe(),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.red[700], size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: GoogleFonts.cairo(
                color: Colors.red[700],
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRememberMe() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _rememberMe = !_rememberMe;
        });
        HapticFeedback.lightImpact();
      },
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: _rememberMe ? const Color(0xFF9B652E) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _rememberMe 
                    ? const Color(0xFF9B652E) 
                    : const Color(0xFFE0E0E0),
                width: 2,
              ),
            ),
            child: _rememberMe
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            'تذكرني',
            style: GoogleFonts.cairo(
              color: const Color(0xFF4A4A4A), // App's body small color
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFF9B652E), // App's primary color
            const Color(0xFF8B572A), // App's body medium color
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9B652E).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFFFFFAF3), // App's card color
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'دخول',
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFFAF3), // App's card color
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: const Color(0xFFFFFAF3), // App's card color
                    size: 24,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        // Test credentials info
        // Container(
        //   padding: const EdgeInsets.all(20),
        //   decoration: BoxDecoration(
        //     color: const Color(0xFF1F3C88).withOpacity(0.05), // App's highlight color with opacity
        //     borderRadius: BorderRadius.circular(16),
        //     border: Border.all(
        //       color: const Color(0xFF1F3C88).withOpacity(0.2),
        //       width: 1,
        //     ),
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Row(
        //         children: [
        //           Icon(
        //             Icons.info_outline_rounded,
        //             color: const Color(0xFF1F3C88), // App's highlight color
        //             size: 22,
        //           ),
        //           const SizedBox(width: 10),
        //           Text(
        //             'بيانات تجريبية',
        //             style: GoogleFonts.cairo(
        //               fontWeight: FontWeight.bold,
        //               color: const Color(0xFF1F3C88), // App's highlight color
        //               fontSize: 16,
        //             ),
        //           ),
        //         ],
        //       ),
        //       const SizedBox(height: 12),
        //       Text(
        //         '• استخدم بيانات الحساب الذي سجلته\n• نوع الحساب (سائق/عميل) يحدد حسب التسجيل\n• كلمة المرور الافتراضية للاختبار: 123456',
        //         style: GoogleFonts.cairo(
        //           fontSize: 14,
        //           color: const Color(0xFF1F3C88), // App's highlight color
        //           height: 1.5,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        
        const SizedBox(height: 24),
        
        // Sign up link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'لا تملك حساباً؟ ',
              style: GoogleFonts.cairo(
                color: const Color(0xFF4A4A4A),
                fontSize: 15,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push('/signup');
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF9B652E),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'إنشاء حساب جديد',
                style: GoogleFonts.cairo(
                  color: const Color(0xFF9B652E),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color(0xFF9B652E),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}