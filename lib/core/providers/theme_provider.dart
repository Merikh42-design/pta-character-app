import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<ThemeData>((ref) {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5E8C7), // Parchment
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF5D4037), // Dark brown
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: Color(0xFFE8D5B7),
      labelStyle: TextStyle(color: Colors.black87),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF5D4037),
      primary: const Color(0xFF5D4037),
      secondary: const Color(0xFF42b278), // Body Green
    ),
  );
});