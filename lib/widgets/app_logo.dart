// Import required packages and libraries
import 'package:flutter/material.dart';
import '../config/theme.dart';

/// AppLogo Widget
/// 
/// A compact logo widget for the StyleHub e-commerce application.
/// Used primarily in app bars and headers throughout the application.
/// Features include:
/// - Customizable size
/// - Optional text display
/// - Gradient or solid color background
/// 
/// Unlike the StyleHubLogo, this is a more compact horizontal version
/// designed for navigation bars and headers.
class AppLogo extends StatelessWidget {
  /// Size of the logo square in logical pixels
  final double size;
  /// Whether to show the brand name text next to the logo
  final bool showText;
  /// Whether to use a gradient background or solid color
  final bool useGradient;

  /// Constructor with default values for easy customization
  const AppLogo({
    Key? key,
    this.size = 40, // Default to smaller size since used in app bars
    this.showText = true,
    this.useGradient = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Take only as much width as needed
      children: [
        // Logo icon container
        Container(
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
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          // Shopping bag icon
          child: Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: size * 0.6, // Icon sized proportionally to container
          ),
        ),
        // Optional brand name text
        if (showText) ...[
          SizedBox(width: size * 0.2), // Spacing between icon and text
          // Brand name text
          Text(
            'StyleHub',
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: size * 0.6, // Text sized proportionally to logo
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ],
    );
  }
}
