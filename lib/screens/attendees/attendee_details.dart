import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

class AttendeeDetailsScreen extends StatefulWidget {
  const AttendeeDetailsScreen({super.key});

  @override
  State<AttendeeDetailsScreen> createState() => _AttendeeDetailsScreenState();
}

class _AttendeeDetailsScreenState extends State<AttendeeDetailsScreen> {
  bool checkedIn = false;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    final attendee = arguments is Map<String, String>
        ? arguments
        : <String, String>{
            'name': 'Hilda Faith',
            'enrollment': '24SOEC16118',
            'email': 'hilda@rxevents.com',
            'phone': '+91 9876543210',
            'event': 'Annual Tech Expo 2026',
            'seats': '2',
            'status': 'Checked-in',
            'booking': 'BK - 1025',
            'payment': 'Paid',
          };

    final name = attendee['name'] ?? 'Hilda Faith';
    final enrollment = attendee['enrollment'] ?? '24SOEC16118';
    final email = attendee['email'] ?? 'hilda@rxevents.com';
    final phone = attendee['phone'] ?? '+91 9876543210';
    final event = attendee['event'] ?? 'Annual Tech Expo 2026';
    final seats = attendee['seats'] ?? '2';
    final booking = attendee['booking'] ?? 'BK - 1025';
    final payment = attendee['payment'] ?? 'Paid';

    final originalStatus = attendee['status'] ?? 'Not checked-in';

    final status = checkedIn ? 'Checked-in' : originalStatus;

    final initial = name.substring(0, 1).toUpperCase();

    return Scaffold(
      backgroundColor: context.bg,

      appBar: AppBar(
        title: const Text('Attendee Details'),
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
                    width: 78,
                    height: 78,
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
                          fontSize: 30,
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
                    enrollment,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),

                  const SizedBox(height: 12),

                  _buildStatusBadge(status),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // PERSONAL INFORMATION
            _buildSectionTitle('Personal Information'),

            const SizedBox(height: 10),

            _buildInfoCard([
              _buildInfoRow(Icons.person_outline, 'Name', name),
              _buildInfoRow(Icons.badge_outlined, 'Enrollment', enrollment),
              _buildInfoRow(Icons.email_outlined, 'Email', email),
              _buildInfoRow(Icons.phone_outlined, 'Phone', phone),
            ]),

            const SizedBox(height: 20),

            // EVENT INFORMATION
            _buildSectionTitle('Event Information'),

            const SizedBox(height: 10),

            _buildInfoCard([
              _buildInfoRow(Icons.event_outlined, 'Event', event),
              _buildInfoRow(Icons.people_outline, 'Seats', seats),
              _buildInfoRow(
                Icons.confirmation_number_outlined,
                'Booking',
                booking,
              ),
            ]),

            const SizedBox(height: 20),

            // PAYMENT
            _buildSectionTitle('Payment Information'),

            const SizedBox(height: 10),

            _buildInfoCard([
              _buildInfoRow(
                Icons.payment_outlined,
                'Payment',
                payment,
                valueColor: payment == 'Paid'
                    ? context.accent
                    : context.warningText,
              ),
              _buildInfoRow(
                Icons.verified_outlined,
                'Attendance',
                status,
                valueColor: status == 'Checked-in'
                    ? context.accent
                    : context.warningText,
              ),
            ]),

            const SizedBox(height: 26),

            // CHECK IN BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: checkedIn ? null : _checkIn,
                icon: Icon(checkedIn ? Icons.check_circle : Icons.login),
                label: Text(
                  checkedIn ? 'Already Checked In' : 'Check In Attendee',
                ),
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

            const SizedBox(height: 10),

            const Text(
              'Attendance status can be updated when the attendee arrives.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  void _checkIn() {
    setState(() {
      checkedIn = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendee checked in successfully.')),
    );
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
            width: 95,
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
    final isCheckedIn = status == 'Checked-in';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCheckedIn ? Icons.check_circle_outline : Icons.access_time,
            size: 14,
            color: Colors.white,
          ),
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
