import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';

class FaqScreen extends StatelessWidget {
  final AppState appState;

  const FaqScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isSeniorMode = appState.appMode == AppMode.senior;
    final theme = isSeniorMode ? AppTheme.seniorTheme : AppTheme.familyTheme;

    const Color backgroundColor = Color(0xFFFAF8F5);
    const Color primaryColor = Color(0xFF005C55);
    const Color textSecondaryColor = Color(0xFF3E4947);

    final List<Map<String, String>> faqs = [
      {
        'q': 'Ano ang Gabay Sr.?',
        'a': 'Ang Gabay Sr. ay isang offline-first-adjacent mobile application na idinisenyo para sa kaligtasan at kalusugan ng mga nakatatandang mamamayan sa Pilipinas.'
      },
      {
        'q': 'Paano gamitin ang Daily Check-In?',
        'a': 'Pindutin lamang ang "I-CHECK IN NGAYON" sa home screen, piliin ang inyong nararamdamang mood ngayon, piliin ang inyong mga aktibidad, at magdagdag ng maikling tala kung nais.'
      },
      {
        'q': 'Paano nakakatulong ang Scam Checker?',
        'a': 'Maaari ninyong i-paste ang mga kahina-hinalang mensahe o ilagay ang numero ng nagpadala upang suriin ng aming AI kung ito ay isang scam o hindi.'
      },
      {
        'q': 'Ano ang Trusted Circle?',
        'a': 'Ito ang grupo ng inyong pamilya o tagapag-alaga na makakatanggap ng mga alerto kapag may emergency o kapag nakitaan ng potensyal na scam ang inyong mga natanggap na mensahe.'
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
            'Mga FAQs',
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
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ExpansionTile(
                      shape: const Border(),
                      title: Text(
                        faq['q']!,
                        style: TextStyle(
                          fontFamily: isSeniorMode ? 'Nunito Sans' : 'Inter',
                          fontSize: isSeniorMode ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1B1B1D),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                          child: Text(
                            faq['a']!,
                            style: TextStyle(
                              fontFamily: isSeniorMode ? 'Nunito Sans' : 'Inter',
                              fontSize: isSeniorMode ? 16 : 14,
                              color: textSecondaryColor,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
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
