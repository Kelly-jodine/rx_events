import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedPeriod = 'This Quarter';

  final List<String> periods = [
    'This Week',
    'This Month',
    'This Quarter',
    'This Year',
  ];

  Future<void> _selectPeriod() async {
    final String? result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Period',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                ...periods.map(
                  (period) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(period),
                    trailing: selectedPeriod == period
                        ? Icon(Icons.check_circle, color: context.accent)
                        : null,
                    onTap: () {
                      Navigator.pop(context, period);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      selectedPeriod = result;
    });
  }

  // Date range shown for the selected period. Derived from the
  // current date so the label is never a stale literal.
  String get dateRangeLabel {
    final now = DateTime.now();

    late DateTime start;

    switch (selectedPeriod) {
      case 'This Week':
        start = now.subtract(Duration(days: now.weekday - 1));
        break;

      case 'This Month':
        start = DateTime(now.year, now.month);
        break;

      case 'This Year':
        start = DateTime(now.year);
        break;

      default:
        start = DateTime(now.year, (now.month - 2) ~/ 3 * 3 + 1);
    }

    final end = switch (selectedPeriod) {
      'This Week' => start.add(const Duration(days: 6)),
      'This Month' => DateTime(now.year, now.month + 1, 0),
      'This Year' => DateTime(now.year, 12, 31),
      _ => DateTime(now.year, start.month + 3, 0),
    };

    return '${_formatDate(start)} - ${_formatDate(end)}';
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');

    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report export will be available soon.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,

      // APP BAR
      appBar: AppBar(
        backgroundColor: context.appBarSurface,
        foregroundColor: context.textPrimary,
        elevation: 0,
        title: Text(
          'Reports',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _exportReport,
            tooltip: 'Export',
            icon: Icon(Icons.file_download_outlined, color: context.accent),
          ),
        ],
      ),

      // BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // REPORT OVERVIEW HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.card,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: context.tintSurface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.analytics_outlined,
                      color: context.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reports Overview',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Track your performance',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _exportReport,
                    icon: const Icon(Icons.download_outlined, size: 16),
                    label: const Text('Export'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dark,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // DATE RANGE
            InkWell(
              onTap: _selectPeriod,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: context.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.outline),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range_outlined,
                      color: context.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        dateRangeLabel,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // STATISTICS
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.payments_outlined,
                    title: 'Total Revenue',
                    value: '₹6K',
                    growth: '↑ 12%',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.event_available_outlined,
                    title: 'Events',
                    value: '24',
                    growth: '↑ 9%',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.people_outline,
                    title: 'Consultations',
                    value: '32',
                    growth: '↑ 6.2%',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // WORK PERFORMANCE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Work Performance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                InkWell(
                  onTap: _selectPeriod,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.dark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedPeriod,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
              decoration: BoxDecoration(
                color: context.card,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _buildPerformanceChart(),
            ),

            const SizedBox(height: 22),

            // TOP PERFORMING EVENTS
            Text(
              'Top Performing Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            _buildTopEvent(
              imageUrl:
                  'https://images.unsplash.com/photo-1492684223066-81342ee5ff30'
                  '?auto=format&fit=crop&w=400&q=80',
              title: 'Annual Tech Expo 2026',
              date: '28th Aug, 2026',
              revenue: '₹2,000',
            ),

            const SizedBox(height: 10),

            _buildTopEvent(
              imageUrl:
                  'https://images.unsplash.com/photo-1506157786151-b8491531f063'
                  '?auto=format&fit=crop&w=400&q=80',
              title: 'Summer Music Festival',
              date: '5th Oct, 2026',
              revenue: '₹2,500',
            ),

            const SizedBox(height: 10),

            _buildTopEvent(
              imageUrl:
                  'https://images.unsplash.com/photo-1511578314322-379afb476865'
                  '?auto=format&fit=crop&w=400&q=80',
              title: 'Annual Business Meetup',
              date: '20th Sep, 2026',
              revenue: '₹1,500',
            ),
          ],
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          }

          if (index == 1) {
            Navigator.pushNamed(context, AppRoutes.events);
          }

          if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.createEvent);
          }

          if (index == 3) {
            Navigator.pushReplacementNamed(context, AppRoutes.profile);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 38, color: context.accent),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String growth,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.tintSurface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: context.accent, size: 19),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9, color: context.textMuted),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            growth,
            style: TextStyle(
              fontSize: 9,
              color: context.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'as per month',
            style: TextStyle(fontSize: 8, color: context.textFaint),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    final List<double> values = [
      0.25,
      0.42,
      0.68,
      0.55,
      0.76,
      0.82,
      0.60,
      0.35,
      0.48,
      0.72,
      0.85,
      0.62,
    ];

    return SizedBox(
      height: 190,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 24),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: values.map((value) {
                          return Container(
                            width: 10,
                            height: constraints.maxHeight * value,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(3),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const SizedBox(width: 24),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text('Jan', style: TextStyle(fontSize: 9)),
                    Text('Feb', style: TextStyle(fontSize: 9)),
                    Text('Mar', style: TextStyle(fontSize: 9)),
                    Text('Apr', style: TextStyle(fontSize: 9)),
                    Text('May', style: TextStyle(fontSize: 9)),
                    Text('Jun', style: TextStyle(fontSize: 9)),
                    Text('Jul', style: TextStyle(fontSize: 9)),
                    Text('Aug', style: TextStyle(fontSize: 9)),
                    Text('Sep', style: TextStyle(fontSize: 9)),
                    Text('Oct', style: TextStyle(fontSize: 9)),
                    Text('Nov', style: TextStyle(fontSize: 9)),
                    Text('Dec', style: TextStyle(fontSize: 9)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopEvent({
    required String imageUrl,
    required String title,
    required String date,
    required String revenue,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.events);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 58,
                height: 58,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 58,
                    height: 58,
                    color: context.tintSurface,
                    child: Icon(Icons.event, color: context.accent),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(fontSize: 10, color: context.textFaint),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              revenue,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
