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
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void _verify() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final code = _otpController.text.trim();
    if (code.length != 6) {
      setState(() {
        _errorMessage = "Mangyaring ilagay ang 6-digit code.";
        _isLoading = false;
      });
      return;
    }

    try {
      await widget.appState.verifyOtpCode(widget.verificationId, code);
      // Success: Pop back to LoginScreen which will automatically trigger the main.dart auth listener
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Maling code o may pagkakamali. Subukang muli.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.familyTheme,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.lock_open_outlined,
                  size: 72,
                  color: AppTheme.primaryTeal,
                ),
                const SizedBox(height: 16),
                Text(
                  'I-verify ang iyong Number',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        color: AppTheme.primaryTeal,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ipinadala ang SMS verification code sa ${widget.phoneNumber}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                const Text(
                  'Ipasok ang 6-Digit Code',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: "000000",
                    counterText: "",
                    prefixIcon: const Icon(Icons.vpn_key_outlined, color: AppTheme.primaryTeal),
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
                  onPressed: _isLoading ? null : _verify,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text('I-VERIFY AT MAGPATULOY'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
