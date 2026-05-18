import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.primaryMid,
        onSecondary: AppColors.textOnPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.text,
      ),
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.lora(
          color: AppColors.text,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.3,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textPurple,
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.surface
                : const Color(0xFFDDDDDD)),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.primary
                : const Color(0xFFCCCCCC)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.navActive,
        unselectedItemColor: AppColors.navInactive,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        filled: true,
        fillColor: AppColors.surface,
        labelStyle: GoogleFonts.nunito(color: AppColors.textSecondary),
        hintStyle: GoogleFonts.nunito(
          color: AppColors.textSecondary,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  static TextTheme get _textTheme => TextTheme(
        displayLarge: GoogleFonts.lora(
          color: AppColors.text,
          fontSize: 34,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: GoogleFonts.lora(
          color: AppColors.text,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
        displaySmall: GoogleFonts.lora(
          color: AppColors.text,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: GoogleFonts.lora(
          color: AppColors.text,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.lora(
          color: AppColors.text,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.lora(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.nunito(
          color: AppColors.text,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: GoogleFonts.nunito(
          color: AppColors.text,
          fontSize: 15,
          fontWeight: FontWeight.w700,
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
          color: AppColors.textSecondary,
          fontSize: 12,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.nunito(
          color: AppColors.text,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: GoogleFonts.nunito(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.nunito(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      );
}
