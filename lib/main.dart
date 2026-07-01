import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/firebase_service.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/features/onboarding/login_screen.dart';
import 'package:gabaysr/features/onboarding/create_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCo08QG-hduosIMQizu40uREbeMZ9OcuRo",
          appId: "1:773876636296:android:dff9667323ba9717679d3d",
          messagingSenderId: "773876636296",
          projectId: "gabay-sr-4ced2",
          storageBucket: "gabay-sr-4ced2.firebasestorage.app",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    debugPrint("Firebase initialized successfully!");
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  // Create FirebaseService instances
  final firebaseService = FirebaseService();
  final appState = AppState(
    authService: firebaseService,
    databaseService: firebaseService,
  );

  runApp(MyApp(appState: appState));
}

class MyApp extends StatelessWidget {
  final AppState appState;

  const MyApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        ThemeData activeTheme;
        Widget activeHome;

        if (!appState.isAuthenticated) {
          activeTheme = AppTheme.familyTheme;
          activeHome = LoginScreen(appState: appState);
        } else if (appState.monitoredSeniors.isEmpty) {
          activeTheme = AppTheme.familyTheme;
          activeHome = CreateProfileScreen(appState: appState);
        } else {
          // If authenticated and profile exists, direct to the temporary Landing/Dashboard
          // Switch theme context based on active mode
          activeTheme = appState.appMode == AppMode.senior
              ? AppTheme.seniorTheme
              : AppTheme.familyTheme;
          activeHome = MainAppLanding(appState: appState);
        }

        return MaterialApp(
          title: 'Gabay Sr.',
          theme: activeTheme,
          home: activeHome,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

// Temporary Main Landing Screen for testing auth state transition
class MainAppLanding extends StatelessWidget {
  final AppState appState;

  const MainAppLanding({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final senior = appState.activeSenior;
    final mode = appState.appMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(mode == AppMode.senior ? 'Senior Mode' : 'Family Dashboard'),
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => appState.logOut(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                mode == AppMode.senior ? Icons.elderly : Icons.family_restroom,
                size: 72,
                color: AppTheme.primaryTeal,
              ),
              const SizedBox(height: 20),
              Text(
                'Kumusta, ${senior?.fullName ?? "User"}!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Barangay: ${senior?.barangay ?? "N/A"}',
                style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Toggle UI Theme/Mode for testing
                  appState.setAppMode(
                    mode == AppMode.senior ? AppMode.family : AppMode.senior,
                  );
                },
                child: Text(mode == AppMode.senior
                    ? 'LIPAT SA FAMILY MODE'
                    : 'LIPAT SA SENIOR MODE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
