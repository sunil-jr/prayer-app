import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../data/content.dart';
import '../../models/prayer_model.dart';

class QuickPrayerPage extends StatelessWidget {
  final String mood;
  final VoidCallback onNext;

  const QuickPrayerPage({super.key, required this.mood, required this.onNext});

  PrayerModel _pick() {
    final matched =
        ContentData.prayers.where((p) => p.moods.contains(mood)).toList();
    if (matched.length > 1) return matched[1];
    if (matched.isNotEmpty) return matched.first;
    return ContentData.prayers.first;
  }

  @override
  Widget build(BuildContext context) {
    final prayer = _pick();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 40, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Label ──────────────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppStrings.checkInQuickPrayerTitle.toUpperCase(),
                    style: GoogleFonts.nunito(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Prayer title ───────────────────────────────────────────────
              Text(
                prayer.title,
                style: GoogleFonts.lora(
                  color: AppColors.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

              const SizedBox(height: 24),

              // ── Prayer body (fade-in) ──────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    prayer.body,
                    style: GoogleFonts.lora(
                      color: AppColors.text,
                      fontSize: 17,
                      height: 1.85,
                    ),
                  ).animate().fadeIn(duration: 700.ms, delay: 300.ms),
                ),
              ),

              const SizedBox(height: 24),

              // ── Amen + Continue ────────────────────────────────────────────
              Column(
                children: [
                  Center(
                    child: Text(
                      AppStrings.onboardingPrayerAmen,
                      style: GoogleFonts.lora(
                        color: AppColors.primaryMid,
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                    ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 0,
                      ),
                      child: Text(
                        AppStrings.onboardingContinue,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}