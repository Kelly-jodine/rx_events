import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rx_events/core/data/demo_events.dart';
import 'package:rx_events/core/routes/app_routes.dart';
import 'package:rx_events/core/theme/app_theme.dart';
import 'package:rx_events/core/theme/theme_controller.dart';
import 'package:rx_events/screens/Bookings/bookings_screen.dart';
import 'package:rx_events/screens/attendees/attendees_screen.dart';
import 'package:rx_events/screens/attendees/attendee_details.dart';
import 'package:rx_events/screens/auth/forgot_password_screen.dart';
import 'package:rx_events/screens/auth/login_screen.dart';
import 'package:rx_events/screens/calendar/calendar_screen.dart';
import 'package:rx_events/screens/dashboard/dashboard_screen.dart';
import 'package:rx_events/screens/employees/employee_details.dart';
import 'package:rx_events/screens/employees/employees_screen.dart';
import 'package:rx_events/screens/events/event_details_screen.dart';
import 'package:rx_events/screens/events/events_screen.dart';
import 'package:rx_events/screens/notifications/notifications_screen.dart';
import 'package:rx_events/screens/payments/payments_screen.dart';
import 'package:rx_events/screens/payments/payment_details.dart';
import 'package:rx_events/screens/profile/profile_screen.dart';
import 'package:rx_events/screens/reports/reports_screen.dart';
import 'package:rx_events/screens/settings/settings_screen.dart';

