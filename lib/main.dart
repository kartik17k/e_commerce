// Import required packages and libraries
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/theme.dart';
import 'screens/splash_screen.dart';

/// Application Entry Point
///
/// Initializes the Flutter application, configures system UI appearance,
/// and launches the first screen of the StyleHub e-commerce app.

void main() {
  // Ensure Flutter is initialized before using platform channels
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure system UI appearance for a clean, immersive look
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.dark, // Dark status bar icons
    ),
  );
  
  // Launch the application
  runApp(MyApp());
}

/// Root Application Widget
///
/// Configures the overall application settings including theme,
/// appearance, and initial route (splash screen).
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StyleHub', // Application title shown in task switchers
      debugShowCheckedModeBanner: false, // Hide debug banner in UI
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3 design system
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2962FF), // Generate color scheme from primary blue
          primary: Color(0xFF2962FF), // Primary brand color
          secondary: Color(0xFF0D47A1), // Secondary darker blue
        ),
        scaffoldBackgroundColor: Color(0xFFF5F5F5), // Light grey background for screens
        fontFamily: 'Poppins', // Default font family for text
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // White app bar
          foregroundColor: Color(0xFF1F1F1F), // Dark text for contrast
          elevation: 0, // Flat design with no shadow
          systemOverlayStyle: SystemUiOverlayStyle.dark, // Dark status bar icons when in an app bar
        ),
      ),
      home: SplashScreen(), // Initial screen shown on app launch
    );
  }
}
