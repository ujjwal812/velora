import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0B0B0E);
  static const Color darkBackground = Color(0xFF08080A);
  static const Color surface = Color(0xFF16151B);
  static const Color cardBg = Color(0xFF1C1A22);

  static const Color gold = Color(0xFFD4AF37);
  static const Color lightGold = Color(0xFFF5D77A);
  static const Color darkGold = Color(0xFFA88219);
  static const Color goldGlow = Color(0xFF322814);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: gold,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: lightGold,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get lightTheme => darkTheme;
}
