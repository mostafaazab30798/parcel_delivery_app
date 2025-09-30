import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';
import '../../services/auth_service.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthService _authService;

  SignUpBloc({required AuthService authService})
      : _authService = authService,
        super(SignUpInitial()) {
    on<SignUpRoleSelectedEvent>(_onRoleSelected);
    on<SignUpFormValidated>(_onFormValidated);
    on<SignUpFormSubmitted>(_onFormSubmitted);
    on<SignUpOTPVerificationRequested>(_onOTPVerificationRequested);
    on<SignUpReset>(_onReset);
  }

  void _onRoleSelected(SignUpRoleSelectedEvent event, Emitter<SignUpState> emit) {
    emit(SignUpRoleSelected(event.role));
  }

  void _onFormValidated(SignUpFormValidated event, Emitter<SignUpState> emit) {
    final validationError = _validateForm(
      phoneNumber: event.phoneNumber,
      password: event.password,
      confirmPassword: event.confirmPassword,
    );

    if (validationError != null) {
      emit(SignUpFormError(validationError));
    } else {
      emit(SignUpFormValid(
        role: event.role,
        phoneNumber: event.phoneNumber,
        password: event.password,
        confirmPassword: event.confirmPassword,
      ));
    }
  }

  Future<void> _onFormSubmitted(SignUpFormSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());

    try {
      // Validate form first
      final validationError = _validateForm(
        phoneNumber: event.phoneNumber,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );

      if (validationError != null) {
        emit(SignUpFormError(validationError));
        return;
      }

      // Register with auth service, passing the role
      final roleString = event.role == SignUpRole.driver ? 'driver' : 'user';
      final otp = await _authService.register(event.phoneNumber, event.password, role: roleString);

      emit(SignUpRegistrationSent(
        phoneNumber: event.phoneNumber,
        otp: otp,
        role: event.role,
      ));
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }

  Future<void> _onOTPVerificationRequested(
      SignUpOTPVerificationRequested event, Emitter<SignUpState> emit) async {
    // Emit verifying state regardless of current state
    emit(SignUpOTPVerifying(
      phoneNumber: event.phoneNumber,
      role: event.role, // Use the role passed from the event
    ));

    try {
      final authResult = await _authService.verifyOTP(event.phoneNumber, event.otp);
      emit(SignUpSuccess(authResult));
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }

  void _onReset(SignUpReset event, Emitter<SignUpState> emit) {
    emit(SignUpInitial());
  }

  String? _validateForm({
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) {
    // Phone validation
    if (phoneNumber.isEmpty) {
      return 'يرجى إدخال رقم الجوال';
    }
    if (!phoneNumber.startsWith('05') || phoneNumber.length != 10) {
      return 'يرجى إدخال رقم جوال سعودي صحيح (يبدأ بـ 05 ويتكون من 10 أرقام)';
    }

    // Password validation
    if (password.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (password.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    if (!_hasUpperCase(password)) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل';
    }
    if (!_hasLowerCase(password)) {
      return 'كلمة المرور يجب أن تحتوي على حرف صغير واحد على الأقل';
    }
    if (!_hasDigit(password)) {
      return 'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';
    }
    if (!_hasSpecialCharacter(password)) {
      return 'كلمة المرور يجب أن تحتوي على رمز خاص واحد على الأقل (!@#\$%^&*)';
    }

    // Confirm password validation
    if (confirmPassword.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }
    if (password != confirmPassword) {
      return 'كلمة المرور وتأكيد كلمة المرور غير متطابقتان';
    }

    return null;
  }

  bool _hasUpperCase(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }

  bool _hasLowerCase(String password) {
    return password.contains(RegExp(r'[a-z]'));
  }

  bool _hasDigit(String password) {
    return password.contains(RegExp(r'[0-9]'));
  }

  bool _hasSpecialCharacter(String password) {
    return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }
}