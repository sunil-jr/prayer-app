import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../data/content.dart';
import '../../../models/verse_model.dart';
import 'onboarding_shared.dart';

class VerseRevealPage extends StatelessWidget {
  final String mood;
  final VoidCallback onNext;

  const VerseRevealPage({super.key, required this.mood, required this.onNext});

  VerseModel _pick() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    final matched = ContentData.verses
        .where((v) => v.moods.contains(mood))
        .toList();
    final pool = matched.isNotEmpty ? matched : ContentData.verses;
    return pool[dayOfYear % pool.length];
  }

  @override
  Widget build(BuildContext context) {
    final verse = _pick();

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
                      color: AppColors.primaryMid,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppStrings.onboardingVerseTitle.toUpperCase(),
                    style: GoogleFonts.nunito(
                      color: AppColors.primaryMid,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ── Verse card ─────────────────────────────────────────────────
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.tagPeace,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '“',
                          style: GoogleFonts.lora(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            fontSize: 64,
                            height: 0.7,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          verse.text,
                          style: GoogleFonts.lora(
                            color: AppColors.text,
                            fontSize: 18,
                            height: 1.8,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '— ${verse.reference}',
                          style: GoogleFonts.nunito(
                            color: AppColors.primaryMid,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              OnboardingContinueButton(
                enabled: true,
                onTap: onNext,
                label: AppStrings.onboardingVerseNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
