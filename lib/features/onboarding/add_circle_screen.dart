import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/models/senior_profile.dart';
import 'package:gabaysr/models/trusted_circle_member.dart';

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
  final List<TrustedCircleMember> _additionalMembers = [];
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedRole = 'family';
  bool _isLoading = false;

  void _addMemberToList() {
    if (!_formKey.currentState!.validate()) return;

    final memberId = 'member_${DateTime.now().millisecondsSinceEpoch}';
    final newMember = TrustedCircleMember(
      id: memberId,
      seniorProfileId: widget.seniorProfile.id,
      name: _nameController.text.trim(),
      relationship: _relationshipController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      role: _selectedRole,
    );

    setState(() {
      _additionalMembers.add(newMember);
      _nameController.clear();
      _relationshipController.clear();
      _phoneController.clear();
      _selectedRole = 'family';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Naidagdag ang miyembro sa listahan!'),
        backgroundColor: AppTheme.primaryTeal,
      ),
    );
  }

  void _saveAndFinish() async {
    setState(() => _isLoading = true);

    try {
      // 1. Create primary member (the currently logged in user)
      final primaryMemberId = 'member_primary_${DateTime.now().millisecondsSinceEpoch}';
      final primaryMember = TrustedCircleMember(
        id: primaryMemberId,
        seniorProfileId: widget.seniorProfile.id,
        name: 'Primary Monitor', // Default placeholder name for current user
        relationship: 'Pamilya',
        phoneNumber: widget.appState.currentUserPhone ?? '',
        role: 'family',
      );

      // 2. Save senior profile and primary member in Firestore
      await widget.appState.registerSenior(widget.seniorProfile, primaryMember);

      // 3. Save any additional members
      for (var member in _additionalMembers) {
        await widget.appState.inviteCircleMember(member);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Matagumpay na na-set up ang profile at circle!'),
            backgroundColor: AppTheme.primaryTeal,
          ),
        );
        // Pop all onboarding screens to return to main.dart router
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('May error sa pag-save: $e'),
            backgroundColor: AppTheme.alertRed,
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
      data: AppTheme.familyTheme,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Trusted Circle Setup'),
          backgroundColor: AppTheme.primaryTeal,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Trusted Circle',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTeal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Ikaw ay awtomatikong kasama bilang primary monitor. Maaari kang magdagdag ng iba pang miyembro ng pamilya o barangay volunteers.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              if (_additionalMembers.isNotEmpty) ...[
                const Text(
                  'Mga Miyembro na Idaragdag:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _additionalMembers.length,
                  itemBuilder: (context, index) {
                    final member = _additionalMembers[index];
                    return Card(
                      color: AppTheme.backgroundWarm.withAlpha(128),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${member.relationship} (${member.role == 'family' ? 'Family' : 'Volunteer'}) • ${member.phoneNumber}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: AppTheme.alertRed),
                          onPressed: () {
                            setState(() {
                              _additionalMembers.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 32),
              ],

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Magdagdag ng Isa pang Miyembro (Opsyonal)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Pangalan',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          (val == null || val.trim().isEmpty) ? 'Ilagay ang pangalan.' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _relationshipController,
                      decoration: const InputDecoration(
                        labelText: 'Relasyon (e.g. Anak, Kapitbahay, Tanod)',
                        prefixIcon: Icon(Icons.family_restroom_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          (val == null || val.trim().isEmpty) ? 'Ilagay ang relasyon.' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone_android_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          (val == null || val.trim().isEmpty) ? 'Ilagay ang phone number.' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Papel sa System (Role)',
                        prefixIcon: Icon(Icons.supervised_user_circle_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'family', child: Text('Family Member')),
                        DropdownMenuItem(value: 'volunteer', child: Text('Barangay Volunteer')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedRole = val);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: _addMemberToList,
                      icon: const Icon(Icons.add),
                      label: const Text('ILAGAY SA LISTAHAN'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryTeal,
                        side: const BorderSide(color: AppTheme.primaryTeal),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveAndFinish,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text('I-SAVE AT TAPUSIN ANG SETUP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
