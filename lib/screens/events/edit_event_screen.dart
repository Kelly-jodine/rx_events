import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

// Used only when the event being edited has no image of its own.
const String _fallbackEventImageUrl =
    'https://images.unsplash.com/photo-1540575467063-178a50c2df87'
    '?auto=format&fit=crop&w=1000&q=80';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final _eventNameController = TextEditingController(
    text: 'Tech Conference 2026',
  );

  final _locationController = TextEditingController(
    text: 'Rajkot Convention Hall',
  );

  final _descriptionController = TextEditingController(
    text:
        'Annual technology conference bringing together startups, developers and innovators.',
  );

  final _capacityController = TextEditingController(text: '250');

  DateTime? selectedDate = DateTime(2026, 7, 28);

  TimeOfDay startTime = const TimeOfDay(hour: 10, minute: 0);

  TimeOfDay endTime = const TimeOfDay(hour: 17, minute: 0);

  bool isPublished = true;

  @override
  void dispose() {
    _eventNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (pickedTime != null) {
      setState(() {
        startTime = pickedTime;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (pickedTime != null) {
      setState(() {
        endTime = pickedTime;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Select date';
    }

    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)} '
        '${date.year}';
  }

  String _monthName(int month) {
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

    return months[month - 1];
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  // Image passed in by Event Details, so the editor shows the same
  // picture the details screen is showing.
  String get _routeImage {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is! Map) {
      return '';
    }

    final image =
        (arguments['image'] ?? arguments['imageUrl'])?.toString().trim() ?? '';

    return image;
  }

  Widget _buildEventImage() {
    final image = _routeImage;

    if (image.startsWith('assets/')) {
      return Image.asset(
        image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder();
        },
      );
    }

    if (image.startsWith('http')) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder();
        },
      );
    }

    if (image.isNotEmpty) {
      return _buildImagePlaceholder();
    }

    return Image.network(
      _fallbackEventImageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildImagePlaceholder();
      },
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: context.tintSurface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event, size: 44, color: context.accent),
          SizedBox(height: 8),
          Text(
            'Rx Events',
            style: TextStyle(
              color: context.accent,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _pickImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker will be connected later.')),
    );
  }

  void _removeImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removing the image will be connected later.'),
      ),
    );
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Nothing is persisted yet, so the updated values are returned to
    // the calling screen instead of claiming a permanent save.
    final updatedEvent = <String, String>{
      'title': _eventNameController.text.trim(),
      'date': _formatDate(selectedDate!),
      'location': _locationController.text.trim(),
      'description': _descriptionController.text.trim(),
      'capacity': _capacityController.text.trim(),
      'time': '${_formatTime(startTime)} - ${_formatTime(endTime)}',
      'status': isPublished ? 'Upcoming' : 'Draft',
    };

    Navigator.pop(context, updatedEvent);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Changes applied to this session only. '
          'They are not saved permanently yet.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tintSurface,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Edit Event'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.notifications);
            },
            icon: const Icon(Icons.notifications_none),
            tooltip: 'Notifications',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // EVENT IMAGE
              Container(
                width: double.infinity,
                height: 190,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: context.tintSurface,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(child: _buildEventImage()),

                    Positioned(
                      top: 12,
                      right: 12,
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.camera_alt_outlined, size: 18),
                        label: const Text('Change Image'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.card,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _removeImage,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          tooltip: 'Remove image',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // EVENT NAME
              _buildLabel('Event Name', required: true),

              const SizedBox(height: 8),

              TextFormField(
                controller: _eventNameController,
                decoration: _inputDecoration(
                  hintText: 'Enter event name',
                  icon: Icons.event_outlined,
                ),
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'Please enter event name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // DATE
              _buildLabel('Date', required: true),

              const SizedBox(height: 8),

              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: _inputDecoration(
                    hintText: 'Select date',
                    icon: Icons.calendar_month_outlined,
                  ),
                  child: Text(
                    _formatDate(selectedDate),
                    style: TextStyle(fontSize: 15, color: context.textPrimary),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // START + END TIME
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Start Time', required: true),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectStartTime,
                          borderRadius: BorderRadius.circular(12),
                          child: InputDecorator(
                            decoration: _inputDecoration(
                              hintText: 'Start time',
                              icon: Icons.access_time,
                            ),
                            child: Text(
                              _formatTime(startTime),
                              style: TextStyle(
                                fontSize: 14,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('End Time', required: true),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectEndTime,
                          borderRadius: BorderRadius.circular(12),
                          child: InputDecorator(
                            decoration: _inputDecoration(
                              hintText: 'End time',
                              icon: Icons.access_time,
                            ),
                            child: Text(
                              _formatTime(endTime),
                              style: TextStyle(
                                fontSize: 14,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // LOCATION
              _buildLabel('Location', required: true),

              const SizedBox(height: 8),

              TextFormField(
                controller: _locationController,
                decoration: _inputDecoration(
                  hintText: 'Enter event location',
                  icon: Icons.location_on_outlined,
                ),
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'Please enter location';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // DESCRIPTION
              _buildLabel('Description', required: true),

              const SizedBox(height: 8),

              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                maxLength: 500,
                decoration: _inputDecoration(
                  hintText: 'Tell people about your event...',
                  icon: Icons.description_outlined,
                ),
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'Please enter description';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              // CAPACITY
              _buildLabel('Capacity', required: true),

              const SizedBox(height: 8),

              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(
                  hintText: 'Enter number of attendees',
                  icon: Icons.people_outline,
                ),
                validator: (text) {
                  if (text == null || text.trim().isEmpty) {
                    return 'Please enter capacity';
                  }

                  final capacity = int.tryParse(text);

                  if (capacity == null || capacity <= 0) {
                    return 'Please enter a valid capacity';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // EVENT STATUS
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.tintSurface),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.tintSurface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.event_available, color: context.accent),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Make this event visible to attendees.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Switch(
                      value: isPublished,
                      activeThumbColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          isPublished = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.accent,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: context.textPrimary,
        ),
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: context.accent),
      filled: true,
      fillColor: context.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}
