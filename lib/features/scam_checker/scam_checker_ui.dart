import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/core/services/gemini_service.dart';
import 'package:gabaysr/models/scam_check.dart';
import 'package:gabaysr/models/alert.dart';

class ScamCheckerUi extends StatefulWidget {
  final AppState appState;

  const ScamCheckerUi({super.key, required this.appState});

  @override
  State<ScamCheckerUi> createState() => _ScamCheckerUiState();
}

class _ScamCheckerUiState extends State<ScamCheckerUi> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _senderController = TextEditingController();
  bool _isLoading = false;

  Map<String, String>? _result; // Holds riskLevel, reasoning, recommendedAction

  // API Key state (development settings integration)
  static String? _devApiKey;

  // Design tokens from Stitch export
  static const Color _backgroundColor = Color(0xFFFAF8F5);
  static const Color _primaryColor = Color(0xFF005C55); // primary
  static const Color _primaryContainerColor = Color(0xFF0F766E); // primary-container
  static const Color _textPrimaryColor = Color(0xFF1B1B1D); // on-surface
  static const Color _textSecondaryColor = Color(0xFF3E4947); // on-surface-variant
  static const Color _errorColor = Color(0xFFBA1A1A); // error
  static const Color _errorContainerColor = Color(0xFFFFDAD6); // error-container
  static const Color _onErrorContainerColor = Color(0xFF93000A); // on-error-container
  static const Color _amberColor = Color(0xFFF59E0B); // warning amber

  void _checkMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    final aiService = GeminiService(apiKey: _devApiKey);
    final sender = _senderController.text.trim().isEmpty ? null : _senderController.text.trim();

    try {
      final res = await aiService.checkScamMessage(text, senderNumber: sender);

      // Save check log in Firestore
      final checkId = 'scam_${DateTime.now().millisecondsSinceEpoch}';
      final scamLog = ScamCheck(
        id: checkId,
        seniorProfileId: widget.appState.activeSenior?.id ?? 'unknown',
        submittedBy: widget.appState.currentUserPhone ?? 'self',
        rawMessageText: text,
        senderNumber: sender,
        riskLevel: res['riskLevel'] ?? 'Katamtaman',
        reasoning: res['reasoning'] ?? '',
        recommendedAction: res['recommendedAction'] ?? '',
        createdAt: DateTime.now(),
      );
      await widget.appState.databaseService.logScamCheck(scamLog);

      // If high risk (Mataas), dispatch a live Alert to Firestore for Trusted Circle
      if (res['riskLevel'] == 'Mataas') {
        final alertId = 'alert_${DateTime.now().millisecondsSinceEpoch}';
        final members = await widget.appState.databaseService.getTrustedCircle(
          widget.appState.activeSenior?.id ?? '',
        );
        final recipientIds = members.map((m) => m.id).toList();

        final alert = Alert(
          id: alertId,
          seniorProfileId: widget.appState.activeSenior?.id ?? '',
          type: 'scam_detected',
          message: '⚠️ Mataas na panganib! May mensaheng natanggap si '
              '${widget.appState.activeSenior?.fullName ?? 'Senior'} na posibleng scam.',
          recipientIds: recipientIds,
          relatedDocId: checkId,
          createdAt: DateTime.now(),
          resolved: false,
        );
        await widget.appState.databaseService.createAlert(alert);
      }

      setState(() {
        _result = res;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('May error sa pagsusuri: $e'),
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

  void _showDevSettings() {
    final TextEditingController keyCtrl = TextEditingController(text: _devApiKey);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Gemini API Setup'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ilagay ang iyong Google AI Studio API Key para sa live Gemini classification.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: keyCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Gemini API Key',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('KANSELAHIN'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _devApiKey = keyCtrl.text.trim();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nai-save ang Gemini API Key!'),
                    backgroundColor: _primaryContainerColor,
                  ),
                );
              },
              child: const Text('I-SAVE'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.seniorTheme.copyWith(
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
          title: const Text(
            'Scam Checker',
            style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: _textSecondaryColor, size: 28),
              onPressed: _showDevSettings,
              tooltip: 'Gemini API Key Setup',
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Checker Inputs Card
                          Card(
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nilalaman ng mensahe',
                                    style: TextStyle(
                                      fontFamily: 'Nunito Sans',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: _textSecondaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _messageController,
                                    maxLines: 5,
                                    style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 16),
                                    decoration: InputDecoration(
                                      hintText: 'I-paste dito ang natanggap na text o mensahe...',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  const Text(
                                    'Numero ng nagpadala',
                                    style: TextStyle(
                                      fontFamily: 'Nunito Sans',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: _textSecondaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _senderController,
                                    keyboardType: TextInputType.phone,
                                    style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 16),
                                    decoration: InputDecoration(
                                      hintText: 'Halimbawa: 0917XXXXXXX',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 64,
                                    child: ElevatedButton.icon(
                                      onPressed: _isLoading ? null : _checkMessage,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _primaryContainerColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      icon: _isLoading
                                          ? const SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: CircularProgressIndicator(
                                                  color: Colors.white, strokeWidth: 2),
                                            )
                                          : const Icon(Icons.search),
                                      label: const Text(
                                        'I-CHECK ANG MENSAHE',
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
                          const SizedBox(height: 24),

                          // Dynamic Result Card
                          if (_result != null) ...[
                            _buildResultCard(),
                            const SizedBox(height: 24),
                          ],

                          // Educational Tips Card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: _primaryContainerColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tips para sa Inyong Seguridad',
                                  style: TextStyle(
                                    fontFamily: 'Nunito Sans',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildTipItem('Huwag mag-click ng mga link mula sa hindi kilalang numero.'),
                                const SizedBox(height: 12),
                                _buildTipItem(
                                    'Ang mga bangko ay hindi kailanman hihingi ng iyong OTP sa pamamagitan ng tawag o text.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Navigation Bar
              Container(
                height: 88,
                padding: const EdgeInsets.only(bottom: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavTab(Icons.home_work, 'Gabay', isActive: true),
                    _buildNavTab(Icons.monitor_heart, 'Kalusugan'),
                    _buildNavTab(Icons.family_restroom, 'Pamilya'),
                    _buildNavTab(Icons.emergency_share, 'SOS', isAlert: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.verified_user, color: _primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 16,
              color: _textPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    final risk = _result!['riskLevel'] ?? 'Katamtaman';
    final reason = _result!['reasoning'] ?? '';
    final action = _result!['recommendedAction'] ?? '';

    Color leftBorderColor;
    Color headerColor;
    IconData icon;
    String title;

    if (risk == 'Mataas') {
      leftBorderColor = _errorColor;
      headerColor = _errorColor;
      icon = Icons.warning;
      title = 'MATAAS NA PANGANIB';
    } else if (risk == 'Katamtaman') {
      leftBorderColor = _amberColor;
      headerColor = _amberColor;
      icon = Icons.info;
      title = 'HINDI SIGURADO';
    } else {
      leftBorderColor = Colors.green.shade700;
      headerColor = Colors.green.shade700;
      icon = Icons.check_circle;
      title = 'MABABANG RISK';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: leftBorderColor, width: 8)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: headerColor, size: 32),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: headerColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              reason,
              style: const TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 16,
                color: _textPrimaryColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _errorContainerColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                action,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _onErrorContainerColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Paalala: Ang pagsusuring ito ay gabay lamang. Manatiling mapagmatyag sa lahat ng oras.',
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: _textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab(IconData icon, String label, {bool isAlert = false, bool isActive = false}) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: _primaryContainerColor,
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: isActive
                  ? Colors.white
                  : (isAlert ? Colors.red : _textSecondaryColor),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 12,
                color: isActive
                    ? Colors.white
                    : (isAlert ? Colors.red : _textSecondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
