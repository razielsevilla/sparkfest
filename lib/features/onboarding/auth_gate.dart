import 'package:flutter/material.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/features/onboarding/login_screen.dart';
import 'package:gabaysr/features/onboarding/create_profile_screen.dart';
import 'package:gabaysr/features/onboarding/add_circle_screen.dart';
import 'package:gabaysr/features/checkin/senior_home.dart';
import 'package:gabaysr/features/summary/family_dashboard.dart';

class AuthGate extends StatelessWidget {
  final AppState appState;

  const AuthGate({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        if (!appState.isSessionInitialized) {
          return const _SplashLoadingScreen();
        }

        switch (appState.onboardingStep) {
          case OnboardingStep.none:
            return LoginScreen(appState: appState);
          case OnboardingStep.createProfile:
            return CreateProfileScreen(appState: appState);
          case OnboardingStep.addCircle:
            if (appState.activeSenior == null) {
              return const _SplashLoadingScreen();
            }
            return AddCircleScreen(
              appState: appState,
              seniorProfile: appState.activeSenior!,
            );
          case OnboardingStep.complete:
            if (appState.appMode == AppMode.senior) {
              return SeniorHome(appState: appState);
            } else {
              return FamilyDashboard(appState: appState);
            }
        }
      },
    );
  }
}

class _SplashLoadingScreen extends StatefulWidget {
  const _SplashLoadingScreen();

  @override
  State<_SplashLoadingScreen> createState() => _SplashLoadingScreenState();
}

class _SplashLoadingScreenState extends State<_SplashLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0F766E);
    const Color textSecondaryColor = Color(0xFF3E4947);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Floating animated icon container
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -6 * (1 - _controller.value)),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF005C55), primaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x4D0F766E),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.elderly,
                      color: Colors.white,
                      size: 56,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Gabay Sr.',
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: primaryColor,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Gabay at proteksyon para sa ating mga Lolo at Lola.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 16,
                color: textSecondaryColor,
              ),
            ),
            const SizedBox(height: 48),
            // Custom circular loading indicator
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 3.5,
                backgroundColor: const Color(0x1A0F766E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
