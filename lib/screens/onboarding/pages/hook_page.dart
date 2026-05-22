import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';

class HookPage extends StatelessWidget {
  final VoidCallback onNext;

  const HookPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDeep, AppColors.primary, AppColors.primaryMid],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 3),

                // ── Hook lines ───────────────────────────────────────────────
                Text(
                  AppStrings.onboardingHookLine1,
                  style: GoogleFonts.lora(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 100.ms)
                    .slideY(begin: 0.15, end: 0, duration: 600.ms, delay: 100.ms, curve: Curves.easeOut),

                const SizedBox(height: 4),

                Text(
                  AppStrings.onboardingHookLine2,
                  style: GoogleFonts.lora(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 350.ms)
                    .slideY(begin: 0.15, end: 0, duration: 600.ms, delay: 350.ms, curve: Curves.easeOut),

                const SizedBox(height: 4),

                Text(
                  AppStrings.onboardingHookLine3,
                  style: GoogleFonts.lora(
                    color: AppColors.primaryLight,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .slideY(begin: 0.15, end: 0, duration: 600.ms, delay: 600.ms, curve: Curves.easeOut),

                const SizedBox(height: 36),

                // ── Subtext ──────────────────────────────────────────────────
                Text(
                  AppStrings.onboardingHookSub,
                  style: GoogleFonts.nunito(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 900.ms),

                const Spacer(flex: 4),

                // ── CTA ──────────────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.onboardingBegin,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 1100.ms)
                    .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 1100.ms, curve: Curves.easeOut),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
