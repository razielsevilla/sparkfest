import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gabaysr/core/services/auth_service.dart';
import 'package:gabaysr/core/services/database_service.dart';
import 'package:gabaysr/models/senior_profile.dart';
import 'package:gabaysr/models/trusted_circle_member.dart';
import 'package:gabaysr/models/checkin.dart';
import 'package:gabaysr/models/scam_check.dart';
import 'package:gabaysr/models/alert.dart';

class FirebaseService implements AuthService, DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==========================================
  // AUTH SERVICE IMPLEMENTATION
  // ==========================================

  @override
  Stream<String?> get onAuthStateChanged =>
      _auth.authStateChanges().map((user) => user?.phoneNumber ?? user?.uid);

  @override
  String? get currentUserId => _auth.currentUser?.phoneNumber ?? _auth.currentUser?.uid;

  @override
  Future<void> sendOtp(
    String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      // In web development mode, verification completes differently.
      // We will handle it natively or fall back gracefully.
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolution or instant verification on some Android devices
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? "Authentication failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  @override
  Future<String> verifyOtp(String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    UserCredential userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user?.phoneNumber ?? userCredential.user?.uid ?? "";
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ==========================================
  // DATABASE SERVICE IMPLEMENTATION
  // ==========================================

  @override
  Future<void> createSeniorProfile(SeniorProfile profile) async {
    await _firestore
        .collection('seniorProfiles')
        .doc(profile.id)
        .set(profile.toMap());
  }

  @override
  Future<SeniorProfile?> getSeniorProfile(String profileId) async {
    final doc = await _firestore.collection('seniorProfiles').doc(profileId).get();
    if (doc.exists && doc.data() != null) {
      return SeniorProfile.fromMap(doc.data()!);
    }
    return null;
  }

  @override
  Stream<List<SeniorProfile>> streamSeniorsForMember(String memberPhone) {
    // Queries all members associated with this memberPhone, then retrieves matching senior profiles
    return _firestore
        .collection('trustedCircleMembers')
        .where('phoneNumber', isEqualTo: memberPhone)
        .snapshots()
        .asyncMap((memberSnap) async {
          List<String> seniorIds = memberSnap.docs
              .map((d) => d.data()['seniorProfileId'] as String)
              .toList();

          if (seniorIds.isEmpty) return [];

          // Firestore query in chunk of 10 ids
          List<SeniorProfile> profiles = [];
          for (var i = 0; i < seniorIds.length; i += 10) {
            var end = (i + 10 < seniorIds.length) ? i + 10 : seniorIds.length;
            var subList = seniorIds.sublist(i, end);
            var profileSnap = await _firestore
                .collection('seniorProfiles')
                .where('id', whereIn: subList)
                .get();
            profiles.addAll(
              profileSnap.docs.map((d) => SeniorProfile.fromMap(d.data())).toList(),
            );
          }
          return profiles;
        });
  }

  @override
  Future<void> updateLastCheckIn(String profileId, DateTime checkInDate) async {
    await _firestore.collection('seniorProfiles').doc(profileId).update({
      'lastCheckInDate': checkInDate.toIso8601String(),
    });
  }

  @override
  Future<void> addTrustedCircleMember(TrustedCircleMember member) async {
    await _firestore
        .collection('trustedCircleMembers')
        .doc(member.id)
        .set(member.toMap());
  }

  @override
  Future<List<TrustedCircleMember>> getTrustedCircle(String profileId) async {
    final snap = await _firestore
        .collection('trustedCircleMembers')
        .where('seniorProfileId', isEqualTo: profileId)
        .get();
    return snap.docs.map((d) => TrustedCircleMember.fromMap(d.data())).toList();
  }

  @override
  Stream<List<TrustedCircleMember>> streamTrustedCircle(String profileId) {
    return _firestore
        .collection('trustedCircleMembers')
        .where('seniorProfileId', isEqualTo: profileId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => TrustedCircleMember.fromMap(d.data())).toList());
  }

  @override
  Future<void> logCheckIn(CheckIn checkIn) async {
    await _firestore
        .collection('checkIns')
        .doc(checkIn.id)
        .set(checkIn.toMap());
    
    // Update the senior profile's last check-in date
    await updateLastCheckIn(checkIn.seniorProfileId, checkIn.createdAt);
  }

  @override
  Future<List<CheckIn>> getCheckIns(String profileId, {int limit = 7}) async {
    final snap = await _firestore
        .collection('checkIns')
        .where('seniorProfileId', isEqualTo: profileId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => CheckIn.fromMap(d.data())).toList();
  }

  @override
  Stream<List<CheckIn>> streamCheckIns(String profileId) {
    return _firestore
        .collection('checkIns')
        .where('seniorProfileId', isEqualTo: profileId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => CheckIn.fromMap(d.data())).toList());
  }

  @override
  Future<void> logScamCheck(ScamCheck check) async {
    await _firestore
        .collection('scamChecks')
        .doc(check.id)
        .set(check.toMap());
  }

  @override
  Future<List<ScamCheck>> getScamChecks(String profileId) async {
    final snap = await _firestore
        .collection('scamChecks')
        .where('seniorProfileId', isEqualTo: profileId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => ScamCheck.fromMap(d.data())).toList();
  }

  @override
  Stream<List<ScamCheck>> streamScamChecks(String profileId) {
    return _firestore
        .collection('scamChecks')
        .where('seniorProfileId', isEqualTo: profileId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => ScamCheck.fromMap(d.data())).toList());
  }

  @override
  Future<void> createAlert(Alert alert) async {
    await _firestore
        .collection('alerts')
        .doc(alert.id)
        .set(alert.toMap());
  }

  @override
  Future<void> resolveAlert(String alertId) async {
    await _firestore.collection('alerts').doc(alertId).update({
      'resolved': true,
    });
  }

  @override
  Stream<List<Alert>> streamAlertsForSenior(String profileId) {
    return _firestore
        .collection('alerts')
        .where('seniorProfileId', isEqualTo: profileId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Alert.fromMap(d.data())).toList());
  }
}
