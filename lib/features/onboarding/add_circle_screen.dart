import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/models/senior_profile.dart';
import 'package:gabaysr/models/trusted_circle_member.dart';
import 'package:gabaysr/features/summary/family_dashboard.dart';

class AddCircleScreen extends StatefulWidget {
  final AppState appState;
  final SeniorProfile seniorProfile;

  const AddCircleScreen({
    super.key,
    required this.appState,
    required this.seniorProfile,
  });

  @override
  State<AddCircleScreen> createState() => _AddCircleScreenState();
}

class _AddCircleScreenState extends State<AddCircleScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedRelationship = 'anak';
  String _selectedRole = 'family'; // family or volunteer
  bool _isLoading = false;

  // Design tokens from Stitch export
  static const Color _backgroundColor = Color(0xFFFAF8F5);
  static const Color _primaryColor = Color(0xFF005C55); // primary
  static const Color _primaryContainerColor = Color(0xFF0F766E); // primary-container
  static const Color _textSecondaryColor = Color(0xFF3E4947); // on-surface-variant
  static const Color _surfaceContainerColor = Color(0xFFF0EDEF); // surface-container
  static const Color _errorColor = Color(0xFFBA1A1A); // error

  final List<Map<String, String>> _relationships = [
    {'value': 'anak', 'label': 'Anak'},
    {'value': 'asawa', 'label': 'Asawa'},
    {'value': 'apo', 'label': 'Apo'},
    {'value': 'kaibigan', 'label': 'Kaibigan'},
    {'value': 'volunteer', 'label': 'Volunteer'},
  ];

  @override
  void initState() {
    super.initState();
  }

  void _saveAndFinish() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Create primary member (the currently logged in user)
      final primaryMemberId = 'member_primary_${DateTime.now().millisecondsSinceEpoch}';
      final primaryMember = TrustedCircleMember(
        id: primaryMemberId,
        seniorProfileId: widget.seniorProfile.id,
        name: 'Primary Monitor',
        relationship: 'Pamilya',
        phoneNumber: widget.appState.currentUserPhone ?? '',
        role: 'family',
      );

      // 2. Save senior profile and primary member in Firestore
      await widget.appState.registerSenior(widget.seniorProfile, primaryMember);

      // 3. Save the entered circle member
      final enteredMemberId = 'member_${DateTime.now().millisecondsSinceEpoch}';
      final relationshipLabel = _relationships.firstWhere((r) => r['value'] == _selectedRelationship)['label']!;
      final enteredMember = TrustedCircleMember(
        id: enteredMemberId,
        seniorProfileId: widget.seniorProfile.id,
        name: _nameController.text.trim(),
        relationship: relationshipLabel,
        phoneNumber: _phoneController.text.trim(),
        role: _selectedRole,
      );
      await widget.appState.inviteCircleMember(enteredMember);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Matagumpay na na-set up ang profile at circle!'),
            backgroundColor: _primaryColor,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => FamilyDashboard(appState: widget.appState),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('May error sa pag-save: $e'),
            backgroundColor: _errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Form Card
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Ating Trusted Circle',
                                style: TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: _primaryColor,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Name Input
                              const Text(
                                'Pangalan ng Contact',
                                style: TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nameController,
                                style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 18),
                                decoration: InputDecoration(
                                  hintText: 'I-type ang pangalan',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                validator: (val) =>
                                    val == null || val.trim().isEmpty ? 'Kailangan ang pangalan' : null,
                              ),
                              const SizedBox(height: 20),

                              // Relationship Dropdown
                              const Text(
                                'Relasyon',
                                style: TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedRelationship,
                                items: _relationships.map((r) {
                                  return DropdownMenuItem(
                                    value: r['value'],
                                    child: Text(r['label']!),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                                onChanged: (val) {
                                  setState(() => _selectedRelationship = val!);
                                },
                              ),
                              const SizedBox(height: 20),

                              // Number Input
                              const Text(
                                'Numero ng Contact',
                                style: TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 18),
                                decoration: InputDecoration(
                                  hintText: '09XX XXX XXXX',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) return 'Kailangan ang numero';
                                  if (val.trim().length < 10) return 'Masyadong maikli';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Uri ng Contact Toggle
                              const Text(
                                'Uri ng Contact',
                                style: TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 56,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: _surfaceContainerColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(() => _selectedRole = 'family'),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: _selectedRole == 'family'
                                                ? _primaryContainerColor
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Kapamilya',
                                            style: TextStyle(
                                              fontFamily: 'Nunito Sans',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: _selectedRole == 'family'
                                                  ? Colors.white
                                                  : _textSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(() => _selectedRole = 'volunteer'),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: _selectedRole == 'volunteer'
                                                ? _primaryContainerColor
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Volunteer',
                                            style: TextStyle(
                                              fontFamily: 'Nunito Sans',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: _selectedRole == 'volunteer'
                                                  ? Colors.white
                                                  : _textSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Submit/Finish Button
                              ElevatedButton.icon(
                                onPressed: _isLoading ? null : _saveAndFinish,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.secondaryAmber,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 2,
                                ),
                                icon: _isLoading
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Icon(Icons.check_circle),
                                label: const Text(
                                  'I-TAPOS ANG SETUP',
                                  style: TextStyle(
                                    fontFamily: 'Nunito Sans',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
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
