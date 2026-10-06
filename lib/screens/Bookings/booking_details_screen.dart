import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool checkedIn = false;
  bool cancelled = false;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    final booking = arguments is Map<String, String>
        ? arguments
        : const <String, String>{};

    final bookingId = _read(booking, 'id', fallback: 'Not available');
    final customer = _read(booking, 'customer', fallback: 'Not available');
    final phone = _read(booking, 'phone');
    final email = _read(booking, 'email');
    final event = _read(booking, 'event', fallback: 'Not available');
    final seats = _read(booking, 'seats');
    final payment = _read(booking, 'payment', fallback: 'Not available');
    final date = _read(booking, 'date', fallback: 'Not available');
    final time = _read(booking, 'time');
    final location = _read(booking, 'location');
    final amount = _read(booking, 'amount');
    final paymentMethod = _read(booking, 'paymentMethod');

    final bookingStatus = _read(booking, 'status', fallback: 'Not available');

    final status = cancelled
        ? 'Cancelled'
        : checkedIn
        ? 'Checked In'
        : bookingStatus;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BOOKING HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.confirmation_number_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Booking ID',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          bookingId,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildStatusBadge(status),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // CUSTOMER
            _buildSectionTitle('Customer Information'),

            const SizedBox(height: 10),

            _buildInfoCard([
              _buildInfoRow(Icons.person_outline, 'Customer', customer),
              _buildInfoRow(Icons.phone_outlined, 'Phone', phone),
              _buildInfoRow(Icons.email_outlined, 'Email', email),
            ]),

            const SizedBox(height: 20),

            // EVENT
            _buildSectionTitle('Event Information'),

            const SizedBox(height: 10),

            _buildInfoCard([
              _buildInfoRow(Icons.event_outlined, 'Event', event),
              _buildInfoRow(Icons.calendar_today_outlined, 'Date', date),
              _buildInfoRow(Icons.access_time_outlined, 'Time', time),
              _buildInfoRow(Icons.location_on_outlined, 'Location', location),
              _buildInfoRow(Icons.people_outline, 'Seats', seats),
            ]),

            const SizedBox(height: 20),

            // PAYMENT
            _buildSectionTitle('Payment Information'),

            const SizedBox(height: 10),

            _buildInfoCard([
              _buildInfoRow(Icons.payments_outlined, 'Amount', amount),
              _buildInfoRow(
                Icons.account_balance_wallet_outlined,
                'Method',
                paymentMethod,
              ),
              _buildInfoRow(
                Icons.check_circle_outline,
                'Payment Status',
                payment,
                valueColor: payment == 'Paid'
                    ? AppColors.primary
                    : Colors.orange.shade800,
              ),
              _buildInfoRow(
                Icons.receipt_long_outlined,
                'Booking Status',
                status,
                valueColor: cancelled ? Colors.red.shade700 : AppColors.primary,
              ),
              _buildInfoRow(
                Icons.info_outline,
                'Data Source',
                'Local demo data',
              ),
            ]),

            const SizedBox(height: 26),

            // CHECK IN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: cancelled || checkedIn ? null : _checkIn,
                icon: Icon(checkedIn ? Icons.check_circle : Icons.login),
                label: Text(checkedIn ? 'Checked In' : 'Check In'),
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

            // CANCEL
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: cancelled || checkedIn ? null : _cancelBooking,
                icon: const Icon(Icons.close),
                label: Text(cancelled ? 'Booking Cancelled' : 'Cancel Booking'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // SMALL NOTE
            if (checkedIn)
              const Center(
                child: Text(
                  'Customer has been checked in successfully.',
                  style: TextStyle(color: AppColors.primary, fontSize: 12),
                ),
              ),

            if (cancelled)
              Center(
                child: Text(
                  'This booking has been cancelled.',
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // CHECK IN ACTION
  void _checkIn() {
    setState(() {
      checkedIn = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Customer checked in successfully.')),
    );
  }

  // CANCEL BOOKING ACTION
  void _cancelBooking() {
    setState(() {
      cancelled = true;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Booking cancelled.')));
  }

  // READ BOOKING FIELD
  static String _read(
    Map<String, String> booking,
    String key, {
    String fallback = 'Not available',
  }) {
    final value = booking[key];

    if (value == null) {
      return fallback;
    }

    final text = value.trim();

    return text.isEmpty ? fallback : text;
  }

  // SECTION TITLE
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
    );
  }

  // INFORMATION CARD
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

  // INFORMATION ROW
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

  // STATUS BADGE
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
