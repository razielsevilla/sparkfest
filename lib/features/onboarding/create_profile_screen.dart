import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/models/senior_profile.dart';
import 'package:gabaysr/features/onboarding/add_circle_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  final AppState appState;

  const CreateProfileScreen({super.key, required this.appState});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _barangayController = TextEditingController();
  bool _isLoading = false;

  // Design tokens from Stitch export
  static const Color _backgroundColor = Color(0xFFFAF8F5);
  static const Color _primaryColor = Color(0xFF005C55); // primary
  static const Color _textPrimaryColor = Color(0xFF1B1B1D); // on-surface
  static const Color _textSecondaryColor = Color(0xFF3E4947); // on-surface-variant
  static const Color _borderColor = Color(0xFF6E7977); // outline
  static const Color _surfaceContainerColor = Color(0xFFF6F3F5); // surface-container-low

  @override
  void initState() {
    super.initState();
    // Default values cleared for user input
    _nameController.text = "";
    _ageController.text = "";
    _barangayController.text = "";
  }

  void _next() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final seniorId = 'senior_${DateTime.now().millisecondsSinceEpoch}';
    final newProfile = SeniorProfile(
      id: seniorId,
      fullName: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      barangay: _barangayController.text.trim(),
      primaryContactPhone: widget.appState.currentUserPhone ?? '+63 917 123 4567',
      createdAt: DateTime.now(),
    );

    try {
      await widget.appState.createSeniorProfileOnly(newProfile);
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddCircleScreen(
              appState: widget.appState,
              seniorProfile: newProfile,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('May error sa pag-save: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final verifiedPhone = widget.appState.currentUserPhone ?? '+63 917 123 4567';

    return Theme(
      data: AppTheme.familyTheme.copyWith(
        scaffoldBackgroundColor: _backgroundColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _backgroundColor,
          elevation: 0,
          leadingWidth: 180,
          leading: Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.person, color: _primaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Gabay Sr.',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Title
                            const Text(
                              'Tungkol kay Lola/Lolo',
                              style: TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: _textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tulungan kaming makilala ang iyong mahal sa buhay upang makapagbigay ng pinakamahusay na serbisyo.',
                              style: TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 18,
                                color: _textSecondaryColor,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Full Name Input
                            const Text(
                              'Buong Pangalan ni Lola/Lolo',
                              style: TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _textSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 18),
                              decoration: InputDecoration(
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
                              validator: (val) =>
                                  val == null || val.trim().isEmpty ? 'Ilagay ang pangalan' : null,
                            ),
                            const SizedBox(height: 24),

                            // Age Input (Narrow - 1/2 Width)
                            FractionallySizedBox(
                              widthFactor: 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Edad',
                                    style: TextStyle(
                                      fontFamily: 'Nunito Sans',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: _textSecondaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _ageController,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 18),
                                    decoration: InputDecoration(
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
                                      if (val == null || val.trim().isEmpty) return 'Kailangan';
                                      final parsed = int.tryParse(val.trim());
                                      if (parsed == null || parsed <= 0) return 'Mali';
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Barangay Input with location icon
                            const Text(
                              'Barangay',
                              style: TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _textSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _barangayController,
                              style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 18),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.location_on, color: _primaryColor),
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
                              validator: (val) =>
                                  val == null || val.trim().isEmpty ? 'Ilagay ang barangay' : null,
                            ),
                            const SizedBox(height: 24),

                            // Contact Input (Read-Only)
                            const Text(
                              'Contact',
                              style: TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _textSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              initialValue: verifiedPhone,
                              readOnly: true,
                              style: const TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 18,
                                color: _textSecondaryColor,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.lock, color: _borderColor),
                                fillColor: _surfaceContainerColor,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: _borderColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Ito ang ginamit na numero para sa verification.',
                              style: TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 14,
                                color: _borderColor,
                              ),
                            ),
                            const SizedBox(height: 32),
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
                        onPressed: _isLoading ? null : _next,
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
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'KUMPIRMAHIN',
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
