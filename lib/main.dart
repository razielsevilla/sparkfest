import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/firebase_service.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/features/onboarding/auth_gate.dart';

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
        final activeTheme = appState.appMode == AppMode.senior
            ? AppTheme.seniorTheme
            : AppTheme.familyTheme;

        return MaterialApp(
          title: 'Gabay Sr.',
          theme: activeTheme,
          home: AuthGate(appState: appState),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}


