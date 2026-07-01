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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // Design Tokens based on Stitch export specifications
  static const Color _backgroundColor = Color(0xFFFAF8F5);
  static const Color _primaryColor = Color(0xFF0F766E); // primary-container
  static const Color _textPrimaryColor = Color(0xFF1B1B1D); // on-surface
  static const Color _textSecondaryColor = Color(0xFF3E4947); // on-surface-variant
  static const Color _borderColor = Color(0xFF6E7977); // outline
  static const Color _errorBackgroundColor = Color(0xFFFFDAD6); // error-container
  static const Color _errorTextColor = Color(0xFF93000A); // on-error-container

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String phone = _phoneController.text.trim().replaceAll('-', '').replaceAll(' ', '');

    // Format leading 09xxxxxxxxx to international +639xxxxxxxxx
    if (phone.startsWith('0')) {
      phone = '+63${phone.substring(1)}';
    } else if (!phone.startsWith('+')) {
      phone = '+63$phone';
    }

    await widget.appState.sendOtpCode(
      phone,
      onCodeSent: (verificationId) {
        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                appState: widget.appState,
                verificationId: verificationId,
                phoneNumber: phone,
              ),
            ),
          );
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _errorMessage = "May error sa pagpapadala: $error";
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.familyTheme.copyWith(
        scaffoldBackgroundColor: _backgroundColor,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section
                      Column(
                        children: [
                          const SizedBox(height: 48),
                          Image.asset(
                            'assets/images/gabay-logo.png',
                            width: 96,
                            height: 96,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Gabay Sr.',
                            style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: _primaryColor,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Gabay at proteksyon para sa ating mga Lolo at Lola.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 20,
                              color: _textSecondaryColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Input Group
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Numero ng Telepono',
                            style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Country Code Prefix (+63)
                              Container(
                                height: 64,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: _borderColor),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  '+63',
                                  style: TextStyle(
                                    fontFamily: 'Nunito Sans',
                                    fontSize: 20,
                                    color: _textPrimaryColor,
                                  ),
                                ),
                              ),
                              // Text Field Input
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito Sans',
                                    fontSize: 20,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: '9XX-XXX-XXXX',
                                    counterText: '',
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      borderSide: BorderSide(color: _borderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      borderSide: BorderSide(color: _primaryColor, width: 2),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Ilagay ang iyong numero';
                                    }
                                    final plainNum = value.replaceAll('-', '').trim();
                                    if (plainNum.length != 10 || !plainNum.startsWith('9')) {
                                      return 'Dapat magsimula sa 9 at may 10 digits';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Dynamic Error Message Container
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _errorBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Nunito Sans',
                              color: _errorTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Primary Action Button
                      SizedBox(
                        height: 64,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  'PADALHAN NG OTP',
                                  style: TextStyle(
                                    fontFamily: 'Nunito Sans',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Support / Help Links
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Wala pang account? ',
                                style: TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 16,
                                  color: _textSecondaryColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // TODO: Navigate to Registration Screen
                                },
                                child: const Text(
                                  'Mag-sign up dito',
                                  style: TextStyle(
                                    fontFamily: 'Nunito Sans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: _primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Open Help / FAQ
                            },
                            icon: const Icon(Icons.help_outline, color: _textSecondaryColor),
                            label: const Text(
                              'Kailangan ng tulong?',
                              style: TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 16,
                                color: _textSecondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),

                      // Footer Copyright Notice
                      const Text(
                        '© 2024 Gabay Sr. Ligtas at Mapayapa.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 16,
                          color: _borderColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
