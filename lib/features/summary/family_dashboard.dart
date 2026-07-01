import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/models/checkin.dart';
import 'package:gabaysr/models/scam_check.dart';
import 'package:gabaysr/models/alert.dart';
import 'package:gabaysr/models/trusted_circle_member.dart';
import 'package:intl/intl.dart';

class FamilyDashboard extends StatefulWidget {
  final AppState appState;

  const FamilyDashboard({super.key, required this.appState});

  @override
  State<FamilyDashboard> createState() => _FamilyDashboardState();
}

class _FamilyDashboardState extends State<FamilyDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatLastCheckIn(DateTime? date) {
    if (date == null) return "Walang naitalang check-in";
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return "Check-in ngayon";
    if (diff.inDays == 1) return "Kahapon";
    return "${diff.inDays} araw ang nakalipas";
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.familyTheme,
      child: ListenableBuilder(
        listenable: widget.appState,
        builder: (context, _) {
          final senior = widget.appState.activeSenior;
          final alertsCount = widget.appState.alerts.where((a) => !a.resolved).length;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppTheme.primaryTeal,
              foregroundColor: Colors.white,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(senior?.fullName ?? 'Family Dashboard', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    _formatLastCheckIn(senior?.lastCheckInDate),
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => widget.appState.logOut(),
                  tooltip: 'Sign Out',
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppTheme.secondaryAmber,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
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
                            decoration: const BoxDecoration(color: AppTheme.alertRed, shape: BoxShape.circle),
                            child: Text('$alertsCount', style: const TextStyle(fontSize: 10, color: Colors.white)),
                          )
                        ]
                      ],
                    ),
                  ),
                  const Tab(text: 'Circle'),
                ],
              ),
            ),
            body: senior == null
                ? const Center(child: Text('Walang active senior profile.'))
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSummaryTab(),
                      _buildHistoryTab(),
                      _buildScamLogsTab(),
                      _buildAlertsTab(),
                      _buildCircleTab(),
                    ],
                  ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                // Quickly switch to Senior Mode for simulator check-ins
                widget.appState.setAppMode(AppMode.senior);
              },
              backgroundColor: AppTheme.primaryTeal,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.elderly),
              label: const Text('SENIOR MODE'),
            ),
          );
        },
      ),
    );
  }

  // TAB 1: Companionship AI Summary
  Widget _buildSummaryTab() {
    final senior = widget.appState.activeSenior;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.assistant_outlined, color: AppTheme.primaryTeal, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        'Weekly AI Summary',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    'Ulat ng well-being ni ${senior?.fullName ?? 'Lola/Lolo'} ngayong linggo:',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  // Render a warm summary text
                  const Text(
                    'Si Lola Luz ay naging masaya sa pangkalahatan ngayong linggo. Nakipag-usap siya sa kanyang pamilya at nag-ehersisyo nang regular. Mayroong isang kahina-hinalang mensahe na na-scan ngunit napanatili natin ang kanyang kaligtasan. Patuloy na kumustahin si Lola!',
                    style: TextStyle(fontSize: 16, height: 1.5, color: AppTheme.textPrimary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: AppTheme.backgroundWarm.withAlpha(80),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.primaryTeal),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tandaan: Ang AI summaries ay gabay lamang upang masundan ang mood ng senior at hindi kapalit ng personal na ugnayan.',
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // TAB 2: Check-in History
  Widget _buildHistoryTab() {
    final senior = widget.appState.activeSenior!;
    return StreamBuilder<List<CheckIn>>(
      stream: widget.appState.databaseService.streamCheckIns(senior.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final checkIns = snapshot.data ?? [];
        if (checkIns.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('Walang check-in records si Lola/Lolo sa nakaraang mga araw.'),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: checkIns.length,
          itemBuilder: (context, index) {
            final checkIn = checkIns[index];
            String emoji = '😐';
            Color moodColor = AppTheme.secondaryAmber;
            if (checkIn.mood == 'Masaya') {
              emoji = '😊';
              moodColor = Colors.green;
            } else if (checkIn.mood == 'Malungkot') {
              emoji = '😢';
              moodColor = AppTheme.alertRed;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: moodColor.withAlpha(40),
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
                title: Text(
                  DateFormat('MMMM dd, yyyy (EEEE)').format(checkIn.createdAt),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    if (checkIn.activities.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        children: checkIn.activities
                            .map((a) => Chip(
                                  label: Text(a, style: const TextStyle(fontSize: 11)),
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ))
                            .toList(),
                      ),
                    if (checkIn.note != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '"${checkIn.note}"',
                        style: const TextStyle(fontStyle: FontStyle.italic, color: AppTheme.textSecondary),
                      ),
                    ]
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // TAB 3: Scam checks history logs
  Widget _buildScamLogsTab() {
    final senior = widget.appState.activeSenior!;
    return StreamBuilder<List<ScamCheck>>(
      stream: widget.appState.databaseService.streamScamChecks(senior.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final checks = snapshot.data ?? [];
        if (checks.isEmpty) {
          return const Center(child: Text('Wala pang na-scan na mensahe ang senior.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: checks.length,
          itemBuilder: (context, index) {
            final log = checks[index];
            Color chipColor = Colors.green;
            if (log.riskLevel == 'Mataas') {
              chipColor = AppTheme.alertRed;
            } else if (log.riskLevel == 'Katamtaman') {
              chipColor = AppTheme.secondaryAmber;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM dd, yyyy hh:mm a').format(log.createdAt),
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: chipColor, borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            log.riskLevel.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mensahe:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: 13),
                    ),
                    Text(
                      log.rawMessageText,
                      style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                    const Divider(height: 20),
                    Text(
                      'Paliwanag:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: 13),
                    ),
                    Text(log.reasoning, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // TAB 4: Alerts and resolve flags
  Widget _buildAlertsTab() {
    final senior = widget.appState.activeSenior!;
    return StreamBuilder<List<Alert>>(
      stream: widget.appState.databaseService.streamAlertsForSenior(senior.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final alerts = snapshot.data ?? [];
        final activeAlerts = alerts.where((a) => !a.resolved).toList();

        if (activeAlerts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                SizedBox(height: 12),
                Text('Ligtas si Lola/Lolo. Walang aktibong alert sa ngayon.'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: activeAlerts.length,
          itemBuilder: (context, index) {
            final alert = activeAlerts[index];
            return Card(
              color: AppTheme.alertRed.withAlpha(20),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppTheme.alertRed, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppTheme.alertRed, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            alert.message,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM dd, hh:mm a').format(alert.createdAt),
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            widget.appState.resolveAlert(alert.id);
                          },
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('RESOLBAHAN'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(120, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // TAB 5: Trusted Circle Members
  Widget _buildCircleTab() {
    final senior = widget.appState.activeSenior!;
    return StreamBuilder<List<TrustedCircleMember>>(
      stream: widget.appState.databaseService.streamTrustedCircle(senior.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final members = snapshot.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            final isPrimary = member.phoneNumber == widget.appState.currentUserPhone;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryTeal.withAlpha(30),
                  child: const Icon(Icons.person, color: AppTheme.primaryTeal),
                ),
                title: Row(
                  children: [
                    Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (isPrimary) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppTheme.primaryTeal.withAlpha(40), borderRadius: BorderRadius.circular(4)),
                        child: const Text('Ikaw', style: TextStyle(fontSize: 10, color: AppTheme.primaryTeal, fontWeight: FontWeight.bold)),
                      )
                    ]
                  ],
                ),
                subtitle: Text('${member.relationship} (${member.role == 'family' ? 'Family' : 'Volunteer'})'),
                trailing: Text(member.phoneNumber, style: const TextStyle(color: Colors.grey)),
              ),
            );
          },
        );
      },
    );
  }
}
