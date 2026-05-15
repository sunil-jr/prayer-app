import 'package:flutter/material.dart';
import '../app.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/prayer_model.dart';
import '../screens/prayer/prayer_detail_screen.dart';

class PrayerCard extends StatelessWidget {
  final PrayerModel prayer;

  const PrayerCard({super.key, required this.prayer});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final flatBody = prayer.body.replaceAll('\n', ' ');
    final preview =
        flatBody.length > 100 ? '${flatBody.substring(0, 100)}…' : flatBody;
    final moodLabels =
        prayer.moods.map(AppStrings.moodLabel).join(', ');

    return Semantics(
      label: '${prayer.title}. Moods: $moodLabels',
      button: true,
      excludeSemantics: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            fadeRoute(PrayerDetailScreen(prayer: prayer)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayer.title,
                  style: textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  preview,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: prayer.moods
                      .map((m) => _MoodTag(mood: m))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodTag extends StatelessWidget {
  final String mood;

  const _MoodTag({required this.mood});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        AppStrings.moodLabel(mood),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: AppColors.text,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
