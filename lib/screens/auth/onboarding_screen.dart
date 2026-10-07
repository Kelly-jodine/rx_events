import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_x.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Plan\nAmazing Events',
      'description':
          'Create events, manage bookings track\nattendees and stay organized—all in\none place.',
    },
    {
      'title': 'Manage\nYour Events',
      'description':
          'Create and manage all your events\nfrom one simple and organized place.',
    },
    {
      'title': 'Stay\nOrganized',
      'description':
          'Manage bookings, attendees, schedules\nand event activities with ease.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tintSurface,
      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // PAGE VIEW
            // ==================================================
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(
                    title: pages[index]['title']!,
                    description: pages[index]['description']!,
                    pageIndex: index,
                  );
                },
              ),
            ),

            // ==================================================
            // PAGE INDICATORS
            // ==================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (index) {
                final isActive = currentPage == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 7 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : const Color(0xFFB6D9D9),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            // ==================================================
            // GET STARTED / NEXT BUTTON
            // ==================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _handleButtonPress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: context.accentStrong.withValues(alpha: 0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    currentPage == pages.length - 1 ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 34),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ONBOARDING PAGE
  // ============================================================

  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required int pageIndex,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 55),

              // ------------------------------------------------
              // TITLE
              // ------------------------------------------------
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.textPrimary,
                  fontSize: 22,
                  height: 1.05,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // DESCRIPTION
              // ------------------------------------------------
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.textPrimary,
                  fontSize: 11,
                  height: 1.25,
                ),
              ),

              const SizedBox(height: 18),

              // ------------------------------------------------
              // ILLUSTRATION AREA
              // ------------------------------------------------
              Expanded(child: _buildIllustrationArea(pageIndex)),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // ILLUSTRATION AREA
  // ============================================================

  Widget _buildIllustrationArea(int pageIndex) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // ------------------------------------------------------
        // DECORATIVE CIRCLES
        // ------------------------------------------------------
        Positioned(top: 10, left: -18, child: _buildCircle(45)),

        Positioned(top: 12, right: 28, child: _buildCircle(48)),

        Positioned(bottom: 70, left: -15, child: _buildCircle(48)),

        Positioned(bottom: 38, right: 10, child: _buildCircle(62)),

        // ------------------------------------------------------
        // TEMPORARY ILLUSTRATION
        // ------------------------------------------------------
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white.withValues(alpha: 0.25),
              ),
              child: Icon(
                _getIllustrationIcon(pageIndex),
                size: 105,
                color: context.accent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // DECORATIVE CIRCLE
  // ============================================================

  Widget _buildCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFAFE9EC),
      ),
    );
  }

  // ============================================================
  // TEMPORARY ICON
  // ============================================================

  IconData _getIllustrationIcon(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return Icons.celebration_outlined;

      case 1:
        return Icons.event_available_outlined;

      case 2:
        return Icons.calendar_month_outlined;

      default:
        return Icons.event_outlined;
    }
  }

  // ============================================================
  // BUTTON ACTION
  // ============================================================

  void _handleButtonPress() {
    if (currentPage == pages.length - 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }
}
