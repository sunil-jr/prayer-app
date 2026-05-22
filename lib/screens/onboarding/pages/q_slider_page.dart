import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import 'onboarding_shared.dart';

class QSliderPage extends StatefulWidget {
  final double progress;
  final void Function(int value) onNext;

  const QSliderPage({super.key, required this.progress, required this.onNext});

  @override
  State<QSliderPage> createState() => _QSliderPageState();
}

class _QSliderPageState extends State<QSliderPage> {
  int _value = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          OnboardingProgressBar(progress: widget.progress),
          Expanded(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 48, 28, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.onboardingQ3Question,
                      style: GoogleFonts.nunito(
                        color: AppColors.text,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.35,
                      ),
                    ),
                    const Spacer(),

                    // ── Big number display ─────────────────────────────────
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '$_value',
                            style: GoogleFonts.nunito(
                              color: AppColors.primary,
                              fontSize: 88,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _value == 0
                                ? AppStrings.onboardingQ3Never
                                : _value == 7
                                    ? AppStrings.onboardingQ3Daily
                                    : AppStrings.onboardingQ3Unit,
                            style: GoogleFonts.nunito(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Slider ─────────────────────────────────────────────
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: AppColors.divider,
                        thumbColor: AppColors.primary,
                        overlayColor: AppColors.primary.withValues(alpha: 0.12),
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                      ),
                      child: Slider(
                        value: _value.toDouble(),
                        min: 0,
                        max: 7,
                        divisions: 7,
                        onChanged: (v) => setState(() => _value = v.round()),
                      ),
                    ),

                    // ── End labels ─────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '0',
                            style: GoogleFonts.nunito(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '7',
                            style: GoogleFonts.nunito(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),
                    OnboardingContinueButton(
                      enabled: true,
                      onTap: () => widget.onNext(_value),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
