import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';

class OtpScreen extends StatefulWidget {
  final AppState appState;
  final String verificationId;
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.appState,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // Design tokens from Stitch export
  static const Color _backgroundColor = Color(0xFFFAF8F5);
  static const Color _primaryColor = Color(0xFF005C55); // primary
  static const Color _textPrimaryColor = Color(0xFF1B1B1D); // on-surface
  static const Color _textSecondaryColor = Color(0xFF3E4947); // on-surface-variant
  static const Color _borderColor = Color(0xFF6E7977); // outline
  static const Color _errorBackgroundColor = Color(0xFFFFDAD6); // error-container
  static const Color _errorTextColor = Color(0xFF93000A); // on-error-container

  void _verify() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final code = _otpController.text.trim();

    try {
      await widget.appState.verifyOtpCode(widget.verificationId, code);
      if (mounted) {
        Navigator.pop(context); // Pops back to LoginScreen, which triggers main.dart router refresh
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Maling code o may pagkakamali. Subukang muli.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.familyTheme.copyWith(
        scaffoldBackgroundColor: _backgroundColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: _textSecondaryColor, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          leadingWidth: 56,
          title: const Text(
            'Gabay Sr.',
            style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header Section
                            const SizedBox(height: 16),
                            const Text(
                              'I-verify ang iyong Numero',
                              style: TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: _textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ipinadala ang 6-digit verification code sa ${widget.phoneNumber}.',
                              style: const TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 18,
                                color: _textSecondaryColor,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 48),

                            // Code Input
                            const Text(
                              'Ipasok ang 6-Digit Code',
                              style: TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _textSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 12,
                              ),
                              decoration: InputDecoration(
                                hintText: '000000',
                                counterText: '',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: _borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: _primaryColor, width: 2),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Ilagay ang code';
                                }
                                if (val.trim().length != 6) {
                                  return 'Kailangang may 6 digits';
                                }
                                return null;
                              },
                            ),

                            // Dynamic Error Container
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 24),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Sticky Button Footer Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -4),
                    )
                  ],
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: SizedBox(
                      width: double.infinity,
                      height: 72,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'I-VERIFY AT MAGPATULOY',
                                    style: TextStyle(
                                      fontFamily: 'Nunito Sans',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
