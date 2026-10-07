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

  // Assigned locally for this visit only. Not persisted anywhere.
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

    // A local toggle overrides the passed-in status for this visit only.
    final isActive =
        _statusOverride ?? _read(employee, 'status').toLowerCase() == 'active';

    final initial = name.isEmpty ? '?' : name[0].toUpperCase();

    return Scaffold(
      backgroundColor: context.bg,

      appBar: AppBar(
        title: const Text('Employee Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // PROFILE HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: context.card,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.tintSurface, width: 4),
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: TextStyle(
                          color: context.accent,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    position,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),

                  const SizedBox(height: 12),

                  _buildStatusBadge(isActive ? 'Active' : 'Inactive'),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // PERSONAL INFORMATION
            _buildSectionTitle('Employee Information'),

            const SizedBox(height: 10),

            _buildInfoCard([
              _buildInfoRow(Icons.person_outline, 'Name', name),
              _buildInfoRow(Icons.work_outline, 'Position', position),
              _buildInfoRow(Icons.business_outlined, 'Department', department),
              _buildInfoRow(Icons.email_outlined, 'Email', email),
              _buildInfoRow(Icons.phone_outlined, 'Phone', phone),
            ]),

            const SizedBox(height: 20),

            // WORK INFORMATION
            _buildSectionTitle('Work Information'),

            const SizedBox(height: 10),

            _buildInfoCard([
              _buildInfoRow(Icons.calendar_today_outlined, 'Joined', joined),
              _buildInfoRow(Icons.event_outlined, 'Assigned Events', events),
              if (_assignedEvent != null)
                _buildInfoRow(
                  Icons.add_task_outlined,
                  'Assigned Now',
                  _assignedEvent!,
                ),
              _buildInfoRow(
                Icons.verified_outlined,
                'Status',
                isActive ? 'Active' : 'Inactive',
                valueColor: isActive ? context.accent : context.textMuted,
              ),
            ]),

            const SizedBox(height: 25),

            // ASSIGN EVENT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _assignEvent,
                icon: const Icon(Icons.add_task),
                label: const Text('Assign Event'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ACTIVE / INACTIVE
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _toggleStatus,
                icon: Icon(
                  isActive ? Icons.person_off_outlined : Icons.person_add_alt_1,
                ),
                label: Text(
                  isActive ? 'Deactivate Employee' : 'Activate Employee',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isActive
                      ? context.dangerText
                      : context.accent,
                  side: BorderSide(
                    color: isActive ? Colors.red.shade300 : AppColors.primary,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _assignEvent() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Assign Event'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _demoEvents
                  .map(
                    (event) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        _assignedEvent == event
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: context.accent,
                      ),
                      title: Text(event, style: const TextStyle(fontSize: 13)),
                      onTap: () {
                        setState(() {
                          _assignedEvent = event;
                        });

                        Navigator.pop(dialogContext);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Assigned to $event for this visit only. '
                              'Not saved permanently.',
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _toggleStatus() {
    final currentIsActive =
        _statusOverride ??
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
      ),
    );
  }

  Map<String, String> _currentEmployee() {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    return arguments is Map<String, String>
        ? arguments
        : const <String, String>{};
  }

  // READ EMPLOYEE FIELD
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

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: context.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Icon(icon, size: 19, color: context.accent),

          const SizedBox(width: 10),

          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: valueColor ?? context.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, size: 14, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
