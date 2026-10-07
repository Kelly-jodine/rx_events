import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String selectedFilter = 'All';

  final List<Map<String, String>> events = [
    {
      'title': 'Annual Business Meetup',
      'date': '20 September 2026',
      'location': 'Rajkot',
      'status': 'Upcoming',
      'image': 'assets/images/business_event.jpg',
    },
    {
      'title': 'Tech Conference 2026',
      'date': '28 September 2026',
      'location': 'Ahmedabad',
      'status': 'Upcoming',
      'image': 'assets/images/tech_event.jpg',
    },
    {
      'title': 'Corporate Event',
      'date': '12 October 2026',
      'location': 'Rajkot',
      'status': 'Upcoming',
      'image': 'assets/images/corporate_event.jpg',
    },
    {
      'title': 'Music Festival',
      'date': '5 October 2026',
      'location': 'Surat',
      'status': 'Draft',
      'image': 'assets/images/music_festival.jpg',
    },
  ];

  List<Map<String, String>> get filteredEvents {
    if (selectedFilter == 'All') {
      return events;
    }

    return events.where((event) => event['status'] == selectedFilter).toList();
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Events',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 15),
                _buildFilterOption('All'),
                _buildFilterOption('Upcoming'),
                _buildFilterOption('Draft'),
                _buildFilterOption('Completed'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String filter) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        selectedFilter == filter
            ? Icons.radio_button_checked
            : Icons.radio_button_unchecked,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Events',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              decoration: InputDecoration(
                hintText: 'Search events...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: context.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showFilterOptions,
                    icon: const Icon(Icons.filter_list),
                    label: Text(
                      selectedFilter == 'All' ? 'Filter' : selectedFilter,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.accent,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final createdEvent = await Navigator.pushNamed<Object?>(
                        context,
                        AppRoutes.createEvent,
                      );

                      if (!mounted || createdEvent is! Map<String, String>) {
                        return;
                      }

                      setState(() {
                        events.add(createdEvent);
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: filteredEvents.isEmpty
                  ? const Center(
                      child: Text(
                        'No events found.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredEvents.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];

                        return _buildEventCard(event: event);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard({required Map<String, String> event}) {
    final title = event['title'] ?? '';
    final date = event['date'] ?? '';
    final location = event['location'] ?? '';
    final status = event['status'] ?? '';
    final image = event['image'] ?? '';

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.eventDetails,
            arguments: event,
          );
        },
        child: SizedBox(
          height: 145,
          child: Row(
            children: [
              SizedBox(
                width: 125,
                height: double.infinity,
                child: image.isEmpty
                    ? _buildImageFallback()
                    : Image.asset(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImageFallback();
                        },
                      ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: status == 'Draft'
                                  ? context.warningSurface
                                  : context.tintSurface,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: status == 'Draft'
                                    ? context.warningText
                                    : context.accentStrong,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 15,
                            color: context.accent,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              date,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
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
                            color: context.accent,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.eventDetails,
                              arguments: event,
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'View Details →',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      color: context.tintSurface,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event, size: 34, color: context.accent),
          SizedBox(height: 6),
          Text(
            'Rx Events',
            style: TextStyle(
              color: context.accent,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
