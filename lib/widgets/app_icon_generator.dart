import 'package:flutter/material.dart';
import '../config/theme.dart';

class AppIconGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1024,
      height: 1024,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2962FF), // Primary Blue
            Color(0xFF0D47A1), // Secondary Dark Blue
          ],
          stops: [0.0, 0.8],
        ),
        borderRadius: BorderRadius.circular(240),
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
          // Background pattern
          Transform.rotate(
            angle: -0.2,
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white.withOpacity(0.15),
              size: 800,
            ),
          ),
          // Main icon
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
          // Accent circle
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
