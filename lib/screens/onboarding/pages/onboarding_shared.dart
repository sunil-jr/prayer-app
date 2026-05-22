import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';

class OnboardingProgressBar extends StatelessWidget {
  final double progress;

  const OnboardingProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4,
      child: LinearProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        backgroundColor: AppColors.divider,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        minHeight: 4,
      ),
    );
  }
}

class OnboardingContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;
  final String? label;

  const OnboardingContinueButton({
    super.key,
    required this.enabled,
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primaryLight.withValues(alpha: 0.4),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 0,
        ),
        child: Text(
          label ?? AppStrings.onboardingContinue,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
