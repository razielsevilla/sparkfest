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
  static const Color _secondaryFixedColor = Color(0xFFFFDDB8); // secondary-fixed
  static const Color _primaryFixedColor = Color(0xFF9CF2E8); // primary-fixed
  static const Color _onSecondaryFixedColor = Color(0xFF2A1700); // on-secondary-fixed
  static const Color _onPrimaryFixedColor = Color(0xFF00201d); // on-primary-fixed
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
    // Default seed members to match design template if list is empty
    _additionalMembers.addAll([
      TrustedCircleMember(
        id: 'member_default_1',
        seniorProfileId: widget.seniorProfile.id,
        name: 'Maria Santos',
        relationship: 'Anak',
        phoneNumber: '0917 123 4567',
        role: 'family',
      ),
      TrustedCircleMember(
        id: 'member_default_2',
        seniorProfileId: widget.seniorProfile.id,
        name: 'Juan Dela Cruz',
        relationship: 'Volunteer',
        phoneNumber: '0918 987 6543',
        role: 'volunteer',
      ),
    ]);
  }

  void _addMemberToList() {
    if (!_formKey.currentState!.validate()) return;

    final memberId = 'member_${DateTime.now().millisecondsSinceEpoch}';
    final relationshipLabel = _relationships.firstWhere((r) => r['value'] == _selectedRelationship)['label']!;

    final newMember = TrustedCircleMember(
      id: memberId,
      seniorProfileId: widget.seniorProfile.id,
      name: _nameController.text.trim(),
      relationship: relationshipLabel,
      phoneNumber: _phoneController.text.trim(),
      role: _selectedRole,
    );

    setState(() {
      _additionalMembers.add(newMember);
      _nameController.clear();
      _phoneController.clear();
      _selectedRelationship = 'anak';
      _selectedRole = 'family';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Naidagdag ang miyembro sa listahan!'),
        backgroundColor: _primaryColor,
      ),
    );
  }

  void _removeMember(int index) {
    setState(() {
      _additionalMembers.removeAt(index);
    });
  }

  void _saveAndFinish() async {
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

      // 3. Save any additional members
      for (var member in _additionalMembers) {
        // Skip default mock items when committing to real Firestore
        if (member.id.startsWith('member_default_')) continue;
        await widget.appState.inviteCircleMember(member);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Matagumpay na na-set up ang profile at circle!'),
            backgroundColor: _primaryColor,
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
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
        appBar: AppBar(
          backgroundColor: _backgroundColor,
          elevation: 0,
          leadingWidth: 200,
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
                  'Magandang araw!',
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
              icon: const Icon(Icons.settings_outlined, color: _primaryColor, size: 28),
              onPressed: () {},
            ),
            const SizedBox(width: 16),
          ],
        ),
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
                                style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 16),
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
                                style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 16),
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

                              // I-SALI SA CIRCLE Button
                              OutlinedButton.icon(
                                onPressed: _addMemberToList,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _primaryColor,
                                  side: const BorderSide(color: _primaryColor, width: 2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                icon: const Icon(Icons.person_add),
                                label: const Text(
                                  'I-SALI SA CIRCLE',
                                  style: TextStyle(
                                    fontFamily: 'Nunito Sans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // List Zone
                    const Text(
                      'Mga Kasapi sa Circle',
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _additionalMembers.length,
                      itemBuilder: (context, index) {
                        final member = _additionalMembers[index];
                        final isFamily = member.role == 'family';
                        final avatarBg = isFamily ? _secondaryFixedColor : _primaryFixedColor;
                        final avatarFg = isFamily ? _onSecondaryFixedColor : _onPrimaryFixedColor;

                        return Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: avatarBg,
                                  child: Icon(
                                    isFamily ? Icons.family_restroom : Icons.volunteer_activism,
                                    color: avatarFg,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        member.name,
                                        style: const TextStyle(
                                          fontFamily: 'Nunito Sans',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${member.relationship} • ${member.phoneNumber}',
                                        style: const TextStyle(
                                          fontFamily: 'Nunito Sans',
                                          fontSize: 14,
                                          color: _textSecondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: _errorColor),
                                  onPressed: () => _removeMember(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Final Setup Button
                    SizedBox(
                      height: 64,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _saveAndFinish,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryAmber,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
