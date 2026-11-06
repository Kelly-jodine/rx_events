import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

class NotificationItem {
  final String title;
  final String message;
  final String time;
  final String category;
  final IconData icon;
  final String? route;
  bool isRead;
  bool isImportant;

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
  static const List<String> categories = [
    'All',
    'Unread',
    'Events',
    'Bookings',
    'Payments',
    'Attendees',
    'Team',
  ];

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

  int get unreadCount => notifications.where((item) => !item.isRead).length;

  int get importantCount =>
      notifications.where((item) => item.isImportant).length;

  List<NotificationItem> get filteredNotifications {
    final query = searchQuery.trim().toLowerCase();

    return notifications.where((notification) {
      final matchesCategory = selectedCategory == 'All' ||
          (selectedCategory == 'Unread' && !notification.isRead) ||
          notification.category == selectedCategory;

      final matchesSearch = query.isEmpty ||
          notification.title.toLowerCase().contains(query) ||
          notification.message.toLowerCase().contains(query) ||
          notification.category.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openNotification(NotificationItem notification) {
    if (!notification.isRead) {
      setState(() {
        notification.isRead = true;
      });
    }

    final route = notification.route;
    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }

  void _markAllAsRead() {
    if (unreadCount == 0) return;

    setState(() {
      for (final notification in notifications) {
        notification.isRead = true;
      }
    });

    _showMessage('All notifications marked as read.');
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

    _showMessage('Notification removed.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _openFilter() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.outlineStrong,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Filter notifications',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose which notifications you want to see.',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                ...categories.map(
                  (category) {
                    final isSelected = selectedCategory == category;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        _categoryIcon(category),
                        color: isSelected
                            ? context.accent
                            : context.textMuted,
                      ),
                      title: Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: context.textPrimary,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: context.accent,
                            )
                          : null,
                      onTap: () => Navigator.pop(sheetContext, category),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      selectedCategory = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedNotifications = filteredNotifications;

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.appBarSurface,
        foregroundColor: context.textPrimary,
        elevation: 0,
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
            icon: const Icon(Icons.done_all_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: context.tintSurface,
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.notifications_none_rounded,
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
                        icon: Icons.star_outline_rounded,
                        value: importantCount.toString(),
                        title: 'Important',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: context.card,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: context.outline),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          style: TextStyle(
                            fontSize: 13,
                            color: context.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search notifications',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: context.textFaint,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 20,
                              color: context.textMuted,
                            ),
                            suffixIcon: searchQuery.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: 'Clear search',
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        searchQuery = '';
                                      });
                                    },
                                    icon: const Icon(Icons.close, size: 18),
                                  ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 13),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9),
                    SizedBox(
                      height: 46,
                      child: OutlinedButton.icon(
                        onPressed: _openFilter,
                        icon: const Icon(Icons.tune_rounded, size: 17),
                        label: const Text('Filter'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: context.card,
                          foregroundColor: context.textPrimary,
                          side: BorderSide(color: context.outlineStrong),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map(_buildCategoryChip).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: displayedNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
                    itemCount: displayedNotifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _buildNotificationCard(
                        displayedNotifications[index],
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.events);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.createEvent);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.profile);
              break;
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event_rounded),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_rounded,
              size: 38,
              color: context.accent,
            ),
            label: 'Create',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.outline),
      ),
      child: Column(
        children: [
          Icon(icon, color: context.accent, size: 21),
          const SizedBox(height: 7),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
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
              color: context.textMuted,
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
    final isSelected = selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            selectedCategory = category;
          });
        },
        showCheckmark: false,
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : context.textPrimary,
        ),
        backgroundColor: context.card,
        selectedColor: AppColors.primary,
        side: BorderSide(
          color: isSelected ? AppColors.primary : context.outline,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Dismissible(
      key: ObjectKey(notification),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 23,
        ),
      ),
      onDismissed: (_) => _deleteNotification(notification),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openNotification(notification),
          borderRadius: BorderRadius.circular(15),
          child: Ink(
            decoration: BoxDecoration(
              color: notification.isRead ? context.card : context.tintSurface,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: notification.isRead
                    ? context.outline
                    : AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: notification.isImportant
                        ? Colors.orange
                        : AppColors.primary,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.cardAlt,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      notification.icon,
                      size: 21,
                      color: context.accent,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
                            if (!notification.isRead)
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            const SizedBox(width: 5),
                            Text(
                              notification.time,
                              style: TextStyle(
                                fontSize: 9,
                                color: context.textFaint,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notification.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.4,
                            color: context.textMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notification.category,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: context.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  tooltip: notification.isImportant
                      ? 'Remove from important'
                      : 'Mark as important',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _toggleImportant(notification),
                  icon: Icon(
                    notification.isImportant
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: notification.isImportant
                        ? Colors.orange
                        : context.textFaint,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasActiveFilter =
        selectedCategory != 'All' || searchQuery.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: context.tintSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 40,
                color: context.accent,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              hasActiveFilter ? 'No matching notifications' : 'You’re all caught up',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              hasActiveFilter
                  ? 'Try another search term or choose a different filter.'
                  : 'New updates and activity will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: context.textFaint,
              ),
            ),
            if (hasActiveFilter) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    searchQuery = '';
                    selectedCategory = 'All';
                  });
                },
                icon: const Icon(Icons.refresh_rounded, size: 17),
                label: const Text('Clear filters'),
                style: TextButton.styleFrom(
                  foregroundColor: context.accent,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
