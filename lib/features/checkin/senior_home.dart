import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/features/checkin/checkin_flowchart.dart';
import 'package:gabaysr/features/scam_checker/scam_checker_ui.dart';

class SeniorHome extends StatelessWidget {
  final AppState appState;

  const SeniorHome({super.key, required this.appState});

  // Design tokens from Stitch export
  static const Color _backgroundColor = Color(0xFFFAF8F5);
  static const Color _primaryColor = Color(0xFF005C55); // primary
  static const Color _primaryContainerColor = Color(0xFF0F766E); // primary-container
  static const Color _textPrimaryColor = Color(0xFF1B1B1D); // on-surface
  static const Color _textSecondaryColor = Color(0xFF3E4947); // on-surface-variant
  static const Color _borderColor = Color(0xFF6E7977); // outline
  static const Color _greenPillBg = Color(0xFFE6F4EA);
  static const Color _greenPillBorder = Color(0x3316A34B); // 20% opacity
  static const Color _greenPillText = Color(0xFF065F46);
  static const Color _amberColor = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    final seniorName = appState.activeSenior?.fullName ?? 'Lola/Lolo';

    return Theme(
      data: AppTheme.seniorTheme.copyWith(
        scaffoldBackgroundColor: _backgroundColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _backgroundColor,
          elevation: 0,
          leadingWidth: 200,
          leading: const Padding(
            padding: EdgeInsets.only(left: 24.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  child: Icon(Icons.elderly_outlined, color: _primaryColor, size: 28),
                ),
                SizedBox(width: 8),
                Text(
                  'Magandang araw!',
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: _textSecondaryColor, size: 28),
              onPressed: () {
                // TODO: Open settings
              },
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome Section
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 4)
                            ],
                          ),
                          child: const Icon(Icons.person, size: 40, color: _primaryColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Kumusta, $seniorName!',
                            style: const TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: _textPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Security Pill Banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: _greenPillBg,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: _greenPillBorder),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.verified_user, color: Colors.green, size: 24),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Protektado ang iyong account ng Trusted Circle.',
                              style: TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _greenPillText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Primary Action Center
                    // Button 1: Check-in (Teal)
                    SizedBox(
                      height: 96,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckInFlow(appState: appState),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryContainerColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.check_circle, size: 40),
                        label: const Text(
                          'I-CHECK IN NGAYON',
                          style: TextStyle(
                            fontFamily: 'Nunito Sans',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Button 2: Scam Check (Amber)
                    SizedBox(
                      height: 96,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScamCheckerUi(appState: appState),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _amberColor,
                          foregroundColor: _textPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.shield, size: 40),
                        label: const Text(
                          'I-CHECK KUNG SCAM',
                          style: TextStyle(
                            fontFamily: 'Nunito Sans',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: _textPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Secondary Contextual Card
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Araw-araw na Gabay',
                                  style: TextStyle(
                                    fontFamily: 'Nunito Sans',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: _textSecondaryColor,
                                  ),
                                ),
                                Icon(Icons.lightbulb_outline, color: _primaryColor, size: 24),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Siguraduhin na uminom ng sapat na tubig ngayong mainit ang panahon.',
                              style: TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 18,
                                color: _textPrimaryColor,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Switch to Family Dashboard
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          appState.setAppMode(AppMode.family);
                        },
                        icon: const Icon(Icons.swap_horiz, color: _borderColor),
                        label: const Text(
                          'Pumunta sa Family Dashboard',
                          style: TextStyle(
                            fontFamily: 'Nunito Sans',
                            fontSize: 16,
                            color: _borderColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
