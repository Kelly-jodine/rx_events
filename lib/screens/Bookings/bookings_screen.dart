import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  String selectedFilter = 'All';
  String searchQuery = '';

  final List<Map<String, String>> bookings = [
    {
      'id': 'BK - 1025',
      'customer': 'John Smith',
      'phone': '+91 9876543210',
      'email': 'john@email.com',
      'event': 'Tech Conference',
      'seats': '2',
      'payment': 'Paid',
      'status': 'Confirmed',
      'date': '28 September 2026',
    },
    {
      'id': 'BK - 1026',
      'customer': 'Sarah Johnson',
      'phone': '+91 9876543211',
      'email': 'sarah@email.com',
      'event': 'Wedding Expo',
      'seats': '3',
      'payment': 'Pending',
      'status': 'Pending',
      'date': '2 October 2026',
    },
    {
      'id': 'BK - 1027',
      'customer': 'Michael Brown',
      'phone': '+91 9876543212',
      'email': 'michael@email.com',
      'event': 'Summer Music Festival',
      'seats': '4',
      'payment': 'Paid',
      'status': 'Cancelled',
      'date': '5 October 2026',
    },
  ];

  List<Map<String, String>> get filteredBookings {
    return bookings.where((booking) {
      final matchesFilter = selectedFilter == 'All' ||
          booking['status'] == selectedFilter;

      final query = searchQuery.toLowerCase();

      final matchesSearch =
          booking['id']!.toLowerCase().contains(query) ||
          booking['customer']!.toLowerCase().contains(query) ||
          booking['event']!.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Bookings',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),

                const SizedBox(height: 18),

                _buildFilterOption('All'),
                _buildFilterOption('Confirmed'),
                _buildFilterOption('Pending'),
                _buildFilterOption('Cancelled'),
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
        isSelected
            ? Icons.radio_button_checked
            : Icons.radio_button_unchecked,
        color: AppColors.primary,
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

  void _openBookingDetails(Map<String, String> booking) {
    Navigator.pushNamed(
      context,
      AppRoutes.bookingDetails,
      arguments: booking,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Bookings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            const Text(
              'Manage Bookings',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'View and manage all event reservations.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
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
                hintText: 'Search bookings...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // FILTER
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: _showFilterOptions,
                icon: const Icon(
                  Icons.filter_list,
                  size: 18,
                ),
                label: Text(
                  selectedFilter == 'All'
                      ? 'Filter'
                      : selectedFilter,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(
                    color: AppColors.primary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // BOOKING LIST
            Expanded(
              child: filteredBookings.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy_outlined,
                            size: 55,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No bookings found.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredBookings.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final booking = filteredBookings[index];

                        return _buildBookingCard(booking);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, String> booking) {
    final status = booking['status']!;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        _openBookingDetails(booking);
      },
      child: Card(
        elevation: 1.5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP ROW
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.confirmation_number_outlined,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking #${booking['id']!.replaceAll('BK - ', '')}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          booking['customer']!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
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

              // EVENT
              Row(
                children: [
                  const Icon(
                    Icons.event_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking['event']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // DATE + SEATS
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      booking['date']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.people_outline,
                    size: 17,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${booking['seats']} seats',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // PAYMENT + DETAILS
              Row(
                children: [
                  Icon(
                    booking['payment'] == 'Paid'
                        ? Icons.check_circle_outline
                        : Icons.access_time,
                    size: 17,
                    color: booking['payment'] == 'Paid'
                        ? AppColors.primary
                        : Colors.orange,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    booking['payment']!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: booking['payment'] == 'Paid'
                          ? AppColors.dark
                          : Colors.orange.shade800,
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    'View Details →',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'Confirmed':
        backgroundColor = AppColors.light;
        textColor = AppColors.dark;
        icon = Icons.check_circle_outline;
        break;

      case 'Pending':
        backgroundColor = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
        icon = Icons.access_time;
        break;

      default:
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        icon = Icons.cancel_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
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
            size: 13,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}