import 'package:flutter/material.dart';

/// Centralized application theme.
/// Defines global colors, typography, and component styles.
class AppTheme {
  /// Primary brand color (used for buttons, focus states, etc.)
  static const Color primary = Color(0xFF2E7D32);

  /// Returns the base light theme for the app.
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primary,
      scaffoldBackgroundColor: const Color(0xFFF4FAF4),
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      // ------------------------------
      // AppBar
      // ------------------------------
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),

      // ------------------------------
      // Elevated Buttons
      // ------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),

      // ------------------------------
      // Input Fields
      // ------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.2),
        ),
        hintStyle: const TextStyle(color: Colors.grey),
      ),

      // ------------------------------
      // Card styling
      // ------------------------------
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ------------------------------
      // Text & color scheme (optional tuning)
      // ------------------------------
      textTheme: base.textTheme.apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
    );
  }
}
