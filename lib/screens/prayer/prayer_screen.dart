import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../services/mood_filter_service.dart';
import '../../widgets/prayer_card.dart';

class PrayerScreen extends StatefulWidget {
  final String? initialMood;

  const PrayerScreen({super.key, this.initialMood});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  late String? _activeMood;

  @override
  void initState() {
    super.initState();
    _activeMood = widget.initialMood;
  }

  @override
  Widget build(BuildContext context) {
    final prayers = MoodFilterService.getPrayers(_activeMood);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.prayerTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_activeMood != null)
            _MoodChip(
              mood: _activeMood!,
              onDismiss: () => setState(() => _activeMood = null),
            ),
          Expanded(
            child: prayers.isEmpty
                ? _EmptyState(mood: _activeMood)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    itemCount: prayers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => PrayerCard(prayer: prayers[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Mood chip ─────────────────────────────────────────────────────────────────

class _MoodChip extends StatelessWidget {
  final String mood;
  final VoidCallback onDismiss;

  const _MoodChip({required this.mood, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final label =
        '${AppStrings.prayerMoodChipPrefix}: ${AppStrings.moodLabel(mood)}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Semantics(
        label: '$label. ${AppStrings.prayerMoodChipDismissLabel}',
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                ),
              ),
              Semantics(
                label: AppStrings.prayerMoodChipDismissLabel,
                button: true,
                excludeSemantics: true,
                child: IconButton(
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close_rounded, size: 16),
                  color: AppColors.textLight,
                  tooltip: AppStrings.prayerMoodChipDismissLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String? mood;

  const _EmptyState({this.mood});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          AppStrings.prayerEmptyForMood,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
