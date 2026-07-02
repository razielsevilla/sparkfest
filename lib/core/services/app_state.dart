import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gabaysr/core/services/auth_service.dart';
import 'package:gabaysr/core/services/database_service.dart';
import 'package:gabaysr/models/senior_profile.dart';
import 'package:gabaysr/models/trusted_circle_member.dart';
import 'package:gabaysr/models/alert.dart';
import 'package:gabaysr/core/services/gemini_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AppMode { senior, family }
enum OnboardingStep { none, createProfile, addCircle, complete }

class AppState extends ChangeNotifier {
  final AuthService authService;
  final DatabaseService databaseService;

  AppMode _appMode = AppMode.family; // Default mode for setup
  String? _currentUserPhone;
  SeniorProfile? _activeSenior;
  List<SeniorProfile> _monitoredSeniors = [];
  List<TrustedCircleMember> _trustedCircle = [];
  List<Alert> _alerts = [];
  String? _latestWeeklySummary;

  // Authentication gating state
  bool _isSessionInitialized = false;
  OnboardingStep _onboardingStep = OnboardingStep.none;

  // Active listeners/subscriptions
  StreamSubscription? _authSubscription;
  StreamSubscription? _seniorsSubscription;
  StreamSubscription? _circleSubscription;
  StreamSubscription? _alertsSubscription;
  StreamSubscription? _summarySubscription;

  final _secureStorage = const FlutterSecureStorage();

  AppState({required this.authService, required this.databaseService}) {
    // Perform initial async startup check
    initializeSession();

    // Listen to Firebase Auth state change events
    _authSubscription = authService.onAuthStateChanged.listen((userPhone) async {
      final savedPhone = await _secureStorage.read(key: 'saved_user_phone');
      if (userPhone != null) {
        _currentUserPhone = userPhone;
        await _savePersistedSession(userPhone);
        await _resolveOnboardingStatus(userPhone);
        _subscribeToSeniors(userPhone);
      } else if (savedPhone == null) {
        _clearUserSession();
        _onboardingStep = OnboardingStep.none;
        notifyListeners();
      }
    });
  }

