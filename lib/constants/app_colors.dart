import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand purple ───────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF3D3580);
  static const Color primaryDeep = Color(0xFF2E2B6B);
  static const Color primaryMid = Color(0xFF6B5EBD);
  static const Color primaryLight = Color(0xFF8B7ED4);

  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFFAF8F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF0EDE8);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color text = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF888888);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textPurple = Color(0xFF6B5EBD);

  // ── Semantic accents ───────────────────────────────────────────────────────
  static const Color accentGreen = Color(0xFF7BAE7F);
  static const Color accentGreenBg = Color(0xFFD4EBD0);
  static const Color accentOrange = Color(0xFFE8965A);
  static const Color accentOrangeBg = Color(0xFFFAE4D4);

  // ── Mood tag backgrounds ───────────────────────────────────────────────────
  static const Color tagAnxiety = Color(0xFFD4E8F8);
  static const Color tagHope = Color(0xFFD4EBD0);
  static const Color tagGratitude = Color(0xFFF0E8C8);
  static const Color tagPeace = Color(0xFFE0D8F8);
  static const Color tagGrief = Color(0xFFEED8EE);
  static const Color tagUncertain = Color(0xFFE8E8E8);

  // ── UI chrome ──────────────────────────────────────────────────────────────
  static const Color divider = Color(0xFFEEEAE4);
  static const Color navActive = Color(0xFF3D3580);
  static const Color navInactive = Color(0xFFAAAAAA);

  // ── Legacy aliases ────────────────────────────────────────────────────────
  static const Color accent = primaryMid;
  static const Color textLight = textSecondary;
}
