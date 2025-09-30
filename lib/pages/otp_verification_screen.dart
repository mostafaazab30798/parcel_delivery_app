import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../blocs/signup/signup_bloc.dart';
import '../blocs/signup/signup_event.dart';
import '../blocs/signup/signup_state.dart';
import '../services/auth_service.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final SignUpRole role;
  final String otp;

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.role,
    required this.otp,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  late AnimationController _animationController;
  late AnimationController _logoAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _logoScaleAnimation;

  Timer? _timer;
  int _countdown = 300; // 5 minutes
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startCountdown();
    
    // Show the OTP in debug mode
    if (widget.otp.isNotEmpty) {
      _showDebugOTP();
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoAnimationController.forward();
    _animationController.forward();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _isResendEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  void _showDebugOTP() {
    // Auto-fill OTP for testing purposes
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && widget.otp.length >= 6) {
        for (int i = 0; i < 6 && i < widget.otp.length; i++) {
          _controllers[i].text = widget.otp[i];
        }
        setState(() {});
        
        // Show debug message after widget is built
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'رمز التحقق للاختبار: ${widget.otp}',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: const Color(0xFF1F3C88),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _animationController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => SignUpBloc(authService: AuthService()),
      child: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
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
                        vertical: size.height * 0.03,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.05),
                          _buildLogoSection(),
                          SizedBox(height: size.height * 0.06),
                          _buildHeaderText(),
                          const SizedBox(height: 40),
                          _buildOTPInput(),
                          const SizedBox(height: 32),
                          _buildVerifyButton(),
                          const SizedBox(height: 24),
                          _buildResendSection(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
              Icons.sms_rounded,
              size: 50,
              color: Color(0xFFFFFAF3),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderText() {
    return Column(
      children: [
        Text(
          'تأكيد رقم الجوال',
          style: GoogleFonts.cairo(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B572A),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.cairo(
              fontSize: 15,
              color: const Color(0xFF4A4A4A),
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'تم إرسال رمز التحقق إلى\n'),
              TextSpan(
                text: widget.phoneNumber,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF9B652E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOTPInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) => _buildOTPDigit(index)),
        ),
        const SizedBox(height: 20),
        Text(
          'أدخل الرمز المكون من 6 أرقام',
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: const Color(0xFF4A4A4A),
          ),
        ),
      ],
    );
  }

  Widget _buildOTPDigit(int index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: GoogleFonts.cairo(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF222831),
        ),
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFFFFAF3),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: _controllers[index].text.isNotEmpty 
                  ? const Color(0xFF9B652E)
                  : const Color(0xFFE0E0E0),
              width: _controllers[index].text.isNotEmpty ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFF9B652E),
              width: 2,
            ),
          ),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          
          // Auto-verify if all digits are entered
          if (value.length == 1 && index == 5) {
            final otp = _controllers.map((controller) => controller.text).join();
            if (otp.length == 6) {
              context.read<SignUpBloc>().add(SignUpOTPVerificationRequested(
                    phoneNumber: widget.phoneNumber,
                    otp: otp,
                    role: widget.role,
                  ));
            }
          }
          
          setState(() {});
        },
      ),
    );
  }

  Widget _buildVerifyButton() {
    final isComplete = _controllers.every((controller) => controller.text.isNotEmpty);
    
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        final isLoading = state is SignUpOTPVerifying;
        
        return Column(
          children: [
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
                gradient: isComplete && !isLoading
                    ? LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color(0xFF9B652E),
                          const Color(0xFF8B572A),
                        ],
                      )
                    : null,
                color: !isComplete || isLoading ? const Color(0xFFE0E0E0) : null,
                boxShadow: isComplete && !isLoading
                    ? [
                        BoxShadow(
                          color: const Color(0xFF9B652E).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Builder(
                builder: (buttonContext) {
                  return ElevatedButton(
                    onPressed: isComplete && !isLoading ? () => _handleVerify(buttonContext) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      disabledBackgroundColor: Colors.transparent,
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
                                'تأكيد الرمز',
                                style: GoogleFonts.cairo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isComplete 
                                      ? const Color(0xFFFFFAF3) 
                                      : const Color(0xFF8B572A),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.check_rounded,
                                color: isComplete 
                                    ? const Color(0xFFFFFAF3) 
                                    : const Color(0xFF8B572A),
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
      },
    );
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        if (_countdown > 0) ...[
          Text(
            'إعادة إرسال الرمز خلال ${_formatTime(_countdown)}',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: const Color(0xFF4A4A4A),
            ),
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'لم تستلم الرمز؟ ',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: const Color(0xFF4A4A4A),
                ),
              ),
              TextButton(
                onPressed: _isResendEnabled ? _handleResend : null,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF9B652E),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'إعادة الإرسال',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _isResendEnabled 
                        ? const Color(0xFF9B652E) 
                        : const Color(0xFF8B572A).withOpacity(0.5),
                    decoration: TextDecoration.underline,
                    decorationColor: _isResendEnabled 
                        ? const Color(0xFF9B652E) 
                        : const Color(0xFF8B572A).withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _handleVerify(BuildContext context) {
    final otp = _controllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      context.read<SignUpBloc>().add(SignUpOTPVerificationRequested(
            phoneNumber: widget.phoneNumber,
            otp: otp,
            role: widget.role,
          ));
    }
  }

  void _handleResend() {
    // Reset countdown and clear OTP fields
    setState(() {
      _countdown = 300;
      _isResendEnabled = false;
      for (var controller in _controllers) {
        controller.clear();
      }
    });
    _startCountdown();
    _focusNodes[0].requestFocus();
    
    // Show snackbar only if widget is mounted
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إعادة إرسال رمز التحقق',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: const Color(0xFF9B652E),
        ),
      );
    }
  }
}