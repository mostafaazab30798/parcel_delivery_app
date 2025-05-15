abstract class AuthEvent {}

class LoginWithEmailPassword extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailPassword({
    required this.email,
    required this.password,
  });
}

class SignUpWithEmailPassword extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String vehicleType;
  final String vehiclePlateNumber;
  final String? iqamaNumber;

  SignUpWithEmailPassword({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.vehicleType,
    required this.vehiclePlateNumber,
    this.iqamaNumber,
  });
}

class LoginWithGoogle extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class VerifyEmail extends AuthEvent {}

class ForgotPassword extends AuthEvent {
  final String email;

  ForgotPassword(String text, {required this.email});
}

class UpdateUserProfile extends AuthEvent {
  final String? name;
  final String? phone;
  final String? vehicleType;
  final String? vehiclePlateNumber;
  final String? iqamaNumber;

  UpdateUserProfile({
    this.name,
    this.phone,
    this.vehicleType,
    this.vehiclePlateNumber,
    this.iqamaNumber,
  });
}

class UpdateUserStatus extends AuthEvent {
  final String status;

  UpdateUserStatus(this.status); // ✅ Positional parameter
}

class ChangePassword extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });
}

class LoadUserData extends AuthEvent {
  final Map<String, dynamic>? userData;

  LoadUserData(this.userData);
}

class UpdateProfilePicture extends AuthEvent {
  final String imagePath;

  UpdateProfilePicture(this.imagePath);
}

class SendPhoneVerification extends AuthEvent {
  final String phoneNumber;

  SendPhoneVerification(String text, {required this.phoneNumber});
}

class VerifyPhoneOTP extends AuthEvent {
  final String verificationId;
  final String otp;

  VerifyPhoneOTP({
    required this.verificationId,
    required this.otp,
  });
}

class UpdateUserType extends AuthEvent {
  final bool isBusinessOwner;

  UpdateUserType({required this.isBusinessOwner});
}

class SignUpWithPhone extends AuthEvent {
  final String name;
  final String phone;
  final bool isBusinessOwner;
  final String? businessName;
  final String? businessType;
  final String? commercialRegistrationNumber;
  final String? vehicleType;
  final String? vehiclePlateNumber;

  SignUpWithPhone({
    required this.name,
    required this.phone,
    required this.isBusinessOwner,
    this.businessName,
    this.businessType,
    this.commercialRegistrationNumber,
    this.vehicleType,
    this.vehiclePlateNumber,
  });
}
