import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

class PaymentDetailsScreen extends StatelessWidget {
  const PaymentDetailsScreen({super.key});

  Map<String, String> _paymentFromRoute(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is Map<String, String>) {
      return arguments;
    }

    return const {
      'id': 'TXN-2026-00125',
      'booking': 'BK - 1025',
      'customer': 'John Smith',
      'event': 'Tech Conference 2026',
      'amount': '₹2,000',
      'method': 'UPI',
      'status': 'Paid',
      'date': '28 September 2026',
    };
  }

  @override
  Widget build(BuildContext context) {
    final payment = _paymentFromRoute(context);

    final id = payment['id'] ?? '—';
    final booking = payment['booking'] ?? '—';
    final customer = payment['customer'] ?? '—';
    final event = payment['event'] ?? '—';
    final amount = payment['amount'] ?? '—';
    final method = payment['method'] ?? '—';
    final status = payment['status'] ?? 'Unknown';
    final date = payment['date'] ?? '—';

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        title: const Text(
          'Payment Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPaymentSummary(
              context,
              amount: amount,
              status: status,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Transaction Information'),
            const SizedBox(height: 10),
            _buildInfoCard(
              context,
              [
                _buildInfoRow(
                  context,
                  Icons.receipt_long_outlined,
                  'Transaction ID',
                  id,
                  trailing: IconButton(
                    tooltip: 'Copy transaction ID',
                    visualDensity: VisualDensity.compact,
                    onPressed: id == '—'
                        ? null
                        : () {
                            Clipboard.setData(ClipboardData(text: id));
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text('Transaction ID copied.'),
                                ),
                              );
                          },
                    icon: Icon(
                      Icons.copy_rounded,
                      size: 17,
                      color: context.textMuted,
                    ),
                  ),
                ),
                _buildInfoRow(
                  context,
                  Icons.confirmation_number_outlined,
                  'Booking ID',
                  booking,
                ),
                _buildInfoRow(
                  context,
                  Icons.calendar_today_outlined,
                  'Date',
                  date,
                ),
                _buildInfoRow(
                  context,
                  Icons.credit_card_outlined,
                  'Payment Method',
                  method,
                ),
                _buildInfoRow(
                  context,
                  Icons.verified_outlined,
                  'Status',
                  status,
                  valueColor: _statusColor(context, status),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _buildSectionTitle(context, 'Customer & Event'),
            const SizedBox(height: 10),
            _buildInfoCard(
              context,
              [
                _buildInfoRow(
                  context,
                  Icons.person_outline_rounded,
                  'Customer',
                  customer,
                ),
                _buildInfoRow(
                  context,
                  Icons.event_outlined,
                  'Event',
                  event,
                ),
              ],
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Receipt download will be added later.'),
                    ),
                  );
              },
              icon: const Icon(Icons.download_outlined, size: 19),
              label: const Text('Download Receipt'),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.accent,
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.7)),
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary(
    BuildContext context, {
    required String amount,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.82),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
              ),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 31,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Payment Amount',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            amount,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 13),
          _buildStatusBadge(status),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: context.textPrimary,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> rows) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.outline),
      ),
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++) ...[
            rows[index],
            if (index != rows.length - 1)
              Divider(height: 1, color: context.outline),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: context.tintSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: context.accent),
          ),
          const SizedBox(width: 11),
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                color: context.textMuted,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              softWrap: true,
              style: TextStyle(
                color: valueColor ?? context.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Color _statusColor(BuildContext context, String status) {
    switch (status.trim().toLowerCase()) {
      case 'paid':
        return context.accent;
      case 'pending':
        return context.warningText;
      case 'failed':
      case 'refunded':
      case 'cancelled':
        return context.dangerText;
      default:
        return context.textMuted;
    }
  }

  Widget _buildStatusBadge(String status) {
    final normalizedStatus = status.trim().toLowerCase();

    final Color backgroundColor;
    final IconData icon;

    switch (normalizedStatus) {
      case 'paid':
        backgroundColor = Colors.white.withValues(alpha: 0.16);
        icon = Icons.check_circle_outline_rounded;
        break;
      case 'pending':
        backgroundColor = Colors.orange.withValues(alpha: 0.22);
        icon = Icons.schedule_rounded;
        break;
      case 'failed':
      case 'cancelled':
        backgroundColor = Colors.red.withValues(alpha: 0.22);
        icon = Icons.error_outline_rounded;
        break;
      case 'refunded':
        backgroundColor = Colors.blue.withValues(alpha: 0.22);
        icon = Icons.replay_rounded;
        break;
      default:
        backgroundColor = Colors.white.withValues(alpha: 0.14);
        icon = Icons.info_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
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
