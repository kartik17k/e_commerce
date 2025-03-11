import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF2962FF);
  static const Color secondaryColor = Color(0xFF0D47A1);
  static const Color accentColor = Color(0xFF82B1FF);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color greyColor = Color(0xFF757575);
  static const Color backgroundColor = Color(0xFFF5F5F5);

  // Design Elements
  static const double borderRadius = 12.0;
  static const double spacing = 16.0;
  static const double padding = 16.0; // Kept for backward compatibility
  static const double cardElevation = 2.0;

  // Typography
  static const TextStyle titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
    color: textColor,
    fontFamily: 'Poppins',
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: textColor,
    fontFamily: 'Poppins',
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: textColor,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: textColor,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    color: textColor,
    fontFamily: 'Poppins',
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: greyColor,
    fontFamily: 'Poppins',
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: greyColor,
    fontFamily: 'Poppins',
  );

  // Button Styles
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
  static final CardThemeData cardTheme = CardThemeData(
    elevation: cardElevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    clipBehavior: Clip.antiAlias,
    margin: EdgeInsets.zero,
  );

  // Chip Theme
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
}
