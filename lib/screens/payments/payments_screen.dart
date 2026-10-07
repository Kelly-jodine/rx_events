import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String selectedFilter = 'All';
  String searchQuery = '';

  final List<Map<String, String>> payments = [
    {
      'id': 'TXN-2026-00125',
      'booking': 'BK - 1025',
      'customer': 'John Smith',
      'event': 'Tech Conference 2026',
      'amount': '₹2,000',
      'method': 'UPI',
      'status': 'Paid',
      'date': '28 September 2026',
    },
    {
      'id': 'TXN-2026-00126',
      'booking': 'BK - 1026',
      'customer': 'Sarah Johnson',
      'event': 'Wedding Expo',
      'amount': '₹3,500',
      'method': 'Card',
      'status': 'Pending',
      'date': '2 October 2026',
    },
    {
      'id': 'TXN-2026-00127',
      'booking': 'BK - 1027',
      'customer': 'Michael Brown',
      'event': 'Summer Music Festival',
      'amount': '₹4,000',
      'method': 'UPI',
      'status': 'Refunded',
      'date': '5 October 2026',
    },
    {
      'id': 'TXN-2026-00128',
      'booking': 'BK - 1028',
      'customer': 'Anita Sharma',
      'event': 'Annual Business Meetup',
      'amount': '₹1,500',
      'method': 'Cash',
      'status': 'Paid',
      'date': '10 October 2026',
    },
    {
      'id': 'TXN-2026-00129',
      'booking': 'BK - 1029',
      'customer': 'David Wilson',
      'event': 'Tech Conference 2026',
      'amount': '₹2,500',
      'method': 'Card',
      'status': 'Paid',
      'date': '12 October 2026',
    },
  ];

  List<Map<String, String>> get filteredPayments {
    return payments.where((payment) {
      final matchesFilter =
          selectedFilter == 'All' || payment['status'] == selectedFilter;

      final query = searchQuery.toLowerCase();

      final matchesSearch =
          payment['id']!.toLowerCase().contains(query) ||
          payment['booking']!.toLowerCase().contains(query) ||
          payment['customer']!.toLowerCase().contains(query) ||
          payment['event']!.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  int get paidCount {
    return payments.where((payment) => payment['status'] == 'Paid').length;
  }

  int get pendingCount {
    return payments.where((payment) => payment['status'] == 'Pending').length;
  }

  int get refundedCount {
    return payments.where((payment) => payment['status'] == 'Refunded').length;
  }

  // Only settled payments count as revenue. Pending and Refunded
  // transactions are deliberately excluded.
  int get totalRevenue {
    var total = 0;

    for (final payment in payments) {
      if (payment['status'] != 'Paid') {
        continue;
      }

      final digits = (payment['amount'] ?? '').replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );

      total += int.tryParse(digits) ?? 0;
    }

    return total;
  }

  String get totalRevenueLabel {
    final amount = totalRevenue;

    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)}L';
    }

    if (amount >= 1000) {
      final thousands = amount / 1000;

      return '₹${thousands == thousands.roundToDouble() ? thousands.toStringAsFixed(0) : thousands.toStringAsFixed(1)}K';
    }

    return '₹$amount';
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Payments',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                _buildFilterOption('All'),
                _buildFilterOption('Paid'),
                _buildFilterOption('Pending'),
                _buildFilterOption('Refunded'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String filter) {
    final isSelected = selectedFilter == filter;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: context.accent,
      ),
      title: Text(filter),
      onTap: () {
        setState(() {
          selectedFilter = filter;
        });

        Navigator.pop(context);
      },
    );
  }

  void _openPaymentDetails(Map<String, String> payment) {
    Navigator.pushNamed(context, AppRoutes.paymentDetails, arguments: payment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,

      appBar: AppBar(
        title: const Text('Payments'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showFilterOptions,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Overview',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Track payments and transaction status.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),

            const SizedBox(height: 18),

            // REVENUE CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Revenue',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          totalRevenueLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'From $paidCount paid '
                          'transaction${paidCount == 1 ? '' : 's'}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 42,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // SUMMARY
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    Icons.check_circle_outline,
                    'Paid',
                    paidCount.toString(),
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryCard(
                    Icons.access_time,
                    'Pending',
                    pendingCount.toString(),
                    Colors.orange.shade700,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryCard(
                    Icons.replay,
                    'Refunded',
                    refundedCount.toString(),
                    Colors.red.shade700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // SEARCH
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search transaction, customer or event...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: context.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // FILTER CHIPS
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Paid'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Refunded'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.tintSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    filteredPayments.length.toString(),
                    style: TextStyle(
                      color: context.accentStrong,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            filteredPayments.isEmpty
                ? _buildEmptyState()
                : Column(
                    children: filteredPayments.map(_buildPaymentCard).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    IconData icon,
    String title,
    String value,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = selectedFilter == filter;

    return ChoiceChip(
      label: Text(filter),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selectedFilter = filter;
        });
      },
      selectedColor: context.accent,
      backgroundColor: context.card,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : context.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : context.outlineStrong,
      ),
    );
  }

  Widget _buildPaymentCard(Map<String, String> payment) {
    final status = payment['status']!;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        _openPaymentDetails(payment);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: context.cardAlt),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.tintSurface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: context.accent,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment['id']!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        payment['customer']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                _buildStatusBadge(status),
              ],
            ),

            const SizedBox(height: 14),

            const Divider(height: 1),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.event_outlined, size: 16, color: context.accent),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    payment['event']!,
                    style: TextStyle(fontSize: 12, color: context.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.credit_card_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 7),
                Text(
                  payment['method']!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const Spacer(),

                Text(
                  payment['amount']!,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: context.accentStrong,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 9),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  payment['date']!,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),

                const Spacer(),

                Text(
                  'View Details →',
                  style: TextStyle(
                    color: context.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'Paid':
        backgroundColor = context.tintSurface;
        textColor = context.accentStrong;
        icon = Icons.check_circle_outline;
        break;

      case 'Pending':
        backgroundColor = context.warningSurface;
        textColor = context.warningText;
        icon = Icons.access_time;
        break;

      default:
        backgroundColor = context.dangerSurface;
        textColor = context.dangerText;
        icon = Icons.replay;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 55, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No payments found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Try another search or filter.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
