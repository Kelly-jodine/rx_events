import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  String selectedFilter = 'All';
  String searchQuery = '';

  final List<Map<String, String>> employees = [
    {
      'name': 'Sarah Johnson',
      'email': 'sarah@email.com',
      'phone': '+91 9876543210',
      'position': 'Event Manager',
      'department': 'Management',
      'status': 'Active',
      'joined': '12 January 2026',
      'events': '5',
    },
    {
      'name': 'Michael Brown',
      'email': 'michael@email.com',
      'phone': '+91 9876543211',
      'position': 'Event Coordinator',
      'department': 'Operations',
      'status': 'Active',
      'joined': '20 February 2026',
      'events': '3',
    },
    {
      'name': 'Anita Sharma',
      'email': 'anita@email.com',
      'phone': '+91 9876543212',
      'position': 'Registration Staff',
      'department': 'Operations',
      'status': 'Active',
      'joined': '5 March 2026',
      'events': '4',
    },
    {
      'name': 'David Wilson',
      'email': 'david@email.com',
      'phone': '+91 9876543213',
      'position': 'Event Assistant',
      'department': 'Support',
      'status': 'Inactive',
      'joined': '18 April 2026',
      'events': '1',
    },
    {
      'name': 'Priya Patel',
      'email': 'priya@email.com',
      'phone': '+91 9876543214',
      'position': 'Event Coordinator',
      'department': 'Operations',
      'status': 'Active',
      'joined': '2 May 2026',
      'events': '6',
    },
  ];

  List<Map<String, String>> get filteredEmployees {
    return employees.where((employee) {
      final matchesFilter =
          selectedFilter == 'All' || employee['status'] == selectedFilter;

      final query = searchQuery.toLowerCase();

      final matchesSearch =
          employee['name']!.toLowerCase().contains(query) ||
          employee['email']!.toLowerCase().contains(query) ||
          employee['position']!.toLowerCase().contains(query) ||
          employee['department']!.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  int get activeEmployees {
    return employees.where((employee) => employee['status'] == 'Active').length;
  }

  int get inactiveEmployees {
    return employees
        .where((employee) => employee['status'] == 'Inactive')
        .length;
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
                  'Filter Employees',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                _buildFilterOption('All'),
                _buildFilterOption('Active'),
                _buildFilterOption('Inactive'),
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

  void _openEmployeeDetails(Map<String, String> employee) {
    Navigator.pushNamed(
      context,
      AppRoutes.employeeDetails,
      arguments: employee,
    );
  }

  void _addEmployee() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final positionController = TextEditingController();
    String department = 'Operations';

    const departments = ['Operations', 'Management', 'Support', 'Production'];

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Add Employee'),
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
                      controller: positionController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Position'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: department,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                      ),
                      items: departments
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
                          department = value;
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
                    final position = positionController.text.trim();

                    if (name.isEmpty || email.isEmpty || position.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Name, email and position are required.',
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(dialogContext);

                    setState(() {
                      employees.insert(0, {
                        'name': name,
                        'email': email,
                        'phone': 'Not provided',
                        'position': position,
                        'department': department,
                        'status': 'Active',
                        'joined': 'Added today (demo)',
                        'events': '0',
                      });

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
      positionController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,

      appBar: AppBar(
        title: const Text('Employees'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showFilterOptions,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
          ),
          IconButton(
            onPressed: _addEmployee,
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: 'Add Employee',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Team Members',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${employees.length} employees in your team',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.tintSurface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.groups_outlined,
                    color: context.accent,
                    size: 28,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // SUMMARY
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    Icons.people_outline,
                    'Total',
                    employees.length.toString(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryCard(
                    Icons.check_circle_outline,
                    'Active',
                    activeEmployees.toString(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryCard(
                    Icons.person_off_outlined,
                    'Inactive',
                    inactiveEmployees.toString(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // SEARCH
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search name, email or position...',
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
                  _buildFilterChip('Active'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Inactive'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // LIST TITLE
            Row(
              children: [
                Text(
                  'Employees',
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
                    filteredEmployees.length.toString(),
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

            // EMPLOYEE LIST
            filteredEmployees.isEmpty
                ? _buildEmptyState()
                : Column(
                    children: filteredEmployees
                        .map(_buildEmployeeCard)
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(16),
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
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
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

  Widget _buildEmployeeCard(Map<String, String> employee) {
    final isActive = employee['status'] == 'Active';

    final initial = employee['name']!.substring(0, 1).toUpperCase();

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        _openEmployeeDetails(employee);
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
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: context.tintSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: TextStyle(
                        color: context.accentStrong,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // NAME + POSITION
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee['name']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        employee['position']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                _buildStatusBadge(employee['status']!, isActive),
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
                    employee['email']!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.business_outlined, size: 16, color: context.accent),
                const SizedBox(width: 7),
                Text(
                  employee['department']!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const Spacer(),

                Icon(Icons.event_outlined, size: 16, color: context.accent),
                const SizedBox(width: 5),
                Text(
                  '${employee['events']} events',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  'Joined ${employee['joined']}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
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

  Widget _buildStatusBadge(String status, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? context.tintSurface : context.cardAlt,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle_outline : Icons.pause_circle_outline,
            size: 13,
            color: isActive ? context.accentStrong : context.textMuted,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: isActive ? context.accentStrong : context.textMuted,
              fontSize: 10,
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
            'No employees found',
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
