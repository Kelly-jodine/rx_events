import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  Map<Object?, Object?> _sessionEdits = const {};

  Future<void> _openEditEvent() async {
    final updatedEvent = await Navigator.pushNamed<Object?>(
      context,
      AppRoutes.editEvent,
      arguments: _currentEvent(),
    );

    if (!mounted || updatedEvent is! Map<Object?, Object?>) {
      return;
    }

    setState(() {
      _sessionEdits = updatedEvent;
    });
  }

  Map<Object?, Object?> _currentEvent() {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    final routeEvent = arguments is Map<Object?, Object?>
        ? arguments
        : const <Object?, Object?>{};

    return <Object?, Object?>{
      ...routeEvent,
      ..._sessionEdits,
    };
  }

  @override
  Widget build(BuildContext context) {
    final event = _currentEvent();

    final title = _readText(
      event,
      'title',
      fallback: _readText(
        event,
        'name',
        fallback: 'Event Details',
      ),
    );

    final status = _readText(event, 'status');

    final imagePath = _readText(
      event,
      'image',
      fallback: _readText(event, 'imageUrl'),
    );

    final parsedDate = _parseDate(event['date']);

    final dateLabel = parsedDate != null
        ? '${parsedDate.day} '
              '${_monthName(parsedDate.month)} '
              '${parsedDate.year}'
        : _readText(event, 'date');

    final weekdayLabel = parsedDate != null
        ? _weekdayName(parsedDate.weekday)
        : 'Event date';

    final timeLabel = _readTimeRange(event);

    final timeZoneLabel = _readText(
      event,
      'timeZone',
      fallback: 'Local time',
    );

    final location = _readText(
      event,
      'location',
      fallback: _readText(
        event,
        'venue',
        fallback: 'Location to be announced',
      ),
    );

    final address = _readText(
      event,
      'address',
      fallback: _readText(
        event,
        'city',
        fallback: 'Event venue',
      ),
    );

    final attendees =
        _readInt(event, 'attendees') ??
        _readInt(event, 'registeredCount') ??
        _readInt(event, 'registered');

    final capacity =
        _readInt(event, 'capacity') ??
        _readInt(event, 'maxAttendees');

    final String attendeesTitle;
    final String attendeesSubtitle;

    if (attendees != null && capacity != null) {
      attendeesTitle = '$attendees Registered';
      attendeesSubtitle = 'of $capacity capacity';
    } else if (attendees != null) {
      attendeesTitle = '$attendees Registered';
      attendeesSubtitle = 'Registered';
    } else if (capacity != null) {
      attendeesTitle = '$capacity Capacity';
      attendeesSubtitle = 'Capacity';
    } else {
      attendeesTitle = 'Not available';
      attendeesSubtitle = 'Registration';
    }

    final description = _readText(
      event,
      'description',
    );

    final summary = _readText(
      event,
      'summary',
      fallback: description,
    );

    final blurb = summary.isEmpty
        ? 'No description provided for this event.'
        : summary;

    final details = description.isEmpty
        ? blurb
        : description;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Event Details'),
        actions: [
          IconButton(
            onPressed: _openEditEvent,
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Event',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EVENT IMAGE
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 230,
                  child: imagePath.isEmpty
                      ? _buildImagePlaceholder()
                      : imagePath.startsWith('assets/')
                          ? Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return _buildImagePlaceholder();
                              },
                            )
                          : Image.network(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return _buildImagePlaceholder();
                              },
                            ),
                ),

                // STATUS
                if (status.isNotEmpty)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                // IMAGE COUNTER
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '1/1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // EVENT INFORMATION
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildCircleAction(
                        icon: Icons.share_outlined,
                      ),
                      const SizedBox(width: 8),
                      _buildCircleAction(
                        icon: Icons.favorite_border,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    blurb,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.blueGrey,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // DATE + TIME
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          icon:
                              Icons.calendar_month_outlined,
                          title: dateLabel.isEmpty
                              ? 'Date to be announced'
                              : dateLabel,
                          subtitle: weekdayLabel,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          icon:
                              Icons.access_time_outlined,
                          title: timeLabel.isEmpty
                              ? 'Time to be announced'
                              : timeLabel,
                          subtitle: timeZoneLabel,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // LOCATION + ATTENDEES
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          icon:
                              Icons.location_on_outlined,
                          title: location,
                          subtitle: address,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          icon: Icons.people_outline,
                          title: attendeesTitle,
                          subtitle: attendeesSubtitle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // DESCRIPTION
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child:
                            const Text('Read more'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    details,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.blueGrey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // FEATURES
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: [
                  _buildFeature(
                    icon: Icons.people_outline,
                    title: 'Networking',
                  ),
                  _buildFeature(
                    icon: Icons.mic_none,
                    title: 'Speakers',
                  ),
                  _buildFeature(
                    icon: Icons.co_present_outlined,
                    title: 'Workshops',
                  ),
                  _buildFeature(
                    icon:
                        Icons.workspace_premium_outlined,
                    title: 'Certificate',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ORGANIZER
            Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Organizer',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.light,
                        child: Icon(
                          Icons.event,
                          size: 30,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rx Events',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Plan • Organize • Create Amazing Events',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      OutlinedButton(
                        onPressed: () {},
                        child:
                            const Text('View Profile'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ACTION BUTTONS
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                      ),
                      label:
                          const Text('Add to Calendar'),
                      style:
                          OutlinedButton.styleFrom(
                        foregroundColor:
                            AppColors.primary,
                        side: const BorderSide(
                          color: AppColors.primary,
                        ),
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _openEditEvent,
                      icon: const Icon(
                        Icons.edit_outlined,
                      ),
                      label:
                          const Text('Edit Event'),
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primary,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleAction({
    required IconData icon,
  }) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: AppColors.light,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.primary,
        size: 21,
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: AppColors.light,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 21,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.light,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  static String _readText(
    Map<Object?, Object?> event,
    String key, {
    String fallback = '',
  }) {
    final value = event[key];

    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();

    return text.isEmpty ? fallback : text;
  }

  static int? _readInt(
    Map<Object?, Object?> event,
    String key,
  ) {
    final value = event[key];

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value?.toString().trim() ?? '',
    );
  }

  static String _readTimeRange(
    Map<Object?, Object?> event,
  ) {
    final range = _readText(event, 'time');

    if (range.isNotEmpty) {
      return range;
    }

    final start = _readText(event, 'start');
    final end = _readText(event, 'end');

    if (start.isNotEmpty && end.isNotEmpty) {
      return '$start - $end';
    }

    return start.isNotEmpty ? start : end;
  }

  static DateTime? _parseDate(Object? value) {
    if (value is DateTime) {
      return value;
    }

    final text = value?.toString().trim() ?? '';

    if (text.isEmpty) {
      return null;
    }

    final parsed = DateTime.tryParse(text);

    if (parsed != null) {
      return parsed;
    }

    final parts = text.split(RegExp(r'\s+'));

    if (parts.length != 3) {
      return null;
    }

    final day = int.tryParse(parts[0]);
    final month = _monthFromName(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return null;
    }

    return DateTime(year, month, day);
  }

  static int? _monthFromName(String name) {
    const months = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];

    final index =
        months.indexOf(name.toLowerCase());

    return index == -1 ? null : index + 1;
  }

  static String _monthName(int month) {
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

    if (month < 1 || month > 12) {
      return '';
    }

    return months[month - 1];
  }

  static String _weekdayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    if (weekday < 1 || weekday > 7) {
      return '';
    }

    return days[weekday - 1];
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.light,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 50,
          color: AppColors.primary,
        ),
      ),
    );
  }
}