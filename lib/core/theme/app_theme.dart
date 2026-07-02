import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Color Tokens
  static const Color primaryTeal = Color(0xFF0F766E);
  static const Color secondaryAmber = Color(0xFFF59E0B);
  static const Color alertRed = Color(0xFFDC2626);
  static const Color backgroundWarm = Color(0xFFFFFBEB);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color cardBackground = Colors.white;

  // Senior Mode Theme (Large fonts, high contrast)
  static ThemeData get seniorTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTeal,
        primary: primaryTeal,
        secondary: secondaryAmber,
        error: alertRed,
        surface: cardBackground,
      ),
      scaffoldBackgroundColor: backgroundWarm,
      textTheme: TextTheme(
        // Large labels and display styles for low visual strain
        displayLarge: GoogleFonts.notoSans(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.notoSans(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.notoSans(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.notoSans(
          fontSize: 20, // Min 18sp per docs, using 20 for safety
          fontWeight: FontWeight.normal,
          color: textPrimary,
          height: 1.4,
        ),
        bodyMedium: GoogleFonts.notoSans(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: textSecondary,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.notoSans(
          fontSize: 22, // Primary actions
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        minWidth: 88,
        height: 56, // Min 56dp touch targets
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(88, 56), // Touch target height
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  // Family Mode Theme (Standard UI density)
  static ThemeData get familyTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTeal,
        primary: primaryTeal,
        secondary: secondaryAmber,
        error: alertRed,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF9FAFB), // Standard light gray
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(88, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
