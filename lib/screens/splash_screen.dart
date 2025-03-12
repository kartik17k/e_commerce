// Import required packages and libraries
import 'package:e_commerce/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/stylehub_logo.dart';

/// SplashScreen Widget
///
/// Displays a branded splash screen with animated logo at app launch.
/// Automatically navigates to the LoginScreen after a fixed duration.
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// State class for SplashScreen
///
/// Handles animation controllers and transitions for the splash screen,
/// including fade-in animation and navigation to the login screen.
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Animation controller for managing animations
  late AnimationController _controller;
  // Animation for logo opacity fade-in effect
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller with 2-second duration
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    // Create opacity animation that goes from 0 (invisible) to 1 (fully visible)
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    // Start animation and navigate to login screen after it completes
    _controller.forward().then((_) {
      // Add slight delay after animation completes before navigating
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacement(
          // Use PageRouteBuilder for custom transition animation
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Fade transition effect when navigating to login screen
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: 800),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    // Clean up animation controller when widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    // Adjust logo size based on screen size
    final logoSize = isSmallScreen ? 120.0 : 180.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // Subtle gradient background for visual interest
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFF5F5F5),
            ],
          ),
        ),
        child: Center(
          // AnimatedBuilder rebuilds when animation value changes
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Fade in the logo according to animation value
              return Opacity(
                opacity: _opacityAnimation.value,
                child: StyleHubLogo(
                  size: logoSize,
                  showText: true,
                  useGradient: true,
                  isAnimated: true,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
