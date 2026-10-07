import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/events/events_screen.dart';
import 'screens/events/event_details_screen.dart';
import 'screens/events/edit_event_screen.dart';
import 'screens/events/create_event_screen.dart';
import 'screens/Bookings/bookings_screen.dart';
import 'screens/Bookings/booking_details_screen.dart';
import 'screens/attendees/attendee_details.dart';
import 'screens/attendees/attendees_screen.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/employees/employees_screen.dart';
import 'screens/employees/employee_details.dart';
import 'screens/payments/payments_screen.dart';
import 'screens/payments/payment_details.dart';
import 'screens/reports/reports_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/settings/settings_screen.dart';

void main() {
  runApp(const RxEventsApp());
}

class RxEventsApp extends StatelessWidget {
  const RxEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeController.isDarkMode,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'Rx Events',

          theme: AppTheme.lightTheme,

          darkTheme: AppTheme.darkTheme,

          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

          initialRoute: AppRoutes.splash,

          routes: {
            AppRoutes.splash: (context) => const SplashScreen(),
            AppRoutes.onboarding: (context) => const OnboardingScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.register: (context) => const RegisterScreen(),
            AppRoutes.dashboard: (context) => const DashboardScreen(),
            AppRoutes.events: (context) => const EventsScreen(),
            AppRoutes.eventDetails: (context) => const EventDetailsScreen(),
            AppRoutes.editEvent: (context) => const EditEventScreen(),
            AppRoutes.createEvent: (context) => const CreateEventScreen(),
            AppRoutes.bookings: (context) => const BookingsScreen(),
            AppRoutes.bookingDetails: (context) => const BookingDetailsScreen(),
            AppRoutes.attendees: (context) => const AttendeesScreen(),
            AppRoutes.attendeeDetails: (context) =>
                const AttendeeDetailsScreen(),
            AppRoutes.calendar: (context) => const CalendarScreen(),
            AppRoutes.employees: (context) => const EmployeesScreen(),
            AppRoutes.employeeDetails: (context) =>
                const EmployeeDetailsScreen(),
            AppRoutes.payments: (context) => const PaymentsScreen(),
            AppRoutes.paymentDetails: (context) => const PaymentDetailsScreen(),
            AppRoutes.reports: (context) => const ReportsScreen(),
            AppRoutes.notifications: (context) => const NotificationsScreen(),
            AppRoutes.profile: (context) => const ProfileScreen(),
            AppRoutes.editProfile: (context) => const EditProfileScreen(),
            AppRoutes.settings: (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}
