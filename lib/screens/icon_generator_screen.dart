// Import required packages and libraries
import 'package:flutter/material.dart';
import '../widgets/app_icon_generator.dart';

/// IconGeneratorScreen Widget
///
/// A screen that displays the AppIconGenerator widget centered on the screen.
/// This provides a dedicated space for app icon generation functionality.
class IconGeneratorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AppIconGenerator(),
      ),
    );
  }
}
