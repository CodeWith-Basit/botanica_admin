import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// App theme configuration for Botanica Admin
class AppTheme {
  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: const Color(0xFF006E2F),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF006E2F),
        brightness: Brightness.light,
        primary: const Color(0xFF006E2F),
        secondary: const Color(0xFF53B175),
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF006E2F)),
        titleTextStyle: TextStyle(
          color: Color(0xFF006E2F),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardColor: Colors.white,
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    );
  }
}