  // Asynchronous gate check on startup
  Future<void> initializeSession() async {
    try {
      final savedPhone = await _secureStorage.read(key: 'saved_user_phone');
      if (savedPhone != null) {
        _currentUserPhone = savedPhone;
        await _resolveOnboardingStatus(savedPhone);
        _subscribeToSeniors(savedPhone);
      } else {
        _onboardingStep = OnboardingStep.none;
      }
    } catch (e) {
      _onboardingStep = OnboardingStep.none;
    } finally {
      _isSessionInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _resolveOnboardingStatus(String phone) async {
    final seniors = await databaseService.getSeniorsForMember(phone);
    if (seniors.isEmpty) {
      _onboardingStep = OnboardingStep.createProfile;
    } else {
      final senior = seniors.first;
      final circle = await databaseService.getTrustedCircle(senior.id);
      if (circle.isEmpty) {
        _onboardingStep = OnboardingStep.addCircle;
      } else {
        _onboardingStep = OnboardingStep.complete;
      }
    }
  }

  Future<void> _savePersistedSession(String phone) async {
    await _secureStorage.write(key: 'saved_user_phone', value: phone);
  }

  Future<void> _clearPersistedSession() async {
    await _secureStorage.delete(key: 'saved_user_phone');
  }

  // Getters
  AppMode get appMode => _appMode;
  String? get currentUserPhone => _currentUserPhone;
  bool get isAuthenticated => _currentUserPhone != null;
  bool get isSessionInitialized => _isSessionInitialized;
  OnboardingStep get onboardingStep => _onboardingStep;
  SeniorProfile? get activeSenior => _activeSenior;
  List<SeniorProfile> get monitoredSeniors => _monitoredSeniors;
  List<TrustedCircleMember> get trustedCircle => _trustedCircle;
  List<Alert> get alerts => _alerts;
  String? get latestWeeklySummary => _latestWeeklySummary;

  // Set App Mode (Senior Mode / Family Mode switcher)
  void setAppMode(AppMode mode) {
    _appMode = mode;
    notifyListeners();
  }

  // Set active senior profile to monitor/interact with
  void setActiveSenior(SeniorProfile? senior) {
    _activeSenior = senior;
    if (senior != null) {
      _subscribeToSeniorData(senior.id);
    } else {
      _clearSeniorSubscriptions();
    }
    notifyListeners();
  }

  // ==========================================
  // AUTH FLOW METHODS
  // ==========================================

  Future<void> sendOtpCode(
    String phone, {
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    await authService.sendOtp(phone, onCodeSent: onCodeSent, onError: onError);
  }

  Future<void> verifyOtpCode(String verificationId, String smsCode) async {
    await authService.verifyOtp(verificationId, smsCode);
  }

  void mockSignIn(String phone) async {
    _currentUserPhone = phone;
    await _savePersistedSession(phone);
    await _resolveOnboardingStatus(phone);
    _subscribeToSeniors(phone);
    notifyListeners();
  }

  Future<void> logOut() async {
    await _clearPersistedSession();
    _clearUserSession();
    _onboardingStep = OnboardingStep.none;
    await authService.signOut();
    notifyListeners();
  }

  // ==========================================
  // DATA MANAGEMENT METHODS
  // ==========================================

  Future<void> createSeniorProfileOnly(SeniorProfile profile) async {
    await databaseService.createSeniorProfile(profile);
    _onboardingStep = OnboardingStep.addCircle;
    _activeSenior = profile;
    _monitoredSeniors = [profile];
    notifyListeners();
  }

  Future<void> registerSenior(SeniorProfile profile, TrustedCircleMember mainMember) async {
    // Write Senior Profile
    await databaseService.createSeniorProfile(profile);
    // Add creator as primary Trusted Circle Member
    await databaseService.addTrustedCircleMember(mainMember);
    // Synchronously populate monitored seniors to trigger correct route instantly in MyApp
    _monitoredSeniors = [profile];
    _onboardingStep = OnboardingStep.complete;
    // Set as the active profile automatically
    setActiveSenior(profile);
  }

  Future<void> inviteCircleMember(TrustedCircleMember member) async {
    await databaseService.addTrustedCircleMember(member);
  }

  Future<void> generateAndSaveWeeklySummary(String seniorName) async {
    if (_activeSenior == null) return;
    final checkins = await databaseService.getCheckIns(_activeSenior!.id, limit: 7);
    
    // Call Gemini AI service
    final aiService = GeminiService(); // reads API Key from env configs automatically
    final summaryText = await aiService.generateWeeklySummary(seniorName, checkins);
    
    // Derive mood trend
    String moodTrend = "Stable";
    if (checkins.isNotEmpty) {
      final happy = checkins.where((c) => c.mood == "Masaya").length;
      final sad = checkins.where((c) => c.mood == "Malungkot").length;
      if (happy > sad) moodTrend = "Improving";
      if (sad > happy) moodTrend = "Declining";
    }

    await databaseService.saveWeeklySummary(_activeSenior!.id, summaryText, moodTrend);
  }

  Future<void> resolveAlert(String alertId) async {
    await databaseService.resolveAlert(alertId);
  }

  // ==========================================
  // INTERNAL DELEGATES / STREAM BINDINGS
  // ==========================================

  void _subscribeToSeniors(String phone) {
    _seniorsSubscription?.cancel();
    _seniorsSubscription = databaseService.streamSeniorsForMember(phone).listen((seniors) {
      _monitoredSeniors = seniors;
      // If there's an active senior selected, refresh its details from the list
      if (_activeSenior != null) {
        final updated = seniors.firstWhere(
          (s) => s.id == _activeSenior!.id,
          orElse: () => _activeSenior!,
        );
        _activeSenior = updated;
      } else if (seniors.isNotEmpty) {
        // Default to first senior if none is active
        setActiveSenior(seniors.first);
      }
      notifyListeners();
    });
  }

  void _subscribeToSeniorData(String seniorId) {
    _clearSeniorSubscriptions();

    // FR-BR-05 / NFR-Security: Purge scam check records older than 30 days
    // on every session start to comply with data retention policy.
    databaseService.purgeOldScamChecks(seniorId);

    _circleSubscription = databaseService.streamTrustedCircle(seniorId).listen((members) {
      _trustedCircle = members;
      notifyListeners();
    });

    _alertsSubscription = databaseService.streamAlertsForSenior(seniorId).listen((alertList) {
      _alerts = alertList;
      notifyListeners();
    });

    _summarySubscription = databaseService.streamLatestWeeklySummary(seniorId).listen((summary) {
      _latestWeeklySummary = summary;
      notifyListeners();
    });
  }

  void _clearSeniorSubscriptions() {
    _circleSubscription?.cancel();
    _alertsSubscription?.cancel();
    _summarySubscription?.cancel();
    _trustedCircle = [];
    _alerts = [];
    _latestWeeklySummary = null;
  }

  void _clearUserSession() {
    _currentUserPhone = null;
    _monitoredSeniors = [];
    _activeSenior = null;
    _clearSeniorSubscriptions();
    _seniorsSubscription?.cancel();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _seniorsSubscription?.cancel();
    _clearSeniorSubscriptions();
    super.dispose();
  }
}
