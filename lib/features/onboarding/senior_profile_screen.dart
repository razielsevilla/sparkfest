import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';

class SeniorProfileScreen extends StatelessWidget {
  final AppState appState;

  const SeniorProfileScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final senior = appState.activeSenior;
    final isSeniorMode = appState.appMode == AppMode.senior;
    final theme = isSeniorMode ? AppTheme.seniorTheme : AppTheme.familyTheme;

    const Color backgroundColor = Color(0xFFFAF8F5);
    const Color primaryColor = Color(0xFF005C55);
    const Color textSecondaryColor = Color(0xFF3E4947);

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
            'Impormasyon ng Senior',
            style: TextStyle(
              fontFamily: isSeniorMode ? 'Nunito Sans' : 'Inter',
              fontSize: isSeniorMode ? 22 : 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4)
                          ],
                        ),
                        child: const Icon(Icons.person, size: 48, color: primaryColor),
                      ),
                    ),
                    const SizedBox(height: 32),
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
                            _buildInfoField(
                              'Buong Pangalan',
                              senior?.fullName ?? 'Hindi tinukoy',
                              isSeniorMode,
                            ),
                            const Divider(height: 32),
                            _buildInfoField(
                              'Edad',
                              senior != null ? '${senior.age} taong gulang' : 'Hindi tinukoy',
                              isSeniorMode,
                            ),
                            const Divider(height: 32),
                            _buildInfoField(
                              'Barangay',
                              senior?.barangay ?? 'Hindi tinukoy',
                              isSeniorMode,
                            ),
                            const Divider(height: 32),
                            _buildInfoField(
                              'Numero ng Telepono',
                              senior?.primaryContactPhone ?? 'Hindi tinukoy',
                              isSeniorMode,
                            ),
                          ],
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

  Widget _buildInfoField(String label, String value, bool isSeniorMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: isSeniorMode ? 'Nunito Sans' : 'Inter',
            fontSize: isSeniorMode ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6E7977),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: isSeniorMode ? 'Nunito Sans' : 'Inter',
            fontSize: isSeniorMode ? 22 : 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B1B1D),
          ),
        ),
      ],
    );
  }
}
