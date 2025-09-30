import 'package:equatable/equatable.dart';
import '../../services/auth_service.dart';

enum SignUpRole { user, driver }

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpRoleSelected extends SignUpState {
  final SignUpRole role;

  const SignUpRoleSelected(this.role);

  @override
  List<Object> get props => [role];
}

class SignUpFormValid extends SignUpState {
  final SignUpRole role;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  const SignUpFormValid({
    required this.role,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [role, phoneNumber, password, confirmPassword];
}

class SignUpRegistrationSent extends SignUpState {
  final String phoneNumber;
  final String otp;
  final SignUpRole role;

  const SignUpRegistrationSent({
    required this.phoneNumber,
    required this.otp,
    required this.role,
  });

  @override
  List<Object> get props => [phoneNumber, otp, role];
}

class SignUpOTPVerifying extends SignUpState {
  final String phoneNumber;
  final SignUpRole role;

  const SignUpOTPVerifying({
    required this.phoneNumber,
    required this.role,
  });

  @override
  List<Object> get props => [phoneNumber, role];
}

class SignUpSuccess extends SignUpState {
  final AuthResult authResult;

  const SignUpSuccess(this.authResult);

  @override
  List<Object> get props => [authResult];
}

class SignUpFailure extends SignUpState {
  final String message;

  const SignUpFailure(this.message);

  @override
  List<Object> get props => [message];
}

class SignUpFormError extends SignUpState {
  final String message;

  const SignUpFormError(this.message);

  @override
  List<Object> get props => [message];
}