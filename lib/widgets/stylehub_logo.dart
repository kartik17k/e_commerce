// Import required packages and libraries
import 'package:flutter/material.dart';
import '../config/theme.dart';

/// StyleHubLogo Widget
/// 
/// A customizable logo widget for the StyleHub e-commerce application.
/// Features include:
/// - Customizable size and appearance
/// - Optional text display
/// - Gradient or solid color background
/// - Animation effects
/// 
/// Used across the app for branding, particularly in the splash screen.
class StyleHubLogo extends StatelessWidget {
  /// Size of the logo square in logical pixels
  final double size;
  /// Whether to show the brand name and tagline below the logo
  final bool showText;
  /// Whether to use a gradient background or solid color
  final bool useGradient;
  /// Whether to apply entrance animation effect
  final bool isAnimated;

  /// Constructor with default values for easy customization
  const StyleHubLogo({
    Key? key,
    this.size = 120,
    this.showText = true,
    this.useGradient = true,
    this.isAnimated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the main logo container with styling and icons
    final logoWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // Apply gradient if enabled, otherwise use solid primary color
        gradient: useGradient ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor,
          ],
        ) : null,
        color: useGradient ? null : AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        // Add subtle shadow for depth
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      // Stack two icons for a layered logo effect
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background shopping bag icon with reduced opacity
          Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white.withOpacity(0.3),
            size: size * 0.8,
          ),
          // Foreground style icon at full opacity
          Icon(
            Icons.style_outlined,
            color: Colors.white,
            size: size * 0.5,
          ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Apply animation if enabled
        if (isAnimated)
          TweenAnimationBuilder<double>(
            // Scale animation from 80% to 100% with elastic bounce effect
            tween: Tween(begin: 0.8, end: 1.0),
            duration: Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            builder: (context, value, child) => Transform.scale(
              scale: value,
              child: child,
            ),
            child: logoWidget,
          )
        else
          logoWidget,
        // Optional text display below logo
        if (showText) ...[
          SizedBox(height: size * 0.2),
          // Brand name text
          Text(
            'StyleHub',
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: size * 0.3,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              letterSpacing: 1.2,
            ),
          ),
          // Brand tagline text
          Text(
            'Fashion at your fingertips',
            style: TextStyle(
              color: AppTheme.greyColor,
              fontSize: size * 0.15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}
