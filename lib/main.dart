import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gabaysr/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    if (kIsWeb) {
      // Configuration for Web debugging
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCo08QG-hduosIMQizu40uREbeMZ9OcuRo",
          appId: "1:773876636296:android:dff9667323ba9717679d3d", // fallback using Android client app ID
          messagingSenderId: "773876636296",
          projectId: "gabay-sr-4ced2",
          storageBucket: "gabay-sr-4ced2.firebasestorage.app",
        ),
      );
    } else {
      // Reads configuration from native config files (google-services.json & GoogleService-Info.plist)
      await Firebase.initializeApp();
    }
    debugPrint("Firebase initialized successfully!");
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Run the app in Senior Mode theme to test compilation and themes
    return MaterialApp(
      title: 'Gabay Sr.',
      theme: AppTheme.seniorTheme,
      home: const TestPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gabay Sr. Foundation'),
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Kumusta, Lola at Lolo! 😊',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Ang Gabay Sr. ay matagumpay na nakakonekta sa Firebase!',
                style: TextStyle(
                  fontSize: 20,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Gumagana ang Large Button!',
                        style: TextStyle(fontSize: 18),
                      ),
                      backgroundColor: AppTheme.primaryTeal,
                    ),
                  );
                },
                child: const Text('SUBUKAN ANG BOTON'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
