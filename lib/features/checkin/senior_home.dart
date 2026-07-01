import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/features/checkin/checkin_flow.dart';

class SeniorHome extends StatelessWidget {
  final AppState appState;

  const SeniorHome({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    // Ensure Senior mode styling is enforced
    return Theme(
      data: AppTheme.seniorTheme,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundWarm,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Greeting Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.primaryTeal,
                      child: const Icon(Icons.person, size: 36, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kumusta,',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppTheme.textSecondary,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            appState.activeSenior?.fullName ?? 'Lola/Lolo',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                              height: 1.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryTeal.withAlpha(50), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: AppTheme.primaryTeal, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Protektado ang iyong account ng Trusted Circle.',
                          style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),

                // Button 1: Check In Today (Action 1)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckInFlow(appState: appState),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 4,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 40),
                      SizedBox(width: 16),
                      Text(
                        'I-CHECK IN NGAYON',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Button 2: Scam Checker (Action 2)
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Scam Checker screen (to be developed)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Scam Checker is coming in Day 3!'),
                        backgroundColor: AppTheme.primaryTeal,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryAmber,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 4,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 40),
                      SizedBox(width: 16),
                      Text(
                        'I-CHECK KUNG SCAM',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),

                // Switch back to Family Mode (Aide option)
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      appState.setAppMode(AppMode.family);
                    },
                    icon: const Icon(Icons.swap_horiz, size: 24, color: AppTheme.primaryTeal),
                    label: const Text(
                      'Pumunta sa Family Dashboard',
                      style: TextStyle(fontSize: 18, color: AppTheme.primaryTeal, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
