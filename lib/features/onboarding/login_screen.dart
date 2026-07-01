import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/features/onboarding/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  final AppState appState;

  const LoginScreen({super.key, required this.appState});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void _submit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String phone = _phoneController.text.trim().replaceAll(' ', '');
    
    // Format leading 09xxxxxxxxx to international +639xxxxxxxxx
    if (phone.startsWith('0')) {
      phone = '+63${phone.substring(1)}';
    } else if (!phone.startsWith('+')) {
      phone = '+63$phone';
    }

    if (phone.length < 12) { // +639xxxxxxxxx is 13 chars, +63xxxxxxx min 12
      setState(() {
        _errorMessage = "Mangyaring ilagay ang wastong 11-digit number (e.g. 09123456789).";
        _isLoading = false;
      });
      return;
    }

    final formattedPhone = phone;

    await widget.appState.sendOtpCode(
      formattedPhone,
      onCodeSent: (verificationId) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              appState: widget.appState,
              verificationId: verificationId,
              phoneNumber: formattedPhone,
            ),
          ),
        );
      },
      onError: (error) {
        setState(() {
          _errorMessage = "May error: $error";
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.familyTheme, // Onboarding uses standard Family/Volunteer theme
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 72,
                  color: AppTheme.primaryTeal,
                ),
                const SizedBox(height: 16),
                Text(
                  'Gabay Sr.',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppTheme.primaryTeal,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Katuwang sa kaligtasan at companionship ng mga Lolo at Lola.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                const Text(
                  'Ilagay ang iyong Phone Number',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 16, letterSpacing: 1.2),
                  decoration: InputDecoration(
                    hintText: "0912 345 6789",
                    prefixIcon: const Icon(Icons.phone_android, color: AppTheme.primaryTeal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppTheme.primaryTeal, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppTheme.alertRed, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text('IPADALA ANG OTP CODE'),
                ),
                const SizedBox(height: 32),
                // Demo / Mock bypass for easy hackathon judging & developer verification
                OutlinedButton(
                  onPressed: () {
                    // Instantly logs in with a simulated mock volunteer number
                    widget.appState.verifyOtpCode("mock-verification-id", "123456");
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryTeal,
                    side: const BorderSide(color: AppTheme.primaryTeal),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('DEMO MODE: LAKTAWAN ANG OTP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
