import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/signup/signup_bloc.dart';
import '../blocs/signup/signup_event.dart';
import '../blocs/signup/signup_state.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _animationController;
  late AnimationController _logoAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;

  SignUpRole? _selectedRole;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => SignUpBloc(authService: AuthService()),
      child: Builder(
        builder: (context) {
          return BlocListener<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state is SignUpRegistrationSent) {
                context.push('/otp-verification', extra: {
                  'phoneNumber': state.phoneNumber,
                  'role': state.role,
                  'otp': state.otp,
                });
              } else if (state is SignUpSuccess) {
                // Navigate based on role
                if (state.authResult.role == UserRole.driver) {
                  context.pushReplacement('/driver-home');
                } else {
                  context.pushReplacement('/user-home');
                }
              }
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFFDF7ED),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Color(0xFF8B572A),
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
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
                            vertical: size.height * 0.02,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: size.height * 0.03),
                              _buildLogoSection(),
                              SizedBox(height: size.height * 0.05),
                              _buildWelcomeText(),
                              const SizedBox(height: 32),
                              _buildSignUpForm(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
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
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF9B652E),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9B652E).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 3,
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF9B652E),
                    const Color(0xFF8B572A),
                  ],
                ),
              ),
              child: const Icon(
                Icons.local_shipping_rounded,
                size: 50,
                color: Color(0xFFFFFAF3),
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
          'إنشاء حساب جديد',
          style: GoogleFonts.cairo(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B572A),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'اختر نوع الحساب واملأ البيانات المطلوبة',
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            fontSize: 15,
            color: const Color(0xFF4A4A4A),
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRoleSelection(state),
              const SizedBox(height: 24),
              _buildPhoneField(state),
              const SizedBox(height: 20),
              _buildPasswordField(state),
              const SizedBox(height: 20),
              _buildConfirmPasswordField(state),
              const SizedBox(height: 24),
              _buildPasswordRequirements(),
              const SizedBox(height: 32),
              _buildSignUpButton(state),
              const SizedBox(height: 24),
              _buildLoginLink(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleSelection(SignUpState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع الحساب',
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8B572A),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRoleCard(
                role: SignUpRole.user,
                title: 'عميل',
                subtitle: 'لطلب خدمات الشحن',
                icon: Icons.person_rounded,
                isSelected: _selectedRole == SignUpRole.user,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRoleCard(
                role: SignUpRole.driver,
                title: 'سائق',
                subtitle: 'لتقديم خدمات النقل',
                icon: Icons.local_shipping_rounded,
                isSelected: _selectedRole == SignUpRole.driver,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required SignUpRole role,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9B652E).withOpacity(0.1) : const Color(0xFFFFFAF3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF9B652E) : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF9B652E).withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF9B652E) : const Color(0xFF8B572A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: isSelected ? Colors.white : const Color(0xFF8B572A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF9B652E) : const Color(0xFF8B572A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: const Color(0xFF4A4A4A),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField(SignUpState state) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        textDirection: TextDirection.ltr,
        style: GoogleFonts.cairo(
          fontSize: 16,
          color: const Color(0xFF222831),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: 'رقم الجوال',
          labelStyle: GoogleFonts.cairo(
            color: const Color(0xFF8B572A),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintText: '05XXXXXXXX',
          hintTextDirection: TextDirection.ltr,
          hintStyle: GoogleFonts.cairo(
            color: const Color(0xFF4A4A4A).withOpacity(0.6),
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF9B652E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.phone_android_rounded,
              color: const Color(0xFF9B652E),
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFFFFAF3),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFF9B652E),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
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
    );
  }

  Widget _buildPasswordField(SignUpState state) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: GoogleFonts.cairo(
          fontSize: 16,
          color: const Color(0xFF222831),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: 'كلمة المرور',
          labelStyle: GoogleFonts.cairo(
            color: const Color(0xFF8B572A),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintText: 'أدخل كلمة مرور قوية',
          hintStyle: GoogleFonts.cairo(
            color: const Color(0xFF4A4A4A).withOpacity(0.6),
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF9B652E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.lock_rounded,
              color: const Color(0xFF9B652E),
              size: 20,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: const Color(0xFF8B572A),
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
              HapticFeedback.lightImpact();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFFFFAF3),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFF9B652E),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
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
          return null;
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField(SignUpState state) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: _obscureConfirmPassword,
        style: GoogleFonts.cairo(
          fontSize: 16,
          color: const Color(0xFF222831),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: 'تأكيد كلمة المرور',
          labelStyle: GoogleFonts.cairo(
            color: const Color(0xFF8B572A),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintText: 'أعد إدخال كلمة المرور',
          hintStyle: GoogleFonts.cairo(
            color: const Color(0xFF4A4A4A).withOpacity(0.6),
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF9B652E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              color: const Color(0xFF9B652E),
              size: 20,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: const Color(0xFF8B572A),
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
              HapticFeedback.lightImpact();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFFFFAF3),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFF9B652E),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى تأكيد كلمة المرور';
          }
          if (value != _passwordController.text) {
            return 'كلمة المرور غير متطابقة';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F3C88).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1F3C88).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: const Color(0xFF1F3C88),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'متطلبات كلمة المرور',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F3C88),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• 8 أحرف على الأقل\n• حرف كبير واحد على الأقل (A-Z)\n• حرف صغير واحد على الأقل (a-z)\n• رقم واحد على الأقل (0-9)\n• رمز خاص واحد على الأقل (!@#\$%^&*)',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: const Color(0xFF1F3C88),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(SignUpState state) {
    final isLoading = state is SignUpLoading;
    final isFormError = state is SignUpFormError;

    return Column(
      children: [
        if (isFormError) ...[
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.red[700], size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.message,
                    style: GoogleFonts.cairo(
                      color: Colors.red[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (state is SignUpFailure) ...[
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.red[700], size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.message,
                    style: GoogleFonts.cairo(
                      color: Colors.red[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF9B652E),
                const Color(0xFF8B572A),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9B652E).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: isLoading ? null : () => _handleSignUp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFFFFFAF3),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'إنشاء الحساب',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFFFAF3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: const Color(0xFFFFFAF3),
                            size: 20,
                          ),
                        ],
                      ),
              );
            }
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لديك حساب بالفعل؟ ',
          style: GoogleFonts.cairo(
            color: const Color(0xFF4A4A4A),
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () => context.pop(),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF9B652E),
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'تسجيل الدخول',
            style: GoogleFonts.cairo(
              color: const Color(0xFF9B652E),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: const Color(0xFF9B652E),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSignUp(BuildContext context) {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يرجى اختيار نوع الحساب',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      context.read<SignUpBloc>().add(SignUpFormSubmitted(
            role: _selectedRole!,
            phoneNumber: _phoneController.text.trim(),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          ));
    }
  }
}