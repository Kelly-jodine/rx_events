import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

class AttendeesScreen extends StatefulWidget {
  const AttendeesScreen({super.key});

  @override
  State<AttendeesScreen> createState() => _AttendeesScreenState();
}

class _AttendeesScreenState extends State<AttendeesScreen> {
  String selectedEvent = 'Annual Tech Expo 2026';
  String selectedFilter = 'All';
  String searchQuery = '';

  final List<String> events = [
    'Annual Tech Expo 2026',
    'Tech Conference 2026',
    'Wedding Expo',
    'Summer Music Festival',
  ];

  final List<Map<String, String>> attendees = [
    {
      'name': 'Hilda Faith',
      'enrollment': '24SOEC16118',
      'email': 'hilda@rxevents.com',
      'phone': '+91 9876543210',
      'event': 'Annual Tech Expo 2026',
      'seats': '2',
      'status': 'Checked-in',
      'booking': 'BK - 1025',
      'payment': 'Paid',
    },
    {
      'name': 'Kelly Jodine',
      'enrollment': '24SOEC16127',
      'email': 'kelly@email.com',
      'phone': '+91 9876543211',
      'event': 'Annual Tech Expo 2026',
      'seats': '1',
      'status': 'Not checked-in',
      'booking': 'BK - 1026',
      'payment': 'Paid',
    },
    {
      'name': 'Biira Anitah',
      'enrollment': '24SOEC16101',
      'email': 'biira@email.com',
      'phone': '+91 9876543212',
      'event': 'Annual Tech Expo 2026',
      'seats': '3',
      'status': 'Checked-in',
      'booking': 'BK - 1027',
      'payment': 'Paid',
    },
    {
      'name': 'Chimuka',
      'enrollment': '24SOEC16108',
      'email': 'chimuka@email.com',
      'phone': '+91 9876543213',
      'event': 'Annual Tech Expo 2026',
      'seats': '2',
      'status': 'Not checked-in',
      'booking': 'BK - 1028',
      'payment': 'Pending',
    },
    {
      'name': 'Sarah Johnson',
      'enrollment': '24SOEC16115',
      'email': 'sarah@email.com',
      'phone': '+91 9876543214',
      'event': 'Tech Conference 2026',
      'seats': '2',
      'status': 'Checked-in',
      'booking': 'BK - 1029',
      'payment': 'Paid',
    },
  ];

  List<Map<String, String>> get filteredAttendees {
    return attendees.where((attendee) {
      final matchesEvent = attendee['event'] == selectedEvent;

      final matchesFilter =
          selectedFilter == 'All' || attendee['status'] == selectedFilter;

      final query = searchQuery.toLowerCase();

      final matchesSearch =
          attendee['name']!.toLowerCase().contains(query) ||
          attendee['email']!.toLowerCase().contains(query) ||
          attendee['enrollment']!.toLowerCase().contains(query);

      return matchesEvent && matchesFilter && matchesSearch;
    }).toList();
  }

  int get registeredCount {
    return attendees
        .where((attendee) => attendee['event'] == selectedEvent)
        .length;
  }

  int get checkedInCount {
    return attendees.where((attendee) {
      return attendee['event'] == selectedEvent &&
          attendee['status'] == 'Checked-in';
    }).length;
  }

  int get remainingCount {
    return registeredCount - checkedInCount;
  }

  double get attendancePercentage {
    if (registeredCount == 0) {
      return 0;
    }

    return checkedInCount / registeredCount;
  }

