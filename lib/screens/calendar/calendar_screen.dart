import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime selectedDate;
  late DateTime displayedMonth;

  final List<Map<String, dynamic>> events = [
    {
      'id': '1',
      'title': 'Tech Conference',
      'date': DateTime(2026, 9, 23),
      'time': '10:00 AM - 4:00 PM',
      'location': 'Grand Conference Hall',
      'status': 'Upcoming',
      'capacity': 500,
      'attendees': 320,
      'color': AppColors.primary,
    },
    {
      'id': '2',
      'title': 'Music Festival',
      'date': DateTime(2026, 9, 28),
      'time': '5:00 PM - 11:00 PM',
      'location': 'City Stadium',
      'status': 'Upcoming',
      'capacity': 1000,
      'attendees': 780,
      'color': Colors.purple,
    },
    {
      'id': '3',
      'title': 'Business Summit',
      'date': DateTime(2026, 10, 5),
      'time': '9:00 AM - 3:00 PM',
      'location': 'Business Center',
      'status': 'Upcoming',
      'capacity': 300,
      'attendees': 210,
      'color': Colors.orange,
    },
    {
      'id': '4',
      'title': 'Art Exhibition',
      'date': DateTime(2026, 10, 10),
      'time': '11:00 AM - 7:00 PM',
      'location': 'Modern Art Gallery',
      'status': 'Upcoming',
      'capacity': 200,
      'attendees': 145,
      'color': Colors.pink,
    },
    {
      'id': '5',
      'title': 'Startup Meetup',
      'date': DateTime(2026, 9, 23),
      'time': '6:00 PM - 9:00 PM',
      'location': 'Innovation Hub',
      'status': 'Upcoming',
      'capacity': 150,
      'attendees': 98,
      'color': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();

    selectedDate = DateTime(today.year, today.month, today.day);

    displayedMonth = DateTime(today.year, today.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Calendar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today_outlined),
            tooltip: 'Today',
            onPressed: _goToToday,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalendarCard(),
            const SizedBox(height: 20),
            _buildSelectedDateHeader(),
            const SizedBox(height: 12),
            _buildEventsForSelectedDate(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ---------------------------------------------------------------------------
  // CALENDAR CARD
  // ---------------------------------------------------------------------------

  Widget _buildCalendarCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMonthHeader(),
          const SizedBox(height: 18),
          _buildWeekdayHeader(),
          const SizedBox(height: 8),
          _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _previousMonth,
          icon: const Icon(Icons.chevron_left),
          color: context.accent,
        ),
        Text(
          _monthName(displayedMonth),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        IconButton(
          onPressed: _nextMonth,
          icon: const Icon(Icons.chevron_right),
          color: context.accent,
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Table(
      children: [
        TableRow(
          children: weekdays.map((day) {
            return Center(
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.textFaint,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    ).day;

    // DateTime.weekday:
    // Monday = 1 ... Sunday = 7
    // Therefore the number of empty cells before day 1 is weekday - 1.
    final leadingEmptyCells = firstDayOfMonth.weekday - 1;

    final List<Widget> cells = [];

    // Empty cells before the first day of the month.
    for (int i = 0; i < leadingEmptyCells; i++) {
      cells.add(const SizedBox(height: 46));
    }

    // Actual days.
    for (int day = 1; day <= daysInMonth; day++) {
      cells.add(_buildDayCell(day));
    }

    // Empty cells after the last day so that the final row
    // always contains exactly 7 columns.
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox(height: 46));
    }

    final List<TableRow> rows = [];

    for (int i = 0; i < cells.length; i += 7) {
      rows.add(TableRow(children: cells.sublist(i, i + 7)));
    }

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows,
    );
  }

  Widget _buildDayCell(int day) {
    final date = DateTime(displayedMonth.year, displayedMonth.month, day);

    final isSelected = _isSameDay(date, selectedDate);
    final isToday = _isSameDay(date, DateTime.now());

    final hasEvents = events.any(
      (event) => _isSameDay(event['date'] as DateTime, date),
    );

    return SizedBox(
      height: 46,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDate = date;
          });
        },
        child: Center(
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : isToday
                  ? context.tintSurface
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.primary, width: 1.5)
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected || isToday
                        ? FontWeight.bold
                        : FontWeight.w500,
                    color: isSelected ? Colors.white : context.textPrimary,
                  ),
                ),
                if (hasEvents)
                  Positioned(
                    bottom: 3,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isSelected ? context.card : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SELECTED DATE
  // ---------------------------------------------------------------------------

  Widget _buildSelectedDateHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Date',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 3),
            Text(
              _fullDate(selectedDate),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
          ],
        ),
        Text(
          '${_eventsForDate(selectedDate).length} event${_eventsForDate(selectedDate).length == 1 ? '' : 's'}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: context.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildEventsForSelectedDate() {
    final selectedEvents = _eventsForDate(selectedDate);

    if (selectedEvents.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: selectedEvents.map((event) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildEventCard(event),
        );
      }).toList(),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final color = event['color'] as Color;

    return GestureDetector(
      onTap: () => _openEventDetails(event),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: context.outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 5,
              height: 75,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        size: 15,
                        color: context.textFaint,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          event['time'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.textFaint,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: context.textFaint,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          event['location'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.textFaint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.outline),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available_outlined,
            size: 45,
            color: context.textFaint,
          ),
          const SizedBox(height: 10),
          Text(
            'No events scheduled',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'There are no events on this date.',
            style: TextStyle(fontSize: 12, color: context.textFaint),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NAVIGATION / ACTIONS
  // ---------------------------------------------------------------------------

  void _openEventDetails(Map<String, dynamic> event) {
    Navigator.pushNamed(context, AppRoutes.eventDetails, arguments: event);
  }

  void _goToToday() {
    final today = DateTime.now();

    setState(() {
      selectedDate = DateTime(today.year, today.month, today.day);

      displayedMonth = DateTime(today.year, today.month);
    });
  }

  void _previousMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1);
    });
  }

  // ---------------------------------------------------------------------------
  // BOTTOM NAVIGATION
  // ---------------------------------------------------------------------------

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        }

        if (index == 1) {
          // Already on Calendar.
          return;
        }

        if (index == 2) {
          Navigator.pushReplacementNamed(context, AppRoutes.events);
        }

        if (index == 3) {
          Navigator.pushReplacementNamed(context, AppRoutes.profile);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_outlined),
          activeIcon: Icon(Icons.event),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  List<Map<String, dynamic>> _eventsForDate(DateTime date) {
    return events.where((event) {
      return _isSameDay(event['date'] as DateTime, date);
    }).toList();
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  String _monthName(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  String _fullDate(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${weekdays[date.weekday - 1]}, '
        '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
