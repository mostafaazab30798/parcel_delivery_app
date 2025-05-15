import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'event.dart';
import 'state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc() : super(AuthInitial()) {
    on<LoginWithEmailPassword>(_handleLoginWithEmailPassword);
    on<SignUpWithEmailPassword>(_handleSignUpWithEmailPassword);
    on<LoginWithGoogle>(_handleLoginWithGoogle);
    on<LogoutRequested>(_handleLogout);
    on<ForgotPassword>(_handleForgotPassword);
    on<VerifyEmail>(_handleVerifyEmail);
    on<UpdateUserProfile>(_handleUpdateUserProfile);
    on<ChangePassword>(_handleChangePassword);
    on<UpdateUserStatus>(_handleUpdateUserStatus);
    on<LoadUserData>(_handleLoadUserData);
    on<UpdateProfilePicture>(_handleUpdateProfilePicture);
    on<SendPhoneVerification>(_handleSendPhoneVerification);
    on<VerifyPhoneOTP>(_handleVerifyPhoneOTP);
    on<UpdateUserType>(_handleUpdateUserType);
    on<SignUpWithPhone>(_handleSignUpWithPhone);
  }

  Future<void> _handleLoginWithEmailPassword(
    LoginWithEmailPassword event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        final userDoc = await _firestore
            .collection('drivers')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          emit(AuthSuccess(userData: userDoc.data()));
        } else {
          emit(AuthError('User data not found'));
        }
      }
    } on auth.FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'البريد الإلكتروني غير مسجل';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'كلمة المرور غير صحيحة';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'البريد الإلكتروني غير صالح';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'تم تعطيل هذا الحساب';
      } else {
        errorMessage = 'حدث خطأ أثناء تسجيل الدخول';
      }
      emit(AuthError(errorMessage));
    } catch (e) {
      emit(AuthError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> _handleSignUpWithEmailPassword(
    SignUpWithEmailPassword event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        await _firestore
            .collection('drivers')
            .doc(userCredential.user!.uid)
            .set({
          'name': event.name,
          'email': event.email,
          'phone': event.phone,
          'vehicleType': event.vehicleType,
          'vehiclePlateNumber': event.vehiclePlateNumber,
          'iqamaNumber': event.iqamaNumber,
          'status': 'inactive',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        final userDoc = await _firestore
            .collection('drivers')
            .doc(userCredential.user!.uid)
            .get();

        emit(AuthSuccess(userData: userDoc.data()));
      }
    } on auth.FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'كلمة المرور ضعيفة جداً';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'البريد الإلكتروني مستخدم بالفعل';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'البريد الإلكتروني غير صالح';
      } else {
        errorMessage = 'حدث خطأ أثناء إنشاء الحساب';
      }
      emit(AuthError(errorMessage));
    } catch (e) {
      emit(AuthError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> _handleLoginWithGoogle(
    LoginWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthError('تم إلغاء تسجيل الدخول'));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        final userDoc = await _firestore
            .collection('drivers')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          emit(AuthSuccess(userData: userDoc.data()));
        } else {
          await _firestore
              .collection('drivers')
              .doc(userCredential.user!.uid)
              .set({
            'name': userCredential.user!.displayName,
            'email': userCredential.user!.email,
            'status': 'inactive',
            'createdAt': FieldValue.serverTimestamp(),
          });

          final newUserDoc = await _firestore
              .collection('drivers')
              .doc(userCredential.user!.uid)
              .get();

          emit(AuthSuccess(userData: newUserDoc.data()));
        }
      }
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء تسجيل الدخول باستخدام جوجل'));
    }
  }

  Future<void> _handleLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      await _auth.signOut();
      await _googleSignIn.signOut();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء تسجيل الخروج'));
    }
  }

  Future<void> _handleForgotPassword(
    ForgotPassword event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      await _auth.sendPasswordResetEmail(email: event.email);
      emit(AuthPasswordResetSent(event.email));
    } on auth.FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'البريد الإلكتروني غير مسجل';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'البريد الإلكتروني غير صالح';
      } else {
        errorMessage = 'حدث خطأ أثناء إرسال رابط إعادة تعيين كلمة المرور';
      }
      emit(AuthError(errorMessage));
    } catch (e) {
      emit(AuthError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> _handleVerifyEmail(
    VerifyEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        emit(AuthVerificationEmailSent(user.email!));
      } else {
        emit(AuthError('No user found or email already verified'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _handleUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final user = _auth.currentUser;
      if (user != null) {
        // First get the current user data
        final currentDoc =
            await _firestore.collection('drivers').doc(user.uid).get();
        if (!currentDoc.exists) {
          emit(AuthError('لم يتم العثور على بيانات المستخدم'));
          return;
        }

        // Get current user data
        final currentData = currentDoc.data() ?? {};

        // Create update map with only the fields that are provided
        final Map<String, dynamic> updateData = {
          ...currentData,
          if (event.name != null) 'name': event.name,
          if (event.phone != null) 'phone': event.phone,
          if (event.vehicleType != null) 'vehicleType': event.vehicleType,
          if (event.vehiclePlateNumber != null)
            'vehiclePlateNumber': event.vehiclePlateNumber,
          if (event.iqamaNumber != null) 'iqamaNumber': event.iqamaNumber,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        // Update the document with merged data
        await _firestore.collection('drivers').doc(user.uid).update(updateData);

        // Get the updated user data
        final updatedDoc =
            await _firestore.collection('drivers').doc(user.uid).get();

        if (updatedDoc.exists) {
          emit(UserDataLoaded(updatedDoc.data()));
        } else {
          emit(AuthError('لم يتم العثور على بيانات المستخدم'));
        }
      }
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء تحديث الملف الشخصي'));
    }
  }

  Future<void> _handleChangePassword(
    ChangePassword event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final user = _auth.currentUser;
      if (user != null) {
        final credential = auth.EmailAuthProvider.credential(
          email: user.email!,
          password: event.currentPassword,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(event.newPassword);

        final userDoc =
            await _firestore.collection('drivers').doc(user.uid).get();

        emit(AuthSuccess(userData: userDoc.data()));
      }
    } on auth.FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'wrong-password') {
        errorMessage = 'كلمة المرور الحالية غير صحيحة';
      } else if (e.code == 'weak-password') {
        errorMessage = 'كلمة المرور الجديدة ضعيفة جداً';
      } else {
        errorMessage = 'حدث خطأ أثناء تغيير كلمة المرور';
      }
      emit(AuthError(errorMessage));
    } catch (e) {
      emit(AuthError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> _handleUpdateUserStatus(
    UpdateUserStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('drivers')
            .doc(user.uid)
            .update({'status': event.status});

        final updatedDoc =
            await _firestore.collection('drivers').doc(user.uid).get();

        emit(AuthSuccess(userData: updatedDoc.data()));
      }
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء تحديث حالة الحساب'));
    }
  }

  Future<void> _handleLoadUserData(
    LoadUserData event,
    Emitter<AuthState> emit,
  ) async {
    emit(UserDataLoaded(event.userData));
  }

  Future<void> _handleUpdateProfilePicture(
    UpdateProfilePicture event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final user = _auth.currentUser;
      if (user == null) {
        emit(AuthError('يجب تسجيل الدخول أولاً'));
        return;
      }

      // First get the current user data
      final currentDoc =
          await _firestore.collection('drivers').doc(user.uid).get();
      if (!currentDoc.exists) {
        emit(AuthError('لم يتم العثور على بيانات المستخدم'));
        return;
      }

      // Get current user data
      final currentData = currentDoc.data() ?? {};

      // Update only the profile picture while preserving all other data
      await _firestore.collection('drivers').doc(user.uid).update({
        ...currentData,
        'profilePicture': event.imagePath,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Get the updated user data
      final updatedDoc =
          await _firestore.collection('drivers').doc(user.uid).get();

      if (updatedDoc.exists) {
        emit(UserDataLoaded(updatedDoc.data(), isProfilePictureUpdate: true));
      } else {
        emit(AuthError('لم يتم العثور على بيانات المستخدم'));
      }
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء تحديث صورة الملف الشخصي'));
    }
  }

  Future<void> _handleSendPhoneVerification(
    SendPhoneVerification event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      // Simulate a delay for verification
      await Future.delayed(const Duration(seconds: 2));

      // Hardcoded verification ID and phone number
      emit(PhoneVerificationSent(
        verificationId: '123456', // Hardcoded verification ID
        phoneNumber: event.phoneNumber,
      ));
    } catch (e) {
      emit(AuthError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> _handleVerifyPhoneOTP(
    VerifyPhoneOTP event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      // Simulate a delay for verification
      await Future.delayed(const Duration(seconds: 2));

      // Hardcoded OTP verification
      if (event.otp == '123456') {
        // For demo purposes, create a mock user data
        final mockUserData = {
          'name': 'Demo User',
          'phone': event.verificationId,
          'isBusinessOwner': false,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };

        // Automatically log in after verification
        emit(AuthSuccess(userData: mockUserData));
      } else {
        emit(AuthError('رمز التحقق غير صحيح'));
      }
    } catch (e) {
      emit(AuthError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> _handleUpdateUserType(
    UpdateUserType event,
    Emitter<AuthState> emit,
  ) async {
    emit(UserTypeUpdated(isBusinessOwner: event.isBusinessOwner));
  }

  Future<void> _handleSignUpWithPhone(
    SignUpWithPhone event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final user = _auth.currentUser;
      if (user != null) {
        final collection = event.isBusinessOwner ? 'businesses' : 'users';
        final userData = {
          'name': event.name,
          'phone': event.phone,
          'isBusinessOwner': event.isBusinessOwner,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          if (event.isBusinessOwner) ...{
            'businessName': event.businessName,
            'businessType': event.businessType,
            'commercialRegistrationNumber': event.commercialRegistrationNumber,
            'vehicleType': event.vehicleType,
            'vehiclePlateNumber': event.vehiclePlateNumber,
          }
        };

        await _firestore.collection(collection).doc(user.uid).set(userData);

        final userDoc =
            await _firestore.collection(collection).doc(user.uid).get();

        emit(AuthSuccess(userData: userDoc.data()));
      }
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء إنشاء الحساب'));
    }
  }
}
