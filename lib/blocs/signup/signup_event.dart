import 'package:equatable/equatable.dart';
import 'signup_state.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRoleSelectedEvent extends SignUpEvent {
  final SignUpRole role;

  const SignUpRoleSelectedEvent(this.role);

  @override
  List<Object> get props => [role];
}

class SignUpFormSubmitted extends SignUpEvent {
  final SignUpRole role;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  const SignUpFormSubmitted({
    required this.role,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [role, phoneNumber, password, confirmPassword];
}

class SignUpOTPVerificationRequested extends SignUpEvent {
  final String phoneNumber;
  final String otp;
  final SignUpRole role;

  const SignUpOTPVerificationRequested({
    required this.phoneNumber,
    required this.otp,
    required this.role,
  });

  @override
  List<Object> get props => [phoneNumber, otp, role];
}

class SignUpReset extends SignUpEvent {}

class SignUpFormValidated extends SignUpEvent {
  final SignUpRole role;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  const SignUpFormValidated({
    required this.role,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [role, phoneNumber, password, confirmPassword];
}