import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

// Keeps a failed network image from surfacing Flutter's default
// error tile.
void _ignoreImageError(Object exception, StackTrace? stackTrace) {}

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
      backgroundColor: AppColors.light,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Edit Event'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1540575467063-178a50c2df87'
                      '?auto=format&fit=crop&w=1000&q=80',
                    ),
                    fit: BoxFit.cover,
                    onError: _ignoreImageError,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 12,
                      right: 12,
                      child: ElevatedButton.icon(
                        onPressed: () {},
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
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
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
                    style: const TextStyle(fontSize: 15, color: AppColors.text),
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
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.text,
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
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.text,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.light),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.light,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.event_available,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
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
                        foregroundColor: AppColors.primary,
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
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
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
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}
