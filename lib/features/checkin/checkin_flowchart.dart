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

  // Design tokens from Stitch export
  static const Color _backgroundColor = Color(0xFFFAF8F5);
  static const Color _primaryColor = Color(0xFF005C55); // primary
  static const Color _primaryContainerColor = Color(0xFF0F766E); // primary-container
  static const Color _textPrimaryColor = Color(0xFF1B1B1D); // on-surface
  static const Color _textSecondaryColor = Color(0xFF3E4947); // on-surface-variant
  static const Color _surfaceContainerColor = Color(0xFFF0EDEF); // surface-container
  static const Color _borderColor = Color(0xFFBDC9C6); // outline-variant

  // Mood colors & borders
  static const Color _greenSelectedBg = Color(0xFFF0FDF4);
  static const Color _greenSelectedBorder = Color(0xFF16A34A);
  static const Color _amberSelectedBg = Color(0xFFFFFBEB);
  static const Color _amberSelectedBorder = Color(0xFFF59E0B);
  static const Color _redSelectedBg = Color(0xFFFEF2F2);
  static const Color _redSelectedBorder = Color(0xFFDC2626);

  final List<Map<String, String>> _moods = [
    {'label': 'Masaya', 'emoji': '😊', 'moodKey': 'Masaya'},
    {'label': 'Okay lang', 'emoji': '😐', 'moodKey': 'Okay lang'},
    {'label': 'Malungkot', 'emoji': '😢', 'moodKey': 'Malungkot'},
  ];

  final List<Map<String, dynamic>> _activities = [
    {'label': 'Nakausap ang pamilya', 'icon': Icons.family_restroom},
    {'label': 'Nag-ehersisyo', 'icon': Icons.fitness_center},
    {'label': 'Pumunta sa labas', 'icon': Icons.nature_people},
    {'label': 'Nagpahinga', 'icon': Icons.bedtime},
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
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

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
      // Auto-pop back after 3 seconds
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
            backgroundColor: _redSelectedBorder,
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
      data: AppTheme.seniorTheme.copyWith(
        scaffoldBackgroundColor: _backgroundColor,
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress Bar
                Container(
                  width: double.infinity,
                  height: 8,
                  color: _surfaceContainerColor,
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: (_currentStep + 1) / 4.0,
                    child: Container(
                      color: _primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      if (_currentStep > 0 && _currentStep < 3)
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: _textSecondaryColor, size: 28),
                          onPressed: _previousPage,
                        )
                      else
                        const SizedBox(width: 48),
                      const SizedBox(width: 16),
                      Text(
                        _currentStep < 3 ? 'Hakbang ${_currentStep + 1} ng 3' : 'Kumpleto',
                        style: const TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

  // Step 1: Mood Selection Screen
  Widget _buildMoodStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Kumusta ang araw mo ngayon, Lola/Lolo?',
                style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: _primaryColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Piliin ang iyong nararamdaman sa oras na ito.',
                style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 18,
                  color: _textSecondaryColor,
                ),
              ),
              const SizedBox(height: 32),

              ..._moods.map((mood) {
                final isSelected = _selectedMood == mood['moodKey'];
                Color cardBg = Colors.white;
                Color borderCol = Colors.transparent;

                if (isSelected) {
                  if (mood['moodKey'] == 'Masaya') {
                    cardBg = _greenSelectedBg;
                    borderCol = _greenSelectedBorder;
                  } else if (mood['moodKey'] == 'Okay lang') {
                    cardBg = _amberSelectedBg;
                    borderCol = _amberSelectedBorder;
                  } else {
                    cardBg = _redSelectedBg;
                    borderCol = _redSelectedBorder;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: () => _selectMood(mood['moodKey']!),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 90,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: cardBg,
                        border: Border.all(
                          color: borderCol,
                          width: isSelected ? 4 : 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                mood['emoji']!,
                                style: const TextStyle(fontSize: 40),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                mood['label']!,
                                style: const TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: _textPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: borderCol,
                              size: 28,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Step 2: Activities Selection Screen
  Widget _buildActivityStep() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Ano ang mga ginawa mo ngayon?',
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: _textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Piliin ang lahat ng iyong nagawa simula kaninang umaga.',
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 18,
                        color: _textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 32),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _activities.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final act = _activities[index];
                        final isSel = _selectedActivities.contains(act['label']);

                        return InkWell(
                          onTap: () => _toggleActivity(act['label']),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSel ? _primaryContainerColor : Colors.white,
                              border: Border.all(
                                color: isSel ? _primaryContainerColor : _borderColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  act['icon'],
                                  size: 40,
                                  color: isSel ? Colors.white : _primaryColor,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  act['label'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Nunito Sans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSel ? Colors.white : _textPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Skip Option
                    Center(
                      child: TextButton(
                        onPressed: _nextPage,
                        child: const Text(
                          'Wala sa mga ito / Skip',
                          style: TextStyle(
                            fontFamily: 'Nunito Sans',
                            fontSize: 16,
                            color: _primaryColor,
                            decoration: TextDecoration.underline,
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

        // Sticky Footer Continue Button
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))
            ],
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryContainerColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'PATULOY',
                    style: TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Step 3: Optional Text Note Screen
  Widget _buildNoteStep() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Mensahe sa Pamilya',
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: _textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'I-type ang iyong mensahe o nararamdaman dito (opsyonal).',
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 18,
                        color: _textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 32),

                    TextField(
                      controller: _noteController,
                      maxLines: 4,
                      maxLength: 280,
                      style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Sumulat ng mensahe dito...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Sticky Footer Action
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))
            ],
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitCheckIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryContainerColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'I-TAPOS ANG CHECK-IN',
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
      ],
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
            Icon(Icons.check_circle, size: 100, color: _primaryContainerColor),
            SizedBox(height: 24),
            Text(
              'Salamat, Lola/Lolo! 😊',
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Ipinaalam na natin sa iyong Trusted Circle na ligtas ka ngayon.',
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 20,
                color: _textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
