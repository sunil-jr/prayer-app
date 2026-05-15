import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        onPrimary: AppColors.text,
        surface: AppColors.surface,
        onSurface: AppColors.text,
      ),
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.lora(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        color: Colors.white.withValues(alpha: 0.65),
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.text,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.3,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 0.5,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: Color(0xFFB0A8A8),
        elevation: 1,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static TextTheme get _textTheme => TextTheme(
        headlineLarge: GoogleFonts.lora(
          color: AppColors.text,
          fontSize: 30,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.3,
        ),
        headlineMedium: GoogleFonts.lora(
          color: AppColors.text,
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: GoogleFonts.lora(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: GoogleFonts.lora(
          color: AppColors.text,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: GoogleFonts.nunito(
          color: AppColors.text,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.nunito(
          color: AppColors.text,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.nunito(
          color: AppColors.text,
          fontSize: 16,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.nunito(
          color: AppColors.text,
          fontSize: 14,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.nunito(
          color: AppColors.textLight,
          fontSize: 12,
        ),
        labelLarge: GoogleFonts.nunito(
          color: AppColors.text,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      );
}
