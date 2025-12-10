import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,

    // Main color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.orange,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: const Color(0xFF5069AA),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: const Color(0xFF5069AA),
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(
        fontFamily: 'Vertica',
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),

    // Cards
    // cardTheme: CardTheme(
    //   elevation: 2,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //   color: Colors.white,
    // ),

    // Text Styles
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 18),
      bodyMedium: TextStyle(fontSize: 16),
    ),

    // Navigation bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF233C4B),
      selectedItemColor: Color(0xFF91E6F5),
      unselectedItemColor: Colors.white,
      showUnselectedLabels: true,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
