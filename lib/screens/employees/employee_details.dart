import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  const EmployeeDetailsScreen({super.key});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  bool? _statusOverride;

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
      backgroundColor: AppColors.background,

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
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.light, width: 4),
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: AppColors.primary,
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
              _buildInfoRow(
                Icons.verified_outlined,
                'Status',
                isActive ? 'Active' : 'Inactive',
                valueColor: isActive ? AppColors.primary : Colors.grey.shade700,
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
                      ? Colors.red.shade700
                      : AppColors.primary,
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Event assignment will be connected to the database later.',
        ),
      ),
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
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Icon(icon, size: 19, color: AppColors.primary),

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
                color: valueColor ?? AppColors.text,
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
