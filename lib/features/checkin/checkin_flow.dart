import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/models/checkin.dart';
import 'package:intl/intl.dart';

class CheckInFlow extends StatefulWidget {
  final AppState appState;

  const CheckInFlow({super.key, required this.appState});

  @override
  State<CheckInFlow> createState() => _CheckInFlowState();
}

class _CheckInFlowState extends State<CheckInFlow> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Selected values
  String? _selectedMood; // Masaya / Okay lang / Malungkot
  final List<String> _selectedActivities = [];
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, String>> _moods = [
    {'label': 'Masaya', 'emoji': '😊', 'moodKey': 'Masaya'},
    {'label': 'Okay lang', 'emoji': '😐', 'moodKey': 'Okay lang'},
    {'label': 'Malungkot', 'emoji': '😢', 'moodKey': 'Malungkot'},
  ];

  final List<Map<String, dynamic>> _activities = [
    {'label': 'Nakausap ang pamilya', 'icon': Icons.family_restroom},
    {'label': 'Nag-ehersisyo', 'icon': Icons.directions_run},
    {'label': 'Pumunta sa labas', 'icon': Icons.sunny},
    {'label': 'Nagpahinga', 'icon': Icons.hotel},
  ];

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _selectMood(String mood) {
    setState(() {
      _selectedMood = mood;
    });
    _nextPage();
  }

  void _toggleActivity(String activity) {
    setState(() {
      if (_selectedActivities.contains(activity)) {
        _selectedActivities.remove(activity);
      } else {
        _selectedActivities.add(activity);
      }
    });
  }

  void _submitCheckIn() async {
    if (_selectedMood == null) return;

    setState(() => _isLoading = true);

    final checkInId = 'check_${DateTime.now().millisecondsSinceEpoch}';
    final todayStr = DateFormat('yyyy-MM-DD').format(DateTime.now());
    
    final newCheckIn = CheckIn(
      id: checkInId,
      seniorProfileId: widget.appState.activeSenior?.id ?? 'unknown',
      date: todayStr,
      mood: _selectedMood!,
      activities: _selectedActivities,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await widget.appState.databaseService.logCheckIn(newCheckIn);
      _nextPage(); // Move to confirmation page
      
      // Auto-pop back to home screen after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
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
      data: AppTheme.seniorTheme,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundWarm,
        appBar: AppBar(
          title: const Text('Araw-araw na Check-In'),
          backgroundColor: AppTheme.primaryTeal,
          foregroundColor: Colors.white,
          leading: _currentStep > 0 && _currentStep < 3
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _previousPage,
                )
              : null,
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() => _currentStep = page);
          },
          children: [
            _buildMoodStep(),
            _buildActivityStep(),
            _buildNoteStep(),
            _buildConfirmationStep(),
          ],
        ),
      ),
    );
  }

  // Step 1: Mood Selection
  Widget _buildMoodStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Kumusta ang araw mo ngayon, Lola/Lolo?',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          ..._moods.map((mood) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () => _selectMood(mood['moodKey']!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryTeal,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  elevation: 2,
                  side: const BorderSide(color: AppTheme.primaryTeal, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(mood['emoji']!, style: const TextStyle(fontSize: 48)),
                    const SizedBox(width: 20),
                    Text(
                      mood['label']!,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Step 2: Activity Selection
  Widget _buildActivityStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Ano ang mga ginawa mo ngayon?',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Pumili ng isa o higit pa. Maaari mo ring laktawan ito.',
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              itemCount: _activities.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final activity = _activities[index];
                final isSelected = _selectedActivities.contains(activity['label']);

                return InkWell(
                  onTap: () => _toggleActivity(activity['label']),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryTeal : Colors.white,
                      border: Border.all(color: AppTheme.primaryTeal, width: 2),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          activity['icon'],
                          size: 40,
                          color: isSelected ? Colors.white : AppTheme.primaryTeal,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            activity['label'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppTheme.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _nextPage,
            child: const Text('PATULOY'),
          ),
        ],
      ),
    );
  }

  // Step 3: Optional Text Note
  Widget _buildNoteStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Gusto mo ba mag-iwan ng mensahe sa iyong pamilya?',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'I-type ang iyong mensahe dito (opsyonal).',
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _noteController,
              maxLines: 4,
              maxLength: 280,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'Sumulat ng mensahe dito...',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitCheckIn,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('I-TAPOS ANG CHECK-IN'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _isLoading ? null : _submitCheckIn,
              child: const Text(
                'Laktawan at I-save',
                style: TextStyle(fontSize: 18, color: AppTheme.primaryTeal, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 4: Confirmation Screen
  Widget _buildConfirmationStep() {
    return const Padding(
      padding: EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: AppTheme.primaryTeal),
            SizedBox(height: 24),
            Text(
              'Salamat, Lola/Lolo! 😊',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Ipinaalam na natin sa iyong Trusted Circle na ligtas ka ngayon.',
              style: TextStyle(fontSize: 20, color: AppTheme.textPrimary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
