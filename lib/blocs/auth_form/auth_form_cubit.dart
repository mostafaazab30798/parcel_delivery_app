import 'package:flutter_bloc/flutter_bloc.dart';

class AuthFormState {
  final bool isLogin;
  final bool obscurePassword;
  final bool isBusinessOwner;
  final bool isDriver;
  final bool isPhoneVerificationStep;
  final bool isOtpVerificationStep;
  final String? verificationId;
  final String? phoneNumber;

  AuthFormState({
    this.isLogin = true,
    this.obscurePassword = true,
    this.isBusinessOwner = false,
    this.isDriver = false,
    this.isPhoneVerificationStep = false,
    this.isOtpVerificationStep = false,
    this.verificationId,
    this.phoneNumber,
  });

  AuthFormState copyWith({
    bool? isLogin,
    bool? obscurePassword,
    bool? isBusinessOwner,
    bool? isDriver,
    bool? isPhoneVerificationStep,
    bool? isOtpVerificationStep,
    String? verificationId,
    String? phoneNumber,
  }) {
    return AuthFormState(
      isLogin: isLogin ?? this.isLogin,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isBusinessOwner: isBusinessOwner ?? this.isBusinessOwner,
      isDriver: isDriver ?? this.isDriver,
      isPhoneVerificationStep:
          isPhoneVerificationStep ?? this.isPhoneVerificationStep,
      isOtpVerificationStep:
          isOtpVerificationStep ?? this.isOtpVerificationStep,
      verificationId: verificationId ?? this.verificationId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

class AuthFormCubit extends Cubit<AuthFormState> {
  AuthFormCubit() : super(AuthFormState());

  void toggleLogin() {
    emit(state.copyWith(
      isLogin: !state.isLogin,
      isPhoneVerificationStep: false,
      isOtpVerificationStep: false,
      verificationId: null,
      phoneNumber: null,
    ));
  }

  void toggleObscure() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleUserType() {
    emit(state.copyWith(
      isBusinessOwner: !state.isBusinessOwner,
      isDriver: false,
    ));
  }

  void toggleDriverType() {
    emit(state.copyWith(isDriver: !state.isDriver));
  }

  void startPhoneVerification() {
    emit(state.copyWith(isPhoneVerificationStep: true));
  }

  void setVerificationId(String verificationId, String phoneNumber) {
    emit(state.copyWith(
      isPhoneVerificationStep: false,
      isOtpVerificationStep: true,
      verificationId: verificationId,
      phoneNumber: phoneNumber,
    ));
  }

  void reset() {
    emit(AuthFormState());
  }
}
