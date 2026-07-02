import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';

class HelpWalkthroughScreen extends StatelessWidget {
  final AppState appState;

  const HelpWalkthroughScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isSeniorMode = appState.appMode == AppMode.senior;
    final theme = isSeniorMode ? AppTheme.seniorTheme : AppTheme.familyTheme;

    const Color backgroundColor = Color(0xFFFAF8F5);
    const Color primaryColor = Color(0xFF005C55);
    const Color textSecondaryColor = Color(0xFF3E4947);

    final List<Map<String, dynamic>> steps = [
      {
        'title': '1. Magsagawa ng Daily Check-In',
        'desc': 'Araw-araw, mag-log ng iyong nararamdaman (mood), mga ginawa (activities), at opsyonal na mensahe. Ipapaalam nito sa iyong pamilya na ikaw ay ligtas at maayos.',
        'icon': Icons.check_circle_outline,
      },
      {
        'title': '2. Mag-check ng mga kahina-hinalang SMS',
        'desc': 'Gamitin ang Scam Checker upang kopyahin at suriin ang mga text na nagtatanong ng iyong OTP, pera, o personal na detalye.',
        'icon': Icons.shield_outlined,
      },
      {
        'title': '3. Alamin ang Kalagayan (para sa Pamilya)',
        'desc': 'Sa Family Dashboard, makikita ng pamilya ang lingguhang AI summary ng kalagayan ng senior, kasaysayan ng check-in, at mga scam checker logs.',
        'icon': Icons.family_restroom,
      },
      {
        'title': '4. Maagap na Alerto (Alerts)',
        'desc': 'Awtomatikong magpapadala ng alerto sa pamilya kapag nakitaan ng mataas na panganib sa scam checker o kapag nakaligtaan ang check-in.',
        'icon': Icons.notifications_active_outlined,
      }
    ];

    return Theme(
      data: theme.copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: textSecondaryColor, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Paano Gamitin ang App',
            style: TextStyle(
              fontFamily: isSeniorMode ? 'Nunito Sans' : 'Inter',
              fontSize: isSeniorMode ? 22 : 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(step['icon'] as IconData, color: primaryColor, size: 36),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step['title'] as String,
                                  style: TextStyle(
                                    fontFamily: isSeniorMode ? 'Nunito Sans' : 'Inter',
                                    fontSize: isSeniorMode ? 18 : 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1B1B1D),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  step['desc'] as String,
                                  style: TextStyle(
                                    fontFamily: isSeniorMode ? 'Nunito Sans' : 'Inter',
                                    fontSize: isSeniorMode ? 16 : 14,
                                    color: textSecondaryColor,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
