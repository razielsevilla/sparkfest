import 'dart:async';

abstract class AuthService {
  // Stream to track current authenticated user (e.g. phone number or mock user ID)
  Stream<String?> get onAuthStateChanged;

  String? get currentUserId;

  // Sends phone verification OTP
  Future<void> sendOtp(String phoneNumber);

  // Verifies OTP and signs in
  Future<String> verifyOtp(String verificationId, String smsCode);

  // Sign out
  Future<void> signOut();
}
