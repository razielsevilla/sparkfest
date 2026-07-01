import 'package:flutter/material.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/features/onboarding/senior_profile_screen.dart';
import 'package:gabaysr/features/onboarding/faq_screen.dart';
import 'package:gabaysr/features/onboarding/help_walkthrough_screen.dart';

class SettingsDropdownMenu extends StatelessWidget {
  final AppState appState;
  final Color iconColor;

  const SettingsDropdownMenu({
    super.key,
    required this.appState,
    this.iconColor = const Color(0xFF3E4947),
  });

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFAF8F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Mag-logout',
            style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B1B1D),
            ),
          ),
          content: const Text(
            'Sigurado ka bang nais mong mag-logout sa iyong account?',
            style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 16,
              color: Color(0xFF3E4947),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'KANSELAHIN',
                style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6E7977),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // Close dialog
                await appState.logOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBA1A1A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'MAG-LOGOUT',
                style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.settings_outlined, color: iconColor, size: 28),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      onSelected: (value) {
        switch (value) {
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SeniorProfileScreen(appState: appState),
              ),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FaqScreen(appState: appState),
              ),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HelpWalkthroughScreen(appState: appState),
              ),
            );
            break;
          case 4:
            _showLogoutConfirmation(context);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text(
            'Senior Citizen Info',
            style: TextStyle(fontFamily: 'Nunito Sans', fontWeight: FontWeight.w600),
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text(
            'FAQs',
            style: TextStyle(fontFamily: 'Nunito Sans', fontWeight: FontWeight.w600),
          ),
        ),
        const PopupMenuItem(
          value: 3,
          child: Text(
            'How to Use the App',
            style: TextStyle(fontFamily: 'Nunito Sans', fontWeight: FontWeight.w600),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 4,
          child: Text(
            'Logout',
            style: TextStyle(
              fontFamily: 'Nunito Sans',
              color: Color(0xFFBA1A1A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
