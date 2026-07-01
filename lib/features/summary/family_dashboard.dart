import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/models/checkin.dart';
import 'package:gabaysr/models/scam_check.dart';
import 'package:intl/intl.dart';
import 'package:gabaysr/features/checkin/gabay_home_header.dart';

class FamilyDashboard extends StatefulWidget {
  final AppState appState;

  const FamilyDashboard({super.key, required this.appState});

  @override
  State<FamilyDashboard> createState() => _FamilyDashboardState();
}

class _FamilyDashboardState extends State<FamilyDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSummaryLoading = false;

  // Design tokens from Stitch export
  static const Color _backgroundColor = Color(0xFFFCF8FB);
  static const Color _primaryColor = Color(0xFF005C55); // primary
  static const Color _textPrimaryColor = Color(0xFF1B1B1D); // on-surface
  static const Color _textSecondaryColor = Color(0xFF3E4947); // on-surface-variant
  static const Color _errorColor = Color(0xFFBA1A1A); // error
  static const Color _errorContainerColor = Color(0xFFFFDAD6); // error-container

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update selected tab styles
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateSummary() async {
    setState(() => _isSummaryLoading = true);
    try {
      final senior = widget.appState.activeSenior;
      if (senior != null) {
        await widget.appState.generateAndSaveWeeklySummary(senior.fullName);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Matagumpay na nagenerate ang summary!'),
              backgroundColor: _primaryColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('May error sa pag-generate: $e'),
            backgroundColor: _errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSummaryLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.familyTheme.copyWith(
        scaffoldBackgroundColor: _backgroundColor,
      ),
      child: ListenableBuilder(
        listenable: widget.appState,
        builder: (context, _) {
          final alertsCount = widget.appState.alerts.where((a) => !a.resolved).length;

          return Scaffold(
            appBar: GabayHomeHeader(
              appState: widget.appState,
              leadingIcon: Icons.family_restroom,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: _primaryColor,
                    indicatorWeight: 3,
                    labelColor: _primaryColor,
                    unselectedLabelColor: _textSecondaryColor,
                    labelStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: [
                      const Tab(text: 'Summary'),
                      const Tab(text: 'History'),
                      const Tab(text: 'Scam Logs'),
                      Tab(
                        child: Row(
                          children: [
                            const Text('Alerts'),
                            if (alertsCount > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _errorColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$alertsCount',
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                      const Tab(text: 'Circle'),
                    ],
                  ),
                ),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(),
                _buildHistoryTab(),
                _buildScamLogsTab(),
                _buildAlertsTab(),
                _buildCircleTab(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                widget.appState.setAppMode(AppMode.senior);
              },
              backgroundColor: _primaryColor,
              child: const Icon(Icons.elderly, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  // Tab 1: Weekly AI Summary Dashboard
  Widget _buildSummaryTab() {
    final latestSummary = widget.appState.latestWeeklySummary ??
        "Wala pang sapat na logs ngayong linggo upang makabuo ng AI summary.";

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Weekly AI Summary Bento Card
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.auto_awesome, color: _primaryColor),
                              SizedBox(width: 8),
                              Text(
                                'Weekly AI Summary',
                                style: TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _textPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            DateFormat('MMM d').format(DateTime.now()),
                            style: const TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 14,
                              color: _textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Real AI Summary text
                      Text(
                        latestSummary,
                        style: const TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 18,
                          color: _textPrimaryColor,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Generator button
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: _isSummaryLoading ? null : _generateSummary,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isSummaryLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  'I-GENERATE ANG WEEKLY SUMMARY',
                                  style: TextStyle(
                                    fontFamily: 'Nunito Sans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tab 2: Check-In Logs History list
  Widget _buildHistoryTab() {
    final senior = widget.appState.activeSenior;
    if (senior == null) {
      return const Center(child: Text('Wala pang senior na napili.'));
    }

    return StreamBuilder<List<CheckIn>>(
      stream: widget.appState.databaseService.streamCheckIns(senior.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final checkIns = snapshot.data ?? [];
        if (checkIns.isEmpty) {
          return const Center(child: Text('Wala pang check-ins na naitala.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: checkIns.length,
          itemBuilder: (context, index) {
            final c = checkIns[index];
            return Card(
              elevation: 0,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ListTile(
                leading: Text(
                  c.mood == 'Masaya'
                      ? '😊'
                      : c.mood == 'Okay lang'
                          ? '😐'
                          : '😢',
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(
                  'Mood: ${c.mood}',
                  style: const TextStyle(fontFamily: 'Nunito Sans', fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Mga ginawa: ${c.activities.join(", ")}\nMensahe: ${c.note ?? "Walang mensahe"}',
                  style: const TextStyle(fontFamily: 'Nunito Sans'),
                ),
                trailing: Text(
                  DateFormat('MM/dd').format(c.createdAt),
                  style: const TextStyle(fontFamily: 'Nunito Sans', color: _textSecondaryColor),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Tab 3: Scam Check History logs
  Widget _buildScamLogsTab() {
    final senior = widget.appState.activeSenior;
    if (senior == null) {
      return const Center(child: Text('Wala pang senior na napili.'));
    }

    return StreamBuilder<List<ScamCheck>>(
      stream: widget.appState.databaseService.streamScamChecks(senior.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final logs = snapshot.data ?? [];
        if (logs.isEmpty) {
          return const Center(child: Text('Wala pang naitatalang scam checks.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            final isHigh = log.riskLevel == 'Mataas';

            return Card(
              elevation: 0,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ListTile(
                leading: Icon(
                  isHigh ? Icons.warning : Icons.shield_outlined,
                  color: isHigh ? _errorColor : _primaryColor,
                ),
                title: Text(
                  log.riskLevel.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.bold,
                    color: isHigh ? _errorColor : _primaryColor,
                  ),
                ),
                subtitle: Text(
                  'Mensahe: "${log.rawMessageText}"\nSender: ${log.senderNumber ?? "Hindi kilala"}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontFamily: 'Nunito Sans'),
                ),
                trailing: Text(
                  DateFormat('MM/dd').format(log.createdAt),
                  style: const TextStyle(fontFamily: 'Nunito Sans', color: _textSecondaryColor),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Tab 4: Alerts Center
  Widget _buildAlertsTab() {
    final alerts = widget.appState.alerts;

    if (alerts.isEmpty) {
      return const Center(child: Text('Walang mga babala o alerts ngayon.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];

        return Card(
          elevation: 0,
          color: alert.resolved ? Colors.grey.shade100 : _errorContainerColor.withValues(alpha: 0.2),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: alert.resolved ? Colors.grey.shade200 : _errorColor.withValues(alpha: 0.1)),
          ),
          child: ListTile(
            leading: Icon(
              Icons.warning,
              color: alert.resolved ? Colors.grey : _errorColor,
            ),
            title: Text(
              alert.message,
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.bold,
                color: alert.resolved ? Colors.grey : _textPrimaryColor,
                decoration: alert.resolved ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              'Nalika: ${DateFormat('MM/dd HH:mm').format(alert.createdAt)}',
              style: const TextStyle(fontFamily: 'Nunito Sans'),
            ),
            trailing: alert.resolved
                ? const Icon(Icons.check, color: Colors.green)
                : TextButton(
                    onPressed: () => widget.appState.resolveAlert(alert.id),
                    child: const Text('RESOLBAHAN'),
                  ),
          ),
        );
      },
    );
  }

  // Tab 5: Trusted Circle Members List
  Widget _buildCircleTab() {
    final circle = widget.appState.trustedCircle;

    if (circle.isEmpty) {
      return const Center(child: Text('Walang mga kasapi sa Circle.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: circle.length,
      itemBuilder: (context, index) {
        final m = circle[index];
        final isFamily = m.role == 'family';

        return Card(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isFamily ? Colors.amber.shade100 : Colors.teal.shade100,
              child: Icon(
                isFamily ? Icons.family_restroom : Icons.volunteer_activism,
                color: isFamily ? Colors.amber.shade900 : Colors.teal.shade900,
              ),
            ),
            title: Text(
              m.name,
              style: const TextStyle(fontFamily: 'Nunito Sans', fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Relasyon: ${m.relationship} • Uri: ${m.role == "family" ? "Kapamilya" : "Volunteer"}',
              style: const TextStyle(fontFamily: 'Nunito Sans'),
            ),
            trailing: Text(
              m.phoneNumber,
              style: const TextStyle(fontFamily: 'Nunito Sans', color: _textSecondaryColor),
            ),
          ),
        );
      },
    );
  }
}
