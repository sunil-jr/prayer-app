import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../data/content.dart';
import '../../../models/prayer_model.dart';
import 'onboarding_shared.dart';

class PrayerRevealPage extends StatelessWidget {
  final String mood;
  final VoidCallback onNext;

  const PrayerRevealPage({super.key, required this.mood, required this.onNext});

  PrayerModel _pick() {
    final matched = ContentData.prayers
        .where((p) => p.moods.contains(mood))
        .toList();
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
                    AppStrings.onboardingPrayerTitle.toUpperCase(),
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
              ),

              const SizedBox(height: 24),

              // ── Prayer body ────────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    prayer.body,
                    style: GoogleFonts.lora(
                      color: AppColors.text,
                      fontSize: 17,
                      height: 1.85,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Amen + Continue ────────────────────────────────────────────
              Center(
                child: Text(
                  AppStrings.onboardingPrayerAmen,
                  style: GoogleFonts.lora(
                    color: AppColors.primaryMid,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OnboardingContinueButton(
                enabled: true,
                onTap: onNext,
                label: AppStrings.onboardingPrayerNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
