import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PaymentDetailsScreen extends StatelessWidget {
  const PaymentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments;

    final payment = arguments is Map<String, String>
        ? arguments
        : <String, String>{
            'id': 'TXN-2026-00125',
            'booking': 'BK - 1025',
            'customer': 'John Smith',
            'event': 'Tech Conference 2026',
            'amount': '₹2,000',
            'method': 'UPI',
            'status': 'Paid',
            'date': '28 September 2026',
          };

    final id = payment['id'] ?? 'TXN-2026-00125';
    final booking =
        payment['booking'] ?? 'BK - 1025';
    final customer =
        payment['customer'] ?? 'John Smith';
    final event =
        payment['event'] ?? 'Tech Conference 2026';
    final amount =
        payment['amount'] ?? '₹2,000';
    final method =
        payment['method'] ?? 'UPI';
    final status =
        payment['status'] ?? 'Paid';
    final date =
        payment['date'] ?? '28 September 2026';

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // PAYMENT HEADER
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
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.payments_outlined,
                      color: AppColors.primary,
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Payment Amount',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    amount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _buildStatusBadge(status),
                ],
              ),
            ),

            const SizedBox(height: 22),

            _buildSectionTitle(
              'Transaction Information',
            ),

            const SizedBox(height: 10),

            _buildInfoCard([
              _buildInfoRow(
                Icons.receipt_long_outlined,
                'Transaction ID',
                id,
              ),
              _buildInfoRow(
                Icons.confirmation_number_outlined,
                'Booking ID',
                booking,
              ),
              _buildInfoRow(
                Icons.calendar_today_outlined,
                'Date',
                date,
              ),
              _buildInfoRow(
                Icons.credit_card_outlined,
                'Payment Method',
                method,
              ),
              _buildInfoRow(
                Icons.verified_outlined,
                'Status',
                status,
                valueColor: status == 'Paid'
                    ? AppColors.primary
                    : status == 'Pending'
                        ? Colors.orange.shade800
                        : Colors.red.shade700,
              ),
            ]),

            const SizedBox(height: 20),

            _buildSectionTitle(
              'Customer & Event',
            ),

            const SizedBox(height: 10),

            _buildInfoCard([
              _buildInfoRow(
                Icons.person_outline,
                'Customer',
                customer,
              ),
              _buildInfoRow(
                Icons.event_outlined,
                'Event',
                event,
              ),
            ]),

            const SizedBox(height: 25),

            // RECEIPT BUTTON
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Receipt download will be added later.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.download_outlined,
                ),
                label: const Text(
                  'Download Receipt',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(
                    color: AppColors.primary,
                  ),
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
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
      padding: const EdgeInsets.symmetric(
        vertical: 11,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
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
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'Paid':
        backgroundColor =
            Colors.white.withValues(alpha: 0.15);
        textColor = Colors.white;
        icon = Icons.check_circle_outline;
        break;

      case 'Pending':
        backgroundColor =
            Colors.orange.withValues(alpha: 0.2);
        textColor = Colors.white;
        icon = Icons.access_time;
        break;

      default:
        backgroundColor =
            Colors.red.withValues(alpha: 0.2);
        textColor = Colors.white;
        icon = Icons.replay;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}