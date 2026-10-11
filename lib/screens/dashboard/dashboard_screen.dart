import 'package:flutter/material.dart';

import '../../core/data/demo_events.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,

      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: AppColors.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: context.card,
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: context.accent,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Rx Events',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Hilda',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: const Icon(Icons.dashboard_outlined),
                title: const Text('Dashboard'),
                selected: true,
                selectedColor: context.accent,
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.event_outlined),
                title: const Text('Events'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.events);
                },
              ),

              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text('Calendar'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.calendar);
                },
              ),

              ListTile(
                leading: const Icon(Icons.book_online_outlined),
                title: const Text('Bookings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.bookings);
                },
              ),

              ListTile(
                leading: const Icon(Icons.people_outline),
                title: const Text('Attendees'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.attendees);
                },
              ),

              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: const Text('Employees'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.employees);
                },
              ),

              ListTile(
                leading: const Icon(Icons.payments_outlined),
                title: const Text('Payments'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.payments);
                },
              ),

              ListTile(
                leading: const Icon(Icons.bar_chart_outlined),
                title: const Text('Reports'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.reports);
                },
              ),

              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Notifications'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.notifications);
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
              ),

              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.settings);
                },
              ),

              const Spacer(),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutDialog(context);
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, AppRoutes.events);
          }

          if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.createEvent);
          }

          if (index == 3) {
            Navigator.pushNamed(context, AppRoutes.profile);
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

      appBar: AppBar(
        backgroundColor: context.appBarSurface,
        foregroundColor: context.textPrimary,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: context.card,
              child: Icon(Icons.event, color: context.accent, size: 22),
            ),
            SizedBox(width: 10),
            Text(
              'Rx Events',
              style: TextStyle(
                color: context.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: context.card,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning, Hilda 👋',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Manage your events with ease.',
                          style: TextStyle(
                            fontSize: 13,
                            color: context.textFaint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: context.tintSurface,
                    child: Icon(Icons.person, size: 32, color: context.accent),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Upcoming Event',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            _buildUpcomingEventCard(context),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quick Action',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showQuickActionsSheet(context);
                  },
                  child: const Text('See all →'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    context,
                    icon: Icons.add,
                    title: 'Create',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.createEvent);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickAction(
                    context,
                    icon: Icons.calendar_month,
                    title: 'Calendar',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.calendar);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickAction(
                    context,
                    icon: Icons.people,
                    title: 'Staff',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.employees);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickAction(
                    context,
                    icon: Icons.bar_chart,
                    title: 'Reports',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.reports);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Text(
              'Overview',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.25,
              children: [
                _buildOverviewCard(
                  context,
                  icon: Icons.event,
                  value: '24',
                  title: 'Events',
                  growth: '+12%',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.events);
                  },
                ),
                _buildOverviewCard(
                  context,
                  icon: Icons.book_online,
                  value: '18',
                  title: 'Bookings',
                  growth: '+8%',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.bookings);
                  },
                ),
                _buildOverviewCard(
                  context,
                  icon: Icons.people_outline,
                  value: '486',
                  title: 'Attendees',
                  growth: '+15%',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.attendees);
                  },
                ),
                _buildOverviewCard(
                  context,
                  icon: Icons.payments_outlined,
                  value: '₹6K',
                  title: 'Revenue',
                  growth: '+20%',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.payments);
                  },
                ),
              ],
            ),

            const SizedBox(height: 25),

            Text(
              'Recent Events',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            _buildRecentEvent(
              context,
              DemoEvents.byTitle('Annual Business Meetup'),
            ),

            const SizedBox(height: 10),

            _buildRecentEvent(
              context,
              DemoEvents.byTitle('Tech Conference 2026'),
            ),

            const SizedBox(height: 10),

            _buildRecentEvent(context, DemoEvents.byTitle('Music Festival')),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEventCard(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.eventDetails,
          arguments: DemoEvents.byTitle('Tech Conference 2026'),
        );
      },
      child: Container(
        width: double.infinity,
        height: 190,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.tintSurface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/tech_event.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImageFallback(context);
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'UPCOMING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tech Conference 2026',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '28 September 2026 • Ahmedabad',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageFallback(BuildContext context) {
    return Container(
      color: context.tintSurface,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event, size: 46, color: context.accent),
          SizedBox(height: 8),
          Text(
            'Rx Events',
            style: TextStyle(
              color: context.accent,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 75,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: context.accent, size: 25),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: context.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String title,
    required String growth,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.accent, size: 26),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(fontSize: 11, color: context.textFaint),
            ),
            const SizedBox(height: 5),
            Text(
              growth,
              style: TextStyle(
                fontSize: 10,
                color: context.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentEvent(BuildContext context, Map<String, String> event) {
    final title = event['title'] ?? '';
    final date = event['date'] ?? '';
    final location = event['location'] ?? '';

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.eventDetails,
            arguments: event,
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        leading: CircleAvatar(
          backgroundColor: context.tintSurface,
          child: Icon(Icons.event, color: context.accent),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        subtitle: Text('$date • $location'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 15),
      ),
    );
  }

  void _showQuickActionsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: sheetContext.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Jump straight to a module',
                  style: TextStyle(fontSize: 12, color: sheetContext.textFaint),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _buildQuickActionTile(
                        sheetContext,
                        icon: Icons.add_circle_outline,
                        title: 'Create Event',
                        subtitle: 'Set up a new event',
                        route: AppRoutes.createEvent,
                      ),
                      _buildQuickActionTile(
                        sheetContext,
                        icon: Icons.calendar_month_outlined,
                        title: 'Calendar',
                        subtitle: 'See your event schedule',
                        route: AppRoutes.calendar,
                      ),
                      _buildQuickActionTile(
                        sheetContext,
                        icon: Icons.people_outline,
                        title: 'Staff',
                        subtitle: 'Manage employees',
                        route: AppRoutes.employees,
                      ),
                      _buildQuickActionTile(
                        sheetContext,
                        icon: Icons.bar_chart_outlined,
                        title: 'Reports',
                        subtitle: 'Revenue and top events',
                        route: AppRoutes.reports,
                      ),
                      _buildQuickActionTile(
                        sheetContext,
                        icon: Icons.book_online_outlined,
                        title: 'Bookings',
                        subtitle: 'Review bookings',
                        route: AppRoutes.bookings,
                      ),
                      _buildQuickActionTile(
                        sheetContext,
                        icon: Icons.event_available_outlined,
                        title: 'Attendees',
                        subtitle: 'View registered guests',
                        route: AppRoutes.attendees,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionTile(
    BuildContext sheetContext, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: sheetContext.tintSurface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: sheetContext.accentStrong, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: sheetContext.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11, color: sheetContext.textFaint),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () {
        final navigator = Navigator.of(sheetContext);

        navigator.pop();

        navigator.pushNamed(route);
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
