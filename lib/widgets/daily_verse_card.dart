import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/verse_model.dart';

class DailyVerseCard extends StatelessWidget {
  final VerseModel verse;

  const DailyVerseCard({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final card = Semantics(
      label: AppStrings.semanticDailyVerseCard,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 8, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        AppStrings.homeDailyVerse,
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.textLight,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  Semantics(
                    label: AppStrings.semanticBookmarkVerse,
                    button: true,
                    excludeSemantics: true,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: IconButton(
                        onPressed: () {},
                        tooltip: AppStrings.semanticBookmarkVerse,
                        icon: const Icon(Icons.bookmark_outline, size: 20),
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                verse.text,
                style: GoogleFonts.lora(
                  fontSize: 18,
                  color: AppColors.text,
                  height: 1.65,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                verse.reference,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  color: AppColors.textLight,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (MediaQuery.of(context).disableAnimations) return card;
    return card.animate().fadeIn(duration: 700.ms, curve: Curves.easeOut);
  }
}
