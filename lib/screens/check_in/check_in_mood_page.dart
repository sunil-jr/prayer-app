import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../services/storage_service.dart';

class CheckInMoodPage extends StatelessWidget {
  final String question;
  final void Function(String mood) onMoodSelected;

  const CheckInMoodPage({
    super.key,
    required this.question,
    required this.onMoodSelected,
  });

  static const _moods = [
    _MoodOpt('😰', 'Anxious', 'anxiety'),
    _MoodOpt('🕊️', 'Peaceful', 'peace'),
    _MoodOpt('🙏', 'Grateful', 'gratitude'),
    _MoodOpt('🌱', 'Hopeful', 'hope'),
    _MoodOpt('💔', 'Grieving', 'grief'),
  ];

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.homeGreetingMorning;
    if (hour < 17) return AppStrings.homeGreetingAfternoon;
    return AppStrings.homeGreetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final name = StorageService.getString(StorageKeys.onboardingName) ?? '';
    final greeting =
        name.isNotEmpty ? '${_greeting()}, $name.' : '${_greeting()}.';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 48, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: GoogleFonts.nunito(
                  color: AppColors.primaryMid,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 10),

              Text(
                question,
                style: GoogleFonts.nunito(
                  color: AppColors.text,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              )
                  .animate()
                  .fadeIn(delay: 150.ms, duration: 400.ms)
                  .slideY(begin: 0.08, end: 0, delay: 150.ms, duration: 400.ms),

              const SizedBox(height: 32),

              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _moods.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final m = _moods[i];
                    return _MoodCard(
                      emoji: m.emoji,
                      label: m.label,
                      onTap: () => onMoodSelected(m.value),
                    )
                        .animate()
                        .fadeIn(
                          duration: 300.ms,
                          delay: Duration(milliseconds: 120 + 60 * i),
                        )
                        .slideY(
                          begin: 0.1,
                          end: 0,
                          duration: 300.ms,
                          delay: Duration(milliseconds: 120 + 60 * i),
                        );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Internal data class ────────────────────────────────────────────────────────

class _MoodOpt {
  final String emoji;
  final String label;
  final String value;
  const _MoodOpt(this.emoji, this.label, this.value);
}

// ── Mood card ──────────────────────────────────────────────────────────────────

class _MoodCard extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _MoodCard({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider, width: 1.5),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.nunito(
                  color: AppColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.navInactive, size: 20),
          ],
        ),
      ),
    );
  }
}