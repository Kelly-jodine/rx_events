import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final _eventNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _capacityController = TextEditingController();

  DateTime? selectedDate;

  TimeOfDay? startTime;

  TimeOfDay? endTime;

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
      initialDate: DateTime.now(),
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
      initialTime: TimeOfDay.now(),
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
      initialTime: TimeOfDay.now(),
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

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'Select time';
    }

    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  void _createEvent() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an event date')),
      );
      return;
    }

    if (startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start time')),
      );
      return;
    }

    if (endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an end time')),
      );
      return;
    }

    // Nothing is persisted yet, so the new event is returned to the
    // calling screen instead of claiming a permanent save.
    final createdEvent = <String, String>{
      'title': _eventNameController.text.trim(),
      'date': _formatDate(selectedDate!),
      'location': _locationController.text.trim(),
      'status': 'Draft',
      'image': '',
      'description': _descriptionController.text.trim(),
      'capacity': _capacityController.text.trim(),
      'time': '${_formatTime(startTime)} - ${_formatTime(endTime)}',
    };

    Navigator.pop(context, createdEvent);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Event added to this session only. '
          'It is not saved permanently yet.',
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
        title: const Text('Create Event'),
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
              // INTRODUCTION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Let’s Create Something Amazing',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Fill in the details to create '
                            'your event.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        color: AppColors.light,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.event_available,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // EVENT IMAGE
              Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Image picker will be connected later.'),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    margin: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primary, width: 1.2),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 42,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Add Event Image',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Tap to upload an image',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

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
                    style: TextStyle(
                      fontSize: 15,
                      color: selectedDate == null
                          ? Colors.grey
                          : AppColors.text,
                    ),
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
                                color: startTime == null
                                    ? Colors.grey
                                    : AppColors.text,
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
                                color: endTime == null
                                    ? Colors.grey
                                    : AppColors.text,
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
                      onPressed: _createEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Create Event'),
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
