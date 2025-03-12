// Import required packages and libraries
import 'package:flutter/material.dart';

/// AppTheme Class
///
/// Defines the styling and theming for the entire e-commerce application.
/// Contains colors, typography, spacing, and component styles that are
/// consistently used throughout the app to maintain visual coherence.
class AppTheme {
  // Colors
  /// Primary brand color - main color used throughout the app
  static const Color primaryColor = Color(0xFF2962FF);
  /// Secondary darker blue color for emphasis and contrast
  static const Color secondaryColor = Color(0xFF0D47A1);
  /// Accent light blue for highlights and secondary elements
  static const Color accentColor = Color(0xFF82B1FF);
  /// Main text color for readable content
  static const Color textColor = Color(0xFF1F1F1F);
  /// Grey color for secondary text and disabled elements
  static const Color greyColor = Color(0xFF757575);
  /// Background color for screens and large surfaces
  static const Color backgroundColor = Color(0xFFF5F5F5);

  // Design Elements
  /// Standard border radius for UI elements (buttons, cards, etc.)
  static const double borderRadius = 12.0;
  /// Standard spacing between UI elements
  static const double spacing = 16.0;
  /// Standard padding inside UI elements (kept for backward compatibility)
  static const double padding = 16.0; // Kept for backward compatibility
  /// Standard elevation for cards and raised elements
  static const double cardElevation = 2.0;

  // Typography
  /// Large title style for screen headers and major sections
  static const TextStyle titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
    color: textColor,
    fontFamily: 'Poppins',
  );

  /// Medium title style for section headings and important content
  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: textColor,
    fontFamily: 'Poppins',
  );

  /// Small title style for card headings and interactive elements
  static const TextStyle titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: textColor,
    fontFamily: 'Poppins',
  );

  /// Large body text style for primary paragraph content
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: textColor,
    fontFamily: 'Poppins',
  );

  /// Medium body text style for general content and descriptions
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    color: textColor,
    fontFamily: 'Poppins',
  );

  /// Medium label style for tags, categories, and metadata
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: greyColor,
    fontFamily: 'Poppins',
  );

  /// Small label style for auxiliary information and small UI elements
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: greyColor,
    fontFamily: 'Poppins',
  );

  // Button Styles
  /// Standard elevated button style with primary color and proper spacing
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: EdgeInsets.symmetric(horizontal: spacing * 1.5, vertical: spacing),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    textStyle: bodyLarge.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
  );

  /// Standard text button style with primary color and proper spacing
  static final ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: primaryColor,
    padding: EdgeInsets.symmetric(horizontal: spacing, vertical: spacing / 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius / 2),
    ),
    textStyle: bodyMedium.copyWith(
      color: primaryColor,
      fontWeight: FontWeight.w600,
    ),
  );

  // Input Decoration
  /// Standard input field decoration with proper padding and borders
  static final InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: spacing, vertical: spacing),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: greyColor.withOpacity(0.2)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: greyColor.withOpacity(0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: primaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: Colors.red),
    ),
  );

  // Card Decoration
  /// Standard box decoration for cards with subtle shadow
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );

  // Card Theme
  /// Standard card theme with appropriate elevation and shape
  static final CardTheme cardTheme = CardTheme(
    elevation: cardElevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    clipBehavior: Clip.antiAlias,
    margin: EdgeInsets.zero,
  );

  // Chip Theme
  /// Standard chip theme for tags and filters
  static final ChipThemeData chipTheme = ChipThemeData(
    backgroundColor: backgroundColor,
    selectedColor: primaryColor.withOpacity(0.1),
    padding: EdgeInsets.symmetric(horizontal: spacing * 0.75, vertical: spacing / 2),
    labelStyle: labelMedium.copyWith(color: textColor),
    secondaryLabelStyle: labelMedium.copyWith(color: primaryColor),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius / 2),
    ),
  );

  // Theme Data
  /// Light theme configuration for the entire application
  /// 
  /// Sets up the color scheme, typography, component styling, and other theme
  /// properties to create a consistent visual language throughout the app.
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
      background: backgroundColor,
      error: Colors.red,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: textColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: titleMedium,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle),
    cardTheme: cardTheme,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: spacing, vertical: spacing),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: greyColor.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: greyColor.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: Colors.red),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: greyColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    chipTheme: chipTheme,
  );

  static var outlinedButtonStyle;
}
