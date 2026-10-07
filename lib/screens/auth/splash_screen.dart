import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // ----------------------------------------------------------
    // LOGO ANIMATION
    // ----------------------------------------------------------

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    // ----------------------------------------------------------
    // NAVIGATION TO ONBOARDING
    // ----------------------------------------------------------

    _navigationTimer = Timer(const Duration(seconds: 3), _goToOnboarding);
  }

  void _goToOnboarding() {
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF063F40), Color(0xFF075E5F), Color(0xFF043638)],
          ),
        ),

        child: Stack(
          children: [
            // --------------------------------------------------
            // DECORATIVE BACKGROUND CIRCLES
            // --------------------------------------------------
            Positioned(
              top: -80,
              left: -70,
              child: _buildBackgroundCircle(size: 230, opacity: 0.08),
            ),

            Positioned(
              top: 180,
              right: -80,
              child: _buildBackgroundCircle(size: 190, opacity: 0.06),
            ),

            Positioned(
              bottom: 130,
              left: -100,
              child: _buildBackgroundCircle(size: 260, opacity: 0.05),
            ),

            Positioned(
              bottom: -100,
              right: -80,
              child: _buildBackgroundCircle(size: 240, opacity: 0.07),
            ),

            // --------------------------------------------------
            // MAIN CONTENT
            // --------------------------------------------------
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ----------------------------------------
                      // RX LOGO
                      // ----------------------------------------
                      Container(
                        width: 105,
                        height: 105,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF2DD4BF),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'R',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 52,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'ˣ',
                                  style: TextStyle(
                                    color: Color(0xFF2DD4BF),
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ----------------------------------------
                      // APP NAME
                      // ----------------------------------------
                      const Text(
                        'Rx Events',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ----------------------------------------
                      // TAGLINE
                      // ----------------------------------------
                      const Text(
                        'Plan. Manage. Celebrate.',
                        style: TextStyle(
                          color: Color(0xFFB2F5EA),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ----------------------------------------
                      // SMALL DECORATIVE LINE
                      // ----------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 1,
                            color: const Color(0xFF2DD4BF),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.event_available_outlined,
                            color: Color(0xFF2DD4BF),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 32,
                            height: 1,
                            color: const Color(0xFF2DD4BF),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --------------------------------------------------
            // LOADING SECTION
            // --------------------------------------------------
            Positioned(
              left: 0,
              right: 0,
              bottom: 75,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF2DD4BF),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Creating unforgettable events',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),

            // --------------------------------------------------
            // VERSION
            // --------------------------------------------------
            const Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Rx Events • 1.0.0',
                  style: TextStyle(color: Colors.white38, fontSize: 9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BACKGROUND CIRCLE
  // ------------------------------------------------------------

  Widget _buildBackgroundCircle({
    required double size,
    required double opacity,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2DD4BF).withValues(alpha: opacity),
      ),
    );
  }
}
