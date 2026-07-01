import 'package:gabaysr/models/senior_profile.dart';
import 'package:gabaysr/models/trusted_circle_member.dart';
import 'package:gabaysr/models/checkin.dart';
import 'package:gabaysr/models/scam_check.dart';
import 'package:gabaysr/models/alert.dart';

abstract class DatabaseService {
  // Senior Profile Operations
  Future<void> createSeniorProfile(SeniorProfile profile);
  Future<SeniorProfile?> getSeniorProfile(String profileId);
  Stream<List<SeniorProfile>> streamSeniorsForMember(String memberPhone);
  Future<void> updateLastCheckIn(String profileId, DateTime checkInDate);

  // Trusted Circle Operations
  Future<void> addTrustedCircleMember(TrustedCircleMember member);
  Future<List<TrustedCircleMember>> getTrustedCircle(String profileId);
  Stream<List<TrustedCircleMember>> streamTrustedCircle(String profileId);

  // Daily Check-In Operations
  Future<void> logCheckIn(CheckIn checkIn);
  Future<List<CheckIn>> getCheckIns(String profileId, {int limit = 7});
  Stream<List<CheckIn>> streamCheckIns(String profileId);

  // Scam Checker Operations
  Future<void> logScamCheck(ScamCheck check);
  Future<List<ScamCheck>> getScamChecks(String profileId);
  Stream<List<ScamCheck>> streamScamChecks(String profileId);

  // Weekly Summary Operations
  Future<void> saveWeeklySummary(String profileId, String summaryText, String moodTrend);
  Stream<String?> streamLatestWeeklySummary(String profileId);

  // Alert Operations
  Future<void> createAlert(Alert alert);
  Future<void> resolveAlert(String alertId);
  Stream<List<Alert>> streamAlertsForSenior(String profileId);
}