  void _showEventSelector() {
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
                  'Select Event',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                ...events.map(
                  (event) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      selectedEvent == event
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: context.accent,
                    ),
                    title: Text(event),
                    onTap: () {
                      setState(() {
                        selectedEvent = event;
                      });

                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                  'Filter Attendees',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                _buildFilterOption('All'),
                _buildFilterOption('Checked-in'),
                _buildFilterOption('Not checked-in'),
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

  void _openAttendeeDetails(Map<String, String> attendee) {
    Navigator.pushNamed(
      context,
      AppRoutes.attendeeDetails,
      arguments: attendee,
    );
  }

  void _addAttendee() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    String event = selectedEvent;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Add Attendee'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Full name'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Phone'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: event,
                      decoration: const InputDecoration(labelText: 'Event'),
                      items: events
                          .map(
                            (name) => DropdownMenuItem(
                              value: name,
                              child: Text(
                                name,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setDialogState(() {
                          event = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();
                    final phone = phoneController.text.trim();

                    if (name.isEmpty || email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Name and email are required.'),
                        ),
                      );
                      return;
                    }

                    final position = attendees.length;

                    Navigator.pop(dialogContext);

                    setState(() {
                      attendees.insert(0, {
                        'name': name,
                        'enrollment': 'DEMO${(1000 + position).toString()}',
                        'email': email,
                        'phone': phone.isEmpty ? 'Not provided' : phone,
                        'event': event,
                        'seats': '1',
                        'status': 'Not checked-in',
                        'booking': 'BK - ${1200 + position}',
                        'payment': 'Pending',
                      });

                      selectedEvent = event;
                      selectedFilter = 'All';
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$name added locally for this session only.',
                        ),
                      ),
                    );
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,

      appBar: AppBar(
        title: const Text('Attendees'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showFilterOptions,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
          ),
          IconButton(
            onPressed: _addAttendee,
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: 'Add attendee',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EVENT SELECTOR
            GestureDetector(
              onTap: _showEventSelector,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.event,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CURRENT EVENT',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            selectedEvent,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: Colors.white70,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Rajkot, Gujarat',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ATTENDANCE SUMMARY
            Text(
              'Attendance Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          Icons.groups_outlined,
                          'Registered',
                          registeredCount.toString(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildSummaryCard(
                          Icons.person_outline,
                          'Checked-in',
                          checkedInCount.toString(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildSummaryCard(
                          Icons.person_off_outlined,
                          'Remaining',
                          remainingCount.toString(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Text(
                        'Attendance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${(attendancePercentage * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: attendancePercentage,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // SEARCH
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search name, email or enrollment...',
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
                  _buildFilterChip('Checked-in'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Not checked-in'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // LIST HEADER
            Row(
              children: [
                Text(
                  'Attendees',
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
                    filteredAttendees.length.toString(),
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

            // ATTENDEES LIST
            filteredAttendees.isEmpty
                ? _buildEmptyState()
                : Column(
                    children: filteredAttendees
                        .map(_buildAttendeeCard)
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: context.accent, size: 22),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, color: Colors.grey),
          ),
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

  Widget _buildAttendeeCard(Map<String, String> attendee) {
    final isCheckedIn = attendee['status'] == 'Checked-in';

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        _openAttendeeDetails(attendee);
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
                // AVATAR
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.tintSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      attendee['name']!.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: context.accentStrong,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // NAME
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendee['name']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        attendee['enrollment']!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // STATUS
                _buildStatusBadge(attendee['status']!, isCheckedIn),
              ],
            ),

            const SizedBox(height: 14),

            const Divider(height: 1),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.email_outlined, size: 16, color: context.accent),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    attendee['email']!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Icon(Icons.people_outline, size: 16, color: context.accent),
                const SizedBox(width: 5),
                Text(
                  '${attendee['seats']} seats',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  size: 16,
                  color: context.accent,
                ),
                const SizedBox(width: 7),
                Text(
                  attendee['booking']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
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

  Widget _buildStatusBadge(String status, bool isCheckedIn) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isCheckedIn ? context.tintSurface : context.warningSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCheckedIn ? Icons.check_circle_outline : Icons.access_time,
            size: 13,
            color: isCheckedIn ? context.accentStrong : context.warningText,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: isCheckedIn ? context.accentStrong : context.warningText,
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
          Icon(Icons.person_search_outlined, size: 55, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No attendees found',
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
