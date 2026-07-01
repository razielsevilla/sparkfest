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
          SnackBar(content: Text('May error sa pagsusuri: $e'), backgroundColor: AppTheme.alertRed),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.seniorTheme,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundWarm,
        appBar: AppBar(
          title: const Text('Scam Checker'),
          backgroundColor: AppTheme.primaryTeal,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showDevSettings,
              tooltip: 'Gemini API Key Setup',
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Suriin ang kahina-hinalang Mensahe',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'I-paste ang SMS o text dito para malaman kung ito ay ligtas o isang scam.',
                style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Message Input
              TextField(
                controller: _messageController,
                maxLines: 5,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'I-paste o i-type ang mensahe dito...',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),

              // Sender Number Input (Optional)
              TextField(
                controller: _senderController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Numero ng nagpadala (opsyonal)',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _checkMessage,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('I-CHECK ANG MENSAHE'),
              ),

              if (_result != null) ...[
                const SizedBox(height: 32),
                _buildResultCard(),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final risk = _result!['riskLevel'] ?? 'Katamtaman';
    final reason = _result!['reasoning'] ?? '';
    final action = _result!['recommendedAction'] ?? '';

    Color cardColor;
    Color textColor;
    IconData icon;
    String title;

    if (risk == 'Mataas') {
      cardColor = AppTheme.alertRed;
      textColor = Colors.white;
      icon = Icons.warning_amber_rounded;
      title = '⚠️ MATAAS NA PANGANIB (SCAM)';
    } else if (risk == 'Katamtaman') {
      cardColor = AppTheme.secondaryAmber;
      textColor = Colors.white;
      icon = Icons.info_outline;
      title = '💡 HINDI SIGURADO (MAG-INGAT)';
    } else {
      cardColor = Colors.green.shade700;
      textColor = Colors.white;
      icon = Icons.check_circle_outline;
      title = '✅ MABABANG RISK (LIGTAS)';
    }

    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: textColor, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white38, height: 24),
            Text(
              'Dahilan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor.withAlpha(200)),
            ),
            const SizedBox(height: 4),
            Text(
              reason,
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Dapat Gawin:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor.withAlpha(200)),
            ),
            const SizedBox(height: 4),
            Text(
              action,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            ),
            if (risk == 'Mataas') ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.notifications_active, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Awtomatikong na-notify ang iyong Trusted Circle.',
                        style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
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
                  const SnackBar(content: Text('Nai-save ang Gemini API Key!'), backgroundColor: AppTheme.primaryTeal),
                );
              },
              child: const Text('I-SAVE'),
            )
          ],
        );
      },
    );
  }
}
