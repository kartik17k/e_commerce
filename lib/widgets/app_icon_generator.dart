// Import required packages and libraries
import 'package:flutter/material.dart';
import '../config/theme.dart';

/// AppIconGenerator Widget
///
/// Creates a visually appealing app icon for the e-commerce application.
/// The icon features a gradient background, a shopping bag outline pattern,
/// a centered style icon, and an accent circle for visual interest.
/// This widget is designed for generating app icons across different platforms.
class AppIconGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Icon dimensions - standard size for app icon generation
      width: 1024,
      height: 1024,
      decoration: BoxDecoration(
        // Gradient background for modern look
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2962FF), // Primary Blue
            Color(0xFF0D47A1), // Secondary Dark Blue
          ],
          stops: [0.0, 0.8],
        ),
        // Rounded corners for the icon
        borderRadius: BorderRadius.circular(240),
        // Subtle shadow for depth
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2962FF).withOpacity(0.3),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pattern - subtle shopping bag outline
          Transform.rotate(
            angle: -0.2, // Slight rotation for visual interest
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white.withOpacity(0.15),
              size: 800,
            ),
          ),
          // Main icon - style element representing fashion and shopping
          Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(120),
            ),
            child: Icon(
              Icons.style_outlined,
              color: Colors.white,
              size: 300,
            ),
          ),
          // Accent circle - adds visual balance and a modern touch
          Positioned(
            top: 200,
            right: 200,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFF82B1FF), // Accent Light Blue
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