void main() {
  group('Notifications', () {
    Future<void> pumpNotifications(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {
            AppRoutes.bookings: (_) =>
                Scaffold(appBar: AppBar(), body: const Text('BOOKINGS_SCREEN')),
            AppRoutes.payments: (_) =>
                Scaffold(appBar: AppBar(), body: const Text('PAYMENTS_SCREEN')),
          },
          home: const NotificationsScreen(),
        ),
      );

      await tester.pumpAndSettle();
    }

    testWidgets('renders the local dataset and derived statistics', (
      tester,
    ) async {
      await pumpNotifications(tester);

      // Top statistics come from the dataset (9 items, 5 unread, 2 important).
      expect(find.text('9'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);

      // Notification cards are present in the body of the screen.
      expect(find.text('New booking received'), findsOneWidget);
      expect(find.text('Payment received'), findsOneWidget);
      expect(find.text('Event starts in 2 days'), findsOneWidget);

      // Scroll to the end of the list to prove the rest is rendered too.
      await tester.drag(find.byType(ListView), const Offset(0, -1200));
      await tester.pumpAndSettle();

      expect(find.text('Attendees checked in'), findsOneWidget);
      expect(find.text('Booking cancelled'), findsOneWidget);
    });

    testWidgets('category filter and search narrow the visible list', (
      tester,
    ) async {
      await pumpNotifications(tester);

      await tester.tap(find.text('Payments'));
      await tester.pumpAndSettle();

      expect(find.text('Payment received'), findsOneWidget);
      expect(find.text('Payment still pending'), findsOneWidget);
      expect(find.text('Employee assigned'), findsNothing);

      await tester.tap(find.text('All').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Chimuka');
      await tester.pumpAndSettle();

      expect(find.text('New booking received'), findsOneWidget);
      expect(find.text('Payment received'), findsNothing);
    });

    testWidgets('tapping a notification marks it read and opens its screen', (
      tester,
    ) async {
      await pumpNotifications(tester);

      await tester.tap(find.text('New booking received'));
      await tester.pumpAndSettle();

      expect(find.text('BOOKINGS_SCREEN'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();

      // One notification was marked as read, so Unread dropped from 5 to 4.
      expect(find.text('9'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });
  });

  group('Dark mode', () {
    final screens = <String, Widget>{
      'dashboard': const DashboardScreen(),
      'events': const EventsScreen(),
      'event details': const EventDetailsScreen(),
      'calendar': const CalendarScreen(),
      'bookings': const BookingsScreen(),
      'attendees': const AttendeesScreen(),
      'attendee details': const AttendeeDetailsScreen(),
      'employees': const EmployeesScreen(),
      'employee details': const EmployeeDetailsScreen(),
      'payments': const PaymentsScreen(),
      'payment details': const PaymentDetailsScreen(),
      'reports': const ReportsScreen(),
      'notifications': const NotificationsScreen(),
      'profile': const ProfileScreen(),
      'settings': const SettingsScreen(),
    };

    testWidgets('every major screen builds with a dark scaffold', (
      tester,
    ) async {
      ThemeController.setDarkMode(true);
      addTearDown(() => ThemeController.setDarkMode(false));

      for (final entry in screens.entries) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            home: entry.value,
          ),
        );

        await tester.pumpAndSettle();

        final scaffoldFinder = find.byType(Scaffold).first;
        final scaffold = tester.widget<Scaffold>(scaffoldFinder);
        final theme = Theme.of(tester.element(scaffoldFinder));

        expect(
          scaffold.backgroundColor ?? theme.scaffoldBackgroundColor,
          const Color(0xFF0F172A),
          reason: '${entry.key} should use the dark scaffold background',
        );
      }
    });

    testWidgets('cards use the dark surface colour in dark mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          home: const NotificationsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final darkSurfaces = find.byWidgetPredicate((widget) {
        if (widget is! Container) {
          return false;
        }

        final decoration = widget.decoration;

        return decoration is BoxDecoration &&
            decoration.color == const Color(0xFF1E293B);
      });

      expect(darkSurfaces, findsWidgets);

      final lightSurfaces = find.byWidgetPredicate((widget) {
        if (widget is! Container) {
          return false;
        }

        final decoration = widget.decoration;

        return decoration is BoxDecoration && decoration.color == Colors.white;
      });

      expect(lightSurfaces, findsNothing);
    });

    testWidgets('light mode keeps the original white cards', (tester) async {
      ThemeController.setDarkMode(false);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          home: const NotificationsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final whiteSurfaces = find.byWidgetPredicate((widget) {
        if (widget is! Container) {
          return false;
        }

        final decoration = widget.decoration;

        return decoration is BoxDecoration && decoration.color == Colors.white;
      });

      expect(whiteSurfaces, findsWidgets);
    });
  });

  group('Event details data flow', () {
    Finder assetImage(String assetName) => find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == assetName,
    );

    testWidgets('shows the event data passed through the route', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {AppRoutes.eventDetails: (_) => const EventDetailsScreen()},
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.eventDetails,
                    arguments: DemoEvents.byTitle('Annual Business Meetup'),
                  ),
                  child: const Text('OPEN_EVENT'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('OPEN_EVENT'));
      await tester.pumpAndSettle();

      expect(find.text('Annual Business Meetup'), findsWidgets);
      expect(find.textContaining('full-day meetup'), findsWidgets);
      expect(assetImage('assets/images/business_event.jpg'), findsWidgets);
      expect(find.text('120 Registered'), findsWidgets);
    });

    testWidgets('feature chips open local demo information', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {AppRoutes.eventDetails: (_) => const EventDetailsScreen()},
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.eventDetails,
                    arguments: DemoEvents.byTitle('Tech Conference 2026'),
                  ),
                  child: const Text('OPEN_EVENT'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('OPEN_EVENT'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Networking'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Networking'));
      await tester.pumpAndSettle();

      expect(find.text('Networking Session'), findsOneWidget);
      expect(find.textContaining('Tech Conference 2026'), findsWidgets);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Networking Session'), findsNothing);
    });

    testWidgets('a dashboard event opens its own details with its image', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {AppRoutes.eventDetails: (_) => const EventDetailsScreen()},
          home: const DashboardScreen(),
        ),
      );

      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Annual Business Meetup'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Annual Business Meetup'));
      await tester.pumpAndSettle();

      expect(find.text('Annual Business Meetup'), findsWidgets);
      expect(assetImage('assets/images/business_event.jpg'), findsWidgets);
      expect(find.textContaining('founders, managers'), findsWidgets);
    });

    testWidgets('a top performing report event opens that same event', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {AppRoutes.eventDetails: (_) => const EventDetailsScreen()},
          home: const ReportsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Music Festival'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Music Festival'));
      await tester.pumpAndSettle();

      expect(find.text('Music Festival'), findsWidgets);
      expect(assetImage('assets/images/music_festival.jpg'), findsWidgets);
      expect(find.text('Draft'), findsWidgets);
    });
  });

  group('Login forgot password', () {
    testWidgets('validates the email and shows a demo confirmation', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {
            AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
          },
          home: const LoginScreen(),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordScreen), findsOneWidget);

      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'not-an-email');
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'hilda@rxevents.com');
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Demo mode: password reset instructions would be sent to this email.',
        ),
        findsOneWidget,
      );
    });
  });

  group('Settings terms', () {
    testWidgets('the terms tile opens the local terms view', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.lightTheme, home: const SettingsScreen()),
      );

      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Terms & Conditions'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Terms & Conditions'));
      await tester.pumpAndSettle();

      expect(find.text('Use of the platform'), findsOneWidget);
      expect(find.text('Event management responsibilities'), findsOneWidget);
      expect(find.text('Booking information'), findsOneWidget);
      expect(find.text('Payments'), findsOneWidget);
      expect(find.text('Account security'), findsOneWidget);
      expect(find.text('Updates to these terms'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Use of the platform'), findsNothing);
    });
  });
}
