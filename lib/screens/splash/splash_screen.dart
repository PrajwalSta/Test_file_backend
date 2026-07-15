import 'dart:async';
import 'package:flutter/material.dart';

// Import login screen
import '../auth/login_screen.dart';
// Import home screen
//import '../home/home_screen.dart';
//import '../main_screen.dart';
class SplashScreen extends StatefulWidget {
  final VoidCallback? onDone;

  const SplashScreen({super.key, this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// State class handles animations and timing logic
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  
  /// Controls animation (fade + scale)
  late AnimationController _controller;

  /// Fade animation (opacity)
  late Animation<double> _fadeAnimation;

  /// Scale animation (zoom effect)
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    
    super.initState();

    // INITIALIZE ANIMATION CONTROLLER
    // -------------------------------
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Fade animation from invisible → visible
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Scale animation (zoom in effect)
    _scaleAnimation = Tween<double>(begin: 0.4, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Start animation immediately when screen loads
    _controller.forward();

    // -------------------------------
    // SPLASH TIMING CONTROL
    // -------------------------------

    // Phase 1: initial load (logo animation already started)

    Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      // Phase 2: hold state (UI stays stable)
      setState(() {});
    });

    Timer(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      // Phase 3: prepare exit (optional state update)
      setState(() {});
    });

    Timer(const Duration(milliseconds: 3000), () {
      // Final phase: navigate to next screen
      if (!mounted) return;
      if (widget.onDone != null) {
        widget.onDone!();
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    // Dispose animation controller to free memory
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: Stack(
        children: [
          // -----------------------------------
          // BACKGROUND GLOW EFFECT (DECORATION)
          // -----------------------------------
          Positioned(
            top: 120,
            left: 80,
            child: _glowCircle(280, const Color(0x807C5CFC)),
          ),

          Positioned(
            bottom: 140,
            right: 60,
            child: _glowCircle(200, const Color(0x300ECDD7)),
          ),

          // -----------------------------------
          // MAIN CONTENT (CENTER UI)
          // -----------------------------------
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // ---------------- LOGO ----------------
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF1E1445),
                            Color(0xFF2A1B6B),
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x557C5CFC),
                            blurRadius: 30,
                          )
                        ],
                      ),

                      // App Icon
                      child: const Icon(
                        Icons.hourglass_bottom,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------- APP NAME ----------------
                const Text(
                  "FocusFlow",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "Smart Life Scheduler",
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                // ---------------- LOADING DOTS ----------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.deepPurple.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Creates glowing circle background effect
  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
