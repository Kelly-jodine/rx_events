import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';

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
      final matchesFilter = selectedFilter == 'All' ||
          employee['status'] == selectedFilter;

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
    return employees
        .where((employee) => employee['status'] == 'Active')
        .length;
  }

  int get inactiveEmployees {
    return employees
        .where((employee) => employee['status'] == 'Inactive')
        .length;
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Employees',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
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
        isSelected
            ? Icons.radio_button_checked
            : Icons.radio_button_unchecked,
        color: AppColors.primary,
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Add Employee will be connected to the database later.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

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
                      const Text(
                        'Team Members',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
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
                    color: AppColors.light,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.groups_outlined,
                    color: AppColors.primary,
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
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
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
                const Text(
                  'Employees',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.light,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    filteredEmployees.length.toString(),
                    style: const TextStyle(
                      color: AppColors.dark,
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

  Widget _buildSummaryCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 22,
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
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
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.text,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: isSelected
            ? AppColors.primary
            : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildEmployeeCard(
    Map<String, String> employee,
  ) {
    final isActive = employee['status'] == 'Active';

    final initial = employee['name']!
        .substring(0, 1)
        .toUpperCase();

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
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade100,
          ),
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
                    color: AppColors.light,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: AppColors.dark,
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
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
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

                _buildStatusBadge(
                  employee['status']!,
                  isActive,
                ),
              ],
            ),

            const SizedBox(height: 14),

            const Divider(height: 1),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    employee['email']!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.business_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 7),
                Text(
                  employee['department']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const Spacer(),

                const Icon(
                  Icons.event_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  '${employee['events']} events',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
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
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),

                const Spacer(),

                const Text(
                  'View Details →',
                  style: TextStyle(
                    color: AppColors.primary,
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

  Widget _buildStatusBadge(
    String status,
    bool isActive,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.light
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive
                ? Icons.check_circle_outline
                : Icons.pause_circle_outline,
            size: 13,
            color: isActive
                ? AppColors.dark
                : Colors.grey.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: isActive
                  ? AppColors.dark
                  : Colors.grey.shade700,
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
      padding: const EdgeInsets.symmetric(
        vertical: 50,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.person_search_outlined,
            size: 55,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            'No employees found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Try another search or filter.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}