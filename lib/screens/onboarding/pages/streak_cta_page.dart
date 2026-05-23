import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import 'onboarding_shared.dart';

class StreakCtaPage extends StatelessWidget {
  final String name;
  final VoidCallback onNext;

  const StreakCtaPage({super.key, required this.name, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 48, 28, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Heading ────────────────────────────────────────────────────
              Text(
                name.isNotEmpty ? '$name,' : '',
                style: GoogleFonts.nunito(
                  color: AppColors.primaryMid,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 100.ms),

              const SizedBox(height: 4),

              Text(
                AppStrings.onboardingStreakHeading,
                style: GoogleFonts.lora(
                  color: AppColors.text,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms)
                  .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 200.ms),

              const Spacer(flex: 2),

              // ── Streak badge ───────────────────────────────────────────────
              _StreakBadge()
                  .animate()
                  .scale(
                    begin: const Offset(0.7, 0.7),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                    delay: 400.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 400.ms, delay: 400.ms),

              const SizedBox(height: 28),

              Text(
                AppStrings.onboardingStreakSub,
                style: GoogleFonts.nunito(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 700.ms),

              const Spacer(flex: 3),

              // ── CTA ────────────────────────────────────────────────────────
              OnboardingContinueButton(
                enabled: true,
                onTap: onNext,
                label: AppStrings.onboardingStreakCta,
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 900.ms)
                  .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 900.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 36),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 36,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(
                begin: 1.0,
                end: 1.08,
                duration: 900.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(height: 16),
          Text(
            AppStrings.onboardingStreakDay(1),
            style: GoogleFonts.nunito(
              color: AppColors.text,
              fontSize: 36,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            AppStrings.settingsStreakTitle,
            style: GoogleFonts.nunito(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
