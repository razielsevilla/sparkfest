import 'package:flutter_test/flutter_test.dart';
import 'package:gabaysr/main.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/core/services/auth_service.dart';
import 'package:gabaysr/core/services/database_service.dart';
import 'package:gabaysr/models/senior_profile.dart';
import 'package:gabaysr/models/trusted_circle_member.dart';
import 'package:gabaysr/models/checkin.dart';
import 'package:gabaysr/models/scam_check.dart';
import 'package:gabaysr/models/alert.dart';
import 'dart:async';

// Mock simple classes to satisfy compiler in widget tests
class FakeAuthService implements AuthService {
  final _controller = StreamController<String?>.broadcast();
  
  @override
  Stream<String?> get onAuthStateChanged => _controller.stream;

  @override
  String? get currentUserId => null;

  @override
  Future<void> sendOtp(String phoneNumber, {required Function(String verificationId) onCodeSent, required Function(String error) onError}) async {}

  @override
  Future<String> verifyOtp(String verificationId, String smsCode) async => "";

  @override
  Future<void> signOut() async {}
}

class FakeDatabaseService implements DatabaseService {
  @override
  Future<void> createSeniorProfile(SeniorProfile profile) async {}
  @override
  Future<SeniorProfile?> getSeniorProfile(String profileId) async => null;
  @override
  Stream<List<SeniorProfile>> streamSeniorsForMember(String memberPhone) => Stream.value([]);
  @override
  Future<void> updateLastCheckIn(String profileId, DateTime checkInDate) async {}
  @override
  Future<void> addTrustedCircleMember(TrustedCircleMember member) async {}
  @override
  Future<List<TrustedCircleMember>> getTrustedCircle(String profileId) async => [];
  @override
  Stream<List<TrustedCircleMember>> streamTrustedCircle(String profileId) => Stream.value([]);
  @override
  Future<void> logCheckIn(CheckIn checkIn) async {}
  @override
  Future<List<CheckIn>> getCheckIns(String profileId, {int limit = 7}) async => [];
  @override
  Stream<List<CheckIn>> streamCheckIns(String profileId) => Stream.value([]);
  @override
  Future<void> logScamCheck(ScamCheck check) async {}
  @override
  Future<List<ScamCheck>> getScamChecks(String profileId) async => [];
  @override
  Stream<List<ScamCheck>> streamScamChecks(String profileId) => Stream.value([]);
  @override
  Future<void> createAlert(Alert alert) async {}
  @override
  Future<void> resolveAlert(String alertId) async {}
  @override
  Stream<List<Alert>> streamAlertsForSenior(String profileId) => Stream.value([]);
  @override
  Future<void> saveWeeklySummary(String profileId, String summaryText, String moodTrend) async {}
  @override
  Stream<String?> streamLatestWeeklySummary(String profileId) => Stream.value(null);
  @override
  Future<int> purgeOldScamChecks(String profileId) async => 0;
}

void main() {
  testWidgets('App starts and displays login flow', (WidgetTester tester) async {
    final appState = AppState(
      authService: FakeAuthService(),
      databaseService: FakeDatabaseService(),
    );

    await tester.pumpWidget(MyApp(appState: appState));

    // Verify that the login screen is displayed and shows the app name
    expect(find.text('Gabay Sr.'), findsOneWidget);
  });
}
