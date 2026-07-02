import 'dart:async';

abstract class AuthService {
  // Stream to track current authenticated user (returns phone number or mock user ID)
  Stream<String?> get onAuthStateChanged;

  String? get currentUserId;

  // Sends phone verification OTP with callbacks for flow control
  Future<void> sendOtp(
    String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  });

  // Verifies OTP and signs in
  Future<String> verifyOtp(String verificationId, String smsCode);

  // Sign out
  Future<void> signOut();
}
