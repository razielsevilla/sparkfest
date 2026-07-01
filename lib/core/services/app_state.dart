import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gabaysr/core/services/auth_service.dart';
import 'package:gabaysr/core/services/database_service.dart';
import 'package:gabaysr/models/senior_profile.dart';
import 'package:gabaysr/models/trusted_circle_member.dart';
import 'package:gabaysr/models/alert.dart';

enum AppMode { senior, family }

class AppState extends ChangeNotifier {
  final AuthService authService;
  final DatabaseService databaseService;

  AppMode _appMode = AppMode.family; // Default mode for setup
  String? _currentUserPhone;
  SeniorProfile? _activeSenior;
  List<SeniorProfile> _monitoredSeniors = [];
  List<TrustedCircleMember> _trustedCircle = [];
  List<Alert> _alerts = [];
  
  // Active listeners/subscriptions
  StreamSubscription? _authSubscription;
  StreamSubscription? _seniorsSubscription;
  StreamSubscription? _circleSubscription;
  StreamSubscription? _alertsSubscription;

  AppState({required this.authService, required this.databaseService}) {
    // Listen for auth state changes
    _authSubscription = authService.onAuthStateChanged.listen((userPhone) {
      _currentUserPhone = userPhone;
      if (userPhone != null) {
        _subscribeToSeniors(userPhone);
      } else {
        _clearUserSession();
      }
      notifyListeners();
    });
  }

  // Getters
  AppMode get appMode => _appMode;
  String? get currentUserPhone => _currentUserPhone;
  bool get isAuthenticated => _currentUserPhone != null;
  SeniorProfile? get activeSenior => _activeSenior;
  List<SeniorProfile> get monitoredSeniors => _monitoredSeniors;
  List<TrustedCircleMember> get trustedCircle => _trustedCircle;
  List<Alert> get alerts => _alerts;

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

  Future<void> logOut() async {
    await authService.signOut();
  }

  // ==========================================
  // DATA MANAGEMENT METHODS
  // ==========================================

  Future<void> registerSenior(SeniorProfile profile, TrustedCircleMember mainMember) async {
    // Write Senior Profile
    await databaseService.createSeniorProfile(profile);
    // Add creator as primary Trusted Circle Member
    await databaseService.addTrustedCircleMember(mainMember);
    // Set as the active profile automatically
    setActiveSenior(profile);
  }

  Future<void> inviteCircleMember(TrustedCircleMember member) async {
    await databaseService.addTrustedCircleMember(member);
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

    _circleSubscription = databaseService.streamTrustedCircle(seniorId).listen((members) {
      _trustedCircle = members;
      notifyListeners();
    });

    _alertsSubscription = databaseService.streamAlertsForSenior(seniorId).listen((alertList) {
      _alerts = alertList;
      notifyListeners();
    });
  }

  void _clearSeniorSubscriptions() {
    _circleSubscription?.cancel();
    _alertsSubscription?.cancel();
    _trustedCircle = [];
    _alerts = [];
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
