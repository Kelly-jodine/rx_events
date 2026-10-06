import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';

class NotificationItem {
  String title;
  String message;
  String time;
  String category;
  bool isRead;
  bool isImportant;
  IconData icon;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.category,
    required this.isRead,
    required this.isImportant,
    required this.icon,
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
      title: 'Two Days To The Annual Tech Expo',
      message:
          'Check for final arrangements; number of seats, attendees\' list, exhibitions.',
      time: '2 min ago',
      category: 'Events',
      isRead: false,
      isImportant: true,
      icon: Icons.calendar_month_outlined,
    ),
    NotificationItem(
      title: 'System notification',
      message: 'System update scheduled for 01-07-2026 at 01:50pm.',
      time: '2 days ago',
      category: 'Events',
      isRead: false,
      isImportant: false,
      icon: Icons.settings_outlined,
    ),
    NotificationItem(
      title: 'Send Email reminder',
      message:
          'Send email reminders about the tech expo to all participants and attendees.',
      time: 'now',
      category: 'Reminders',
      isRead: false,
      isImportant: true,
      icon: Icons.notifications_none,
    ),
    NotificationItem(
      title: 'Request meeting from Task Solutions',
      message:
          'Task Solutions wants to go over the final guest list for their end of year party.',
      time: 'now',
      category: 'Events',
      isRead: true,
      isImportant: false,
      icon: Icons.mark_email_unread_outlined,
    ),
    NotificationItem(
      title: 'Booking confirmation',
      message: 'A new booking has been confirmed for Annual Tech Expo 2026.',
      time: '1 hour ago',
      category: 'Events',
      isRead: true,
      isImportant: false,
      icon: Icons.book_online_outlined,
    ),
    NotificationItem(
      title: 'Payment received',
      message: 'Payment of \$450 has been received for booking BK-1025.',
      time: '3 hours ago',
      category: 'Reminders',
      isRead: true,
      isImportant: false,
      icon: Icons.payments_outlined,
    ),
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

  void _markAsRead(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });
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
                const Text(
                  'Filter Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 15),
                ...['All', 'Unread', 'Events', 'Reminders'].map(
                  (category) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      category == 'All'
                          ? Icons.notifications_outlined
                          : category == 'Unread'
                          ? Icons.mark_email_unread_outlined
                          : category == 'Events'
                          ? Icons.event_outlined
                          : Icons.alarm_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(category),
                    trailing: selectedCategory == category
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                          )
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
      backgroundColor: AppColors.background,

      // APP BAR
      appBar: AppBar(
        backgroundColor: AppColors.light,
        foregroundColor: AppColors.text,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.text),
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
            color: AppColors.light,
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
                          color: Colors.white,
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
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.text,
                          side: BorderSide(color: Colors.grey.shade300),
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
                    children: [
                      _buildCategoryChip('All'),
                      _buildCategoryChip('Unread'),
                      _buildCategoryChip('Events'),
                      _buildCategoryChip('Reminders'),
                    ],
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
        items: const [
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
            icon: Icon(Icons.add_circle, size: 38, color: AppColors.primary),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.text, size: 24),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
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
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppColors.text,
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
          _markAsRead(notification);
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : AppColors.light,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: notification.isRead
                  ? Colors.grey.shade200
                  : AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
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
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    notification.icon,
                    size: 20,
                    color: AppColors.text,
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
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            notification.time,
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey.shade600,
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
                          color: Colors.grey.shade700,
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
                  color: notification.isImportant ? Colors.orange : Colors.grey,
                  size: 19,
                ),
              ),
            ],
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
                color: AppColors.light,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No notifications found',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try changing your search or filter.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
