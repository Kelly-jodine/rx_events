import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

class NotificationItem {
  String title;
  String message;
  String time;
  String category;
  bool isRead;
  bool isImportant;
  IconData icon;

  // Existing route opened when the notification is tapped. When it is
  // null the notification only marks itself as read.
  String? route;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.category,
    required this.isRead,
    required this.isImportant,
    required this.icon,
    this.route,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'New booking received',
      message: 'Chimuka booked 2 seats for Annual Tech Expo 2026.',
      time: '2 min ago',
      category: 'Bookings',
      isRead: false,
      isImportant: false,
      icon: Icons.book_online_outlined,
      route: AppRoutes.bookings,
    ),
    NotificationItem(
      title: 'Payment received',
      message:
          '₹2,000 received from John Smith for TXN-2026-00125 '
          '(Tech Conference 2026).',
      time: '1 hour ago',
      category: 'Payments',
      isRead: false,
      isImportant: false,
      icon: Icons.payments_outlined,
      route: AppRoutes.payments,
    ),
    NotificationItem(
      title: 'Event starts in 2 days',
      message:
          'Tech Conference 2026 on 28 September 2026 in Ahmedabad. '
          'Review the final arrangements.',
      time: '3 hours ago',
      category: 'Events',
      isRead: false,
      isImportant: true,
      icon: Icons.event_available_outlined,
      route: AppRoutes.events,
    ),
    NotificationItem(
      title: 'New attendee registration',
      message:
          'Kelly Jodine registered for Annual Tech Expo 2026 and is '
          'awaiting check-in.',
      time: '5 hours ago',
      category: 'Attendees',
      isRead: false,
      isImportant: false,
      icon: Icons.person_add_alt_outlined,
      route: AppRoutes.attendees,
    ),
    NotificationItem(
      title: 'Payment still pending',
      message: 'BK - 1026 (Wedding Expo) has an unpaid balance of ₹3,500.',
      time: '8 hours ago',
      category: 'Payments',
      isRead: false,
      isImportant: true,
      icon: Icons.schedule_outlined,
      route: AppRoutes.payments,
    ),
    NotificationItem(
      title: 'Employee assigned',
      message:
          'Anita Sharma was assigned to the registration desk for '
          'Music Festival.',
      time: 'Yesterday',
      category: 'Team',
      isRead: true,
      isImportant: false,
      icon: Icons.badge_outlined,
      route: AppRoutes.employees,
    ),
    NotificationItem(
      title: 'Event status updated',
      message:
          'Music Festival on 5 October 2026 is still a Draft. '
          'Publish it to open registrations.',
      time: '2 days ago',
      category: 'Events',
      isRead: true,
      isImportant: false,
      icon: Icons.event_note_outlined,
      route: AppRoutes.events,
    ),
    NotificationItem(
      title: 'Booking cancelled',
      message:
          'BK - 1027 (Michael Brown) was cancelled. 4 seats released '
          'for Summer Music Festival.',
      time: '3 days ago',
      category: 'Bookings',
      isRead: true,
      isImportant: false,
      icon: Icons.cancel_schedule_send_outlined,
      route: AppRoutes.bookings,
    ),
    NotificationItem(
      title: 'Attendees checked in',
      message:
          'Hilda Faith and Biira Anitah were checked in for '
          'Annual Tech Expo 2026.',
      time: '4 days ago',
      category: 'Attendees',
      isRead: true,
      isImportant: false,
      icon: Icons.how_to_reg_outlined,
      route: AppRoutes.attendees,
    ),
  ];

  static const List<String> categories = [
    'All',
    'Unread',
    'Events',
    'Bookings',
    'Payments',
    'Attendees',
    'Team',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<NotificationItem> get filteredNotifications {
    return notifications.where((notification) {
      final matchesCategory =
          selectedCategory == 'All' ||
          (selectedCategory == 'Unread' && !notification.isRead) ||
          notification.category == selectedCategory;

      final query = searchQuery.toLowerCase().trim();

      final matchesSearch =
          query.isEmpty ||
          notification.title.toLowerCase().contains(query) ||
          notification.message.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get unreadCount => notifications.where((item) => !item.isRead).length;

  int get importantCount =>
      notifications.where((item) => item.isImportant).length;

  void _openNotification(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });

    final route = notification.route;

    if (route == null) {
      return;
    }

    Navigator.pushNamed(context, route);
  }

  void _markAllAsRead() {
    setState(() {
      for (final notification in notifications) {
        notification.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read.')),
    );
  }

  void _toggleImportant(NotificationItem notification) {
    setState(() {
      notification.isImportant = !notification.isImportant;
    });
  }

  void _deleteNotification(NotificationItem notification) {
    setState(() {
      notifications.remove(notification);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Notification removed.')));
  }

  Future<void> _openFilter() async {
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
                  'Filter Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 15),
                ...categories.map(
                  (category) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      _categoryIcon(category),
                      color: context.accent,
                    ),
                    title: Text(category),
                    trailing: selectedCategory == category
                        ? Icon(Icons.check_circle, color: context.accent)
                        : null,
                    onTap: () {
                      Navigator.pop(context, category);
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
      selectedCategory = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedNotifications = filteredNotifications;

    return Scaffold(
      backgroundColor: context.bg,

      // APP BAR
      appBar: AppBar(
        backgroundColor: context.appBarSurface,
        foregroundColor: context.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Mark all as read',
            onPressed: unreadCount == 0 ? null : _markAllAsRead,
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),

      body: Column(
        children: [
          // TOP SECTION
          Container(
            color: context.tintSurface,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
            child: Column(
              children: [
                // STATISTICS
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.notifications_none,
                        value: notifications.length.toString(),
                        title: 'All',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.mark_email_unread_outlined,
                        value: unreadCount.toString(),
                        title: 'Unread',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.campaign_outlined,
                        value: importantCount.toString(),
                        title: 'Important',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // SEARCH + FILTER
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: context.card,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search notifications',
                            prefixIcon: Icon(Icons.search, size: 21),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 42,
                      child: OutlinedButton.icon(
                        onPressed: _openFilter,
                        icon: const Icon(Icons.filter_alt_outlined, size: 17),
                        label: const Text('Filter'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: context.card,
                          foregroundColor: context.textPrimary,
                          side: BorderSide(color: context.outlineStrong),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // CATEGORY CHIPS
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map(_buildCategoryChip).toList(),
                  ),
                ),
              ],
            ),
          ),

          // NOTIFICATION LIST
          Expanded(
            child: displayedNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 24),
                    itemCount: displayedNotifications.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final notification = displayedNotifications[index];

                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
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
    required String value,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: context.textPrimary, size: 24),
          const SizedBox(height: 5),
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
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: context.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  static IconData _categoryIcon(String category) {
    switch (category) {
      case 'All':
        return Icons.notifications_outlined;

      case 'Unread':
        return Icons.mark_email_unread_outlined;

      case 'Events':
        return Icons.event_outlined;

      case 'Bookings':
        return Icons.book_online_outlined;

      case 'Payments':
        return Icons.payments_outlined;

      case 'Attendees':
        return Icons.people_outline;

      case 'Team':
        return Icons.badge_outlined;

      default:
        return Icons.notifications_none;
    }
  }

  Widget _buildCategoryChip(String category) {
    final bool selected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 7),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : context.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : context.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Dismissible(
      key: ValueKey(notification),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) {
        _deleteNotification(notification);
      },
      child: InkWell(
        onTap: () {
          _openNotification(notification);
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: notification.isRead ? context.card : context.tintSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: notification.isRead
                  ? context.outline
                  : AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // COLOR INDICATOR
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: notification.isImportant
                        ? Colors.orange
                        : AppColors.primary,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // ICON
                Center(
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: context.cardAlt,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      notification.icon,
                      size: 20,
                      color: context.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // CONTENT
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: notification.isRead
                                      ? FontWeight.w600
                                      : FontWeight.bold,
                                  color: context.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              notification.time,
                              style: TextStyle(
                                fontSize: 8,
                                color: context.textFaint,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          notification.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.35,
                            color: context.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // IMPORTANT BUTTON
                IconButton(
                  tooltip: 'Important',
                  onPressed: () {
                    _toggleImportant(notification);
                  },
                  icon: Icon(
                    notification.isImportant ? Icons.star : Icons.star_border,
                    color: notification.isImportant
                        ? Colors.orange
                        : Colors.grey,
                    size: 19,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.tintSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none,
                size: 40,
                color: context.accent,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications found',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try changing your search or filter.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: context.textFaint),
            ),
          ],
        ),
      ),
    );
  }
}
