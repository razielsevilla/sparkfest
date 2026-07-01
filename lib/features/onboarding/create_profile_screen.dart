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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  void _next() {
    if (!_formKey.currentState!.validate()) return;

    final seniorId = 'senior_${DateTime.now().millisecondsSinceEpoch}';
    final newProfile = SeniorProfile(
      id: seniorId,
      fullName: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      barangay: _barangayController.text.trim(),
      primaryContactPhone: _phoneController.text.trim(),
      pinCode: _pinController.text.trim().isEmpty ? null : _pinController.text.trim(),
      createdAt: DateTime.now(),
    );

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

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.familyTheme,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('I-set up ang Senior Profile'),
          backgroundColor: AppTheme.primaryTeal,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Sino ang nakatatanda na ating babantayan?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryTeal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ilagay ang impormasyon ng senior citizen para magkaroon sila ng profile.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Buong Pangalan (Full Name)',
                    prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryTeal),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Ilagay ang buong pangalan.' : null,
                ),
                const SizedBox(height: 20),

                // Age Field
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Edad (Age)',
                    prefixIcon: Icon(Icons.cake_outlined, color: AppTheme.primaryTeal),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Ilagay ang edad.';
                    final age = int.tryParse(val.trim());
                    if (age == null || age <= 0) return 'Ilagay ang wastong edad.';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Barangay Field
                TextFormField(
                  controller: _barangayController,
                  decoration: const InputDecoration(
                    labelText: 'Barangay / Lungsod (City)',
                    hintText: 'e.g. San Antonio, Biñan',
                    prefixIcon: Icon(Icons.location_on_outlined, color: AppTheme.primaryTeal),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Ilagay ang barangay o lungsod.' : null,
                ),
                const SizedBox(height: 20),

                // Primary phone number
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number ng Senior (o Tagapag-alaga)',
                    prefixIcon: Icon(Icons.phone_android_outlined, color: AppTheme.primaryTeal),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Ilagay ang phone number.' : null,
                ),
                const SizedBox(height: 20),

                // PIN Code field
                TextFormField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    labelText: '4-Digit PIN Code ng Senior (Opsyonal)',
                    hintText: 'Para sa mabilis na pagpasok ng Senior',
                    prefixIcon: Icon(Icons.pin_outlined, color: AppTheme.primaryTeal),
                    border: OutlineInputBorder(),
                    counterText: "",
                  ),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _next,
                  child: const Text('PATULOY SA TRUSTED CIRCLE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
