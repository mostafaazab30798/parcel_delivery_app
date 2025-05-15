abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final Map<String, dynamic>? userData;

  AuthSuccess({this.userData});
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthLoggedOut extends AuthState {}

class AuthPasswordResetSent extends AuthState {
  final String email;

  AuthPasswordResetSent(this.email);
}

class AuthVerificationEmailSent extends AuthState {
  final String email;

  AuthVerificationEmailSent(this.email);
}

class UserDataLoaded extends AuthState {
  final Map<String, dynamic>? userData;
  final bool isProfilePictureUpdate;

  UserDataLoaded(this.userData, {this.isProfilePictureUpdate = false});

  List<Object?> get props => [userData, isProfilePictureUpdate];
}

class PhoneVerificationSent extends AuthState {
  final String verificationId;
  final String phoneNumber;

  PhoneVerificationSent({
    required this.verificationId,
    required this.phoneNumber,
  });
}

class PhoneVerificationCompleted extends AuthState {
  final String phoneNumber;

  PhoneVerificationCompleted({required this.phoneNumber});
}

class PhoneVerificationFailed extends AuthState {
  final String message;

  PhoneVerificationFailed(this.message);
}

class UserTypeUpdated extends AuthState {
  final bool isBusinessOwner;

  UserTypeUpdated({required this.isBusinessOwner});
}
