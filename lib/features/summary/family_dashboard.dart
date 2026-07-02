import 'package:flutter/material.dart';
import 'package:gabaysr/core/theme/app_theme.dart';
import 'package:gabaysr/core/services/app_state.dart';
import 'package:gabaysr/models/checkin.dart';
import 'package:gabaysr/models/scam_check.dart';
import 'package:gabaysr/models/trusted_circle_member.dart';
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
  static const double _horizontalPadding = 24.0;

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
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 24.0),
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

                      // Styled/Segmented AI Summary text
                      _buildSummaryContent(latestSummary),
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

  // Parses and returns a list of formatted widgets for the Weekly AI Summary card
  Widget _buildSummaryContent(String summaryText) {
    if (summaryText == "Wala pang sapat na logs ngayong linggo upang makabuo ng AI summary.") {
      return Text(
        summaryText,
        style: const TextStyle(
          fontFamily: 'Nunito Sans',
          fontSize: 18,
          color: _textPrimaryColor,
          height: 1.6,
        ),
      );
    }

    final segments = _parseSummary(summaryText);

    if (segments.length <= 1) {
      return Text(
        summaryText,
        style: const TextStyle(
          fontFamily: 'Nunito Sans',
          fontSize: 18,
          color: _textPrimaryColor,
          height: 1.6,
        ),
      );
    }

    return Column(
      children: segments.map((seg) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: seg.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  seg.icon,
                  color: seg.iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seg.title,
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: seg.iconColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      seg.content,
                      style: const TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 16,
                        color: _textPrimaryColor,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
          return const Center(
            child: EmptyStateView(
              icon: Icons.calendar_today_outlined,
              title: 'Wala pang check-ins na naitala.',
              subtitle: 'Dito makikita ang araw-araw na mood at kalagayan ni Lola/Lolo.',
            ),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 24.0),
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
            ),
          ),
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
          return const Center(
            child: EmptyStateView(
              icon: Icons.shield_outlined,
              title: 'Wala pang naitatalang scam checks.',
              subtitle: 'Ligtas ang device ni Lola/Lolo. Dito lalabas ang mga kahina-hinalang mensahe.',
            ),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 24.0),
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
            ),
          ),
        );
      },
    );
  }

  // Tab 4: Alerts Center
  Widget _buildAlertsTab() {
    final alerts = widget.appState.alerts;

    if (alerts.isEmpty) {
      return const Center(
        child: EmptyStateView(
          icon: Icons.notifications_none_outlined,
          title: 'Walang mga babala o alerts ngayon.',
          subtitle: 'Lahat ay maayos at ligtas. Aabisuhan ka namin kapag may kailangang pansinin.',
        ),
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 24.0),
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
        ),
      ),
    );
  }

  // Tab 5: Trusted Circle Members List
  Widget _buildCircleTab() {
    final circle = widget.appState.trustedCircle;
    final senior = widget.appState.activeSenior;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Column(
          children: [
            if (senior != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(_horizontalPadding, 24, _horizontalPadding, 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddCircleMemberBottomSheet(context, senior.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text(
                      'MAGDAGDAG NG KASAPI SA CIRCLE',
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: circle.isEmpty
                  ? const Center(
                      child: EmptyStateView(
                        icon: Icons.people_outline,
                        title: 'Walang mga kasapi sa Circle.',
                        subtitle: 'Magdagdag ng mga kapamilya o volunteer upang magtulungan sa paggabay.',
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(_horizontalPadding, 8, _horizontalPadding, 24),
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
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCircleMemberBottomSheet(BuildContext context, String seniorId) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String relationship = 'Anak';
    String role = 'family';
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Magdagdag ng Kasapi sa Circle',
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Pangalan Input
                    const Text(
                      'Pangalan',
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameCtrl,
                      style: const TextStyle(fontFamily: 'Nunito Sans'),
                      decoration: InputDecoration(
                        hintText: 'Halimbawa: Maria Santos',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Ilagay ang pangalan' : null,
                    ),
                    const SizedBox(height: 16),

                    // Numero ng Telepono Input
                    const Text(
                      'Numero ng Telepono',
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontFamily: 'Nunito Sans'),
                      decoration: InputDecoration(
                        hintText: 'Halimbawa: 0917XXXXXXX',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Ilagay ang numero' : null,
                    ),
                    const SizedBox(height: 16),

                    // Relasyon Dropdown
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                initialValue: relationship,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Anak', child: Text('Anak')),
                                  DropdownMenuItem(value: 'Asawa', child: Text('Asawa')),
                                  DropdownMenuItem(value: 'Apo', child: Text('Apo')),
                                  DropdownMenuItem(value: 'Kaibigan', child: Text('Kaibigan')),
                                  DropdownMenuItem(value: 'Volunteer', child: Text('Volunteer')),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setModalState(() => relationship = val);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Uri',
                                style: TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                initialValue: role,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'family', child: Text('Kapamilya')),
                                  DropdownMenuItem(value: 'volunteer', child: Text('Volunteer')),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setModalState(() => role = val);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Add Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          final newMember = TrustedCircleMember(
                            id: 'member_${DateTime.now().millisecondsSinceEpoch}',
                            seniorProfileId: seniorId,
                            name: nameCtrl.text.trim(),
                            relationship: relationship,
                            phoneNumber: phoneCtrl.text.trim(),
                            role: role,
                          );
                          await widget.appState.inviteCircleMember(newMember);
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Matagumpay na naidagdag ang bagong kasapi!'),
                                backgroundColor: _primaryColor,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'I-SAVE SA CIRCLE',
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
            );
          },
        );
      },
    );
  }

  // Helper method to parse AI generated summary text into distinct segments
  List<SummarySegment> _parseSummary(String summaryText) {
    final sentences = summaryText
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final List<String> moodSentences = [];
    final List<String> activitySentences = [];
    final List<String> safetySentences = [];
    final List<String> generalSentences = [];

    for (final sentence in sentences) {
      final lower = sentence.toLowerCase();
      if (lower.contains('scam') ||
          lower.contains('banta') ||
          lower.contains('hinala') ||
          lower.contains('babala') ||
          lower.contains('alert') ||
          lower.contains('panganib') ||
          lower.contains('delikado')) {
        safetySentences.add(sentence);
      } else if (lower.contains('masaya') ||
          lower.contains('maganda') ||
          lower.contains('malungkot') ||
          lower.contains('okay') ||
          lower.contains('naging') ||
          lower.contains('ramdam') ||
          lower.contains('pakiramdam') ||
          lower.contains('mood') ||
          lower.contains('kalagayan') ||
          lower.contains('malusog')) {
        moodSentences.add(sentence);
      } else if (lower.contains('ginawa') ||
          lower.contains('nagpahinga') ||
          lower.contains('circle') ||
          lower.contains('kasapi') ||
          lower.contains('check-in') ||
          lower.contains('aktibidad') ||
          lower.contains('lakad') ||
          lower.contains('kain') ||
          lower.contains('tulog') ||
          lower.contains('pamilya')) {
        activitySentences.add(sentence);
      } else {
        generalSentences.add(sentence);
      }
    }

    final List<SummarySegment> segments = [];

    if (moodSentences.isNotEmpty) {
      segments.add(SummarySegment(
        category: 'mood',
        icon: Icons.emoji_emotions_outlined,
        iconColor: const Color(0xFF0F766E), // teal
        backgroundColor: const Color(0xFFF0FDFA),
        title: 'Mood at Emosyon',
        content: moodSentences.join(' '),
      ));
    }

    if (activitySentences.isNotEmpty) {
      segments.add(SummarySegment(
        category: 'activity',
        icon: Icons.directions_run_outlined,
        iconColor: const Color(0xFFD97706), // amber
        backgroundColor: const Color(0xFFFEF3C7),
        title: 'Aktibidad at Kalusugan',
        content: activitySentences.join(' '),
      ));
    }

    if (safetySentences.isNotEmpty) {
      segments.add(SummarySegment(
        category: 'safety',
        icon: Icons.shield_outlined,
        iconColor: const Color(0xFFDC2626), // red
        backgroundColor: const Color(0xFFFEE2E2),
        title: 'Seguridad at Scam Checks',
        content: safetySentences.join(' '),
      ));
    }

    if (generalSentences.isNotEmpty) {
      segments.add(SummarySegment(
        category: 'general',
        icon: Icons.info_outline,
        iconColor: const Color(0xFF005C55),
        backgroundColor: const Color(0xFFF0FDFA),
        title: 'Iba pang Impormasyon',
        content: generalSentences.join(' '),
      ));
    }

    return segments;
  }
}

// Representing a parsed bento-style AI Weekly Summary segment
class SummarySegment {
  final String category;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String content;

  SummarySegment({
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.content,
  });
}

// Reusable empty state view to consistently present information when lists are empty
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005C55);
    const Color textPrimaryColor = Color(0xFF1B1B1D);
    const Color textSecondaryColor = Color(0xFF3E4947);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textPrimaryColor,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 16,
                  color: textSecondaryColor,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
