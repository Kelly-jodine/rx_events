import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  const EmployeeDetailsScreen({super.key});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  bool? _statusOverride;
  String? _assignedEvent;

  static const List<String> _demoEvents = [
    'Annual Tech Expo 2026',
    'Tech Conference 2026',
    'Wedding Expo',
    'Summer Music Festival',
  ];

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final employee = arguments is Map<String, String>
        ? arguments
        : const <String, String>{};

    final name = _read(employee, 'name', fallback: 'Not available');
    final email = _read(employee, 'email');
    final phone = _read(employee, 'phone');
    final position = _read(employee, 'position', fallback: 'Not available');
    final department = _read(employee, 'department');
    final joined = _read(employee, 'joined');
    final events = _read(employee, 'events');
    final isActive = _statusOverride ??
        _read(employee, 'status').toLowerCase() == 'active';
    final initials = _initials(name);

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        title: const Text(
          'Employee Details',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileHeader(
                    name: name,
                    position: position,
                    initials: initials,
                    isActive: isActive,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                    'Employee Information',
                    subtitle: 'Personal and contact details',
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(Icons.person_outline, 'Full name', name),
                    _buildInfoRow(
                      Icons.work_outline,
                      'Position',
                      position,
                    ),
                    _buildInfoRow(
                      Icons.business_outlined,
                      'Department',
                      department,
                    ),
                    _buildInfoRow(Icons.email_outlined, 'Email', email),
                    _buildInfoRow(Icons.phone_outlined, 'Phone', phone),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                    'Work Information',
                    subtitle: 'Employment and event assignments',
                    icon: Icons.event_note_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.calendar_month_outlined,
                      'Date joined',
                      joined,
                    ),
                    _buildInfoRow(
                      Icons.event_available_outlined,
                      'Assigned events',
                      events,
                    ),
                    if (_assignedEvent != null)
                      _buildInfoRow(
                        Icons.assignment_turned_in_outlined,
                        'Selected event',
                        _assignedEvent!,
                        valueColor: context.accent,
                      ),
                    _buildInfoRow(
                      Icons.verified_user_outlined,
                      'Current status',
                      isActive ? 'Active' : 'Inactive',
                      valueColor:
                          isActive ? context.accent : context.textMuted,
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildActionButton(
                    label: 'Assign Event',
                    icon: Icons.add_task_rounded,
                    onPressed: _assignEvent,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _toggleStatus,
                    icon: Icon(
                      isActive
                          ? Icons.person_off_outlined
                          : Icons.person_add_alt_1_outlined,
                    ),
                    label: Text(
                      isActive ? 'Deactivate Employee' : 'Activate Employee',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          isActive ? context.dangerText : context.accent,
                      side: BorderSide(
                        color: isActive
                            ? Colors.red.shade300
                            : AppColors.primary.withValues(alpha: 0.55),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Changes to event assignment and status apply to this session only.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.textMuted,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader({
    required String name,
    required String position,
    required String initials,
    required bool isActive,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.86),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.7),
                width: 2,
              ),
            ),
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            position,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatusBadge(isActive ? 'Active employee' : 'Inactive employee'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title, {
    required String subtitle,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: context.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: context.accent, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: context.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  color: context.textMuted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: context.tintSurface.withValues(alpha: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: context.tintSurface.withValues(alpha: 0.75),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: context.accent),
          const SizedBox(width: 12),
          SizedBox(
            width: 112,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                label,
                style: TextStyle(
                  color: context.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              softWrap: true,
              style: TextStyle(
                color: valueColor ?? context.textPrimary,
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 1,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.circle,
            size: 8,
            color: Color(0xFF8FE3B0),
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _assignEvent() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: context.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Assign an event',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose an event for this employee.',
                  style: TextStyle(
                    color: context.textMuted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                ..._demoEvents.map((event) {
                  final isSelected = _assignedEvent == event;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: isSelected
                          ? context.accent.withValues(alpha: 0.10)
                          : context.bg,
                      borderRadius: BorderRadius.circular(12),
                      child: ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? context.accent
                                : context.tintSurface,
                          ),
                        ),
                        leading: Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: context.accent,
                        ),
                        title: Text(
                          event,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _assignedEvent = event;
                          });
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Assigned to $event for this session only.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _toggleStatus() {
    final currentIsActive = _statusOverride ??
        _read(_currentEmployee(), 'status').toLowerCase() == 'active';
    final nextIsActive = !currentIsActive;

    setState(() {
      _statusOverride = nextIsActive;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nextIsActive
              ? 'Employee activated for this session only.'
              : 'Employee deactivated for this session only.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Map<String, String> _currentEmployee() {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    return arguments is Map<String, String>
        ? arguments
        : const <String, String>{};
  }

  static String _read(
    Map<String, String> employee,
    String key, {
    String fallback = 'Not available',
  }) {
    final value = employee[key];
    if (value == null) {
      return fallback;
    }

    final text = value.trim();
    return text.isEmpty ? fallback : text;
  }

  static String _initials(String name) {
    if (name.trim().isEmpty || name == 'Not available') {
      return '?';
    }

    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}
