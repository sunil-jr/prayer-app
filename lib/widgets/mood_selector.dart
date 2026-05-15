import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class MoodSelector extends StatelessWidget {
  final String? selectedMood;
  final void Function(String? mood) onMoodChanged;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodChanged,
  });

  // (moodId, displayLabel) — IDs match the mood strings in ContentData
  static const _options = [
    ('anxiety', AppStrings.moodAnxiety),
    ('gratitude', AppStrings.moodGratitude),
    ('peace', AppStrings.moodPeace),
    ('grief', AppStrings.moodGrief),
    ('hope', AppStrings.moodHope),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: _options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (id, label) = _options[i];
          final isSelected = selectedMood == id;
          return _MoodPill(
            label: label,
            isSelected: isSelected,
            onTap: () => onMoodChanged(isSelected ? null : id),
          );
        },
      ),
    );
  }
}

class _MoodPill extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_MoodPill> createState() => _MoodPillState();
}

class _MoodPillState extends State<_MoodPill> {
  int _tapCount = 0;

  void _handleTap() {
    if (!MediaQuery.of(context).disableAnimations) {
      setState(() => _tapCount++);
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final semanticLabel =
        '${AppStrings.semanticMoodFilterPrefix} ${widget.label}, '
        '${widget.isSelected ? AppStrings.semanticMoodSelected : AppStrings.semanticMoodNotSelected}';

    Widget pill = Semantics(
      label: semanticLabel,
      button: true,
      selected: widget.isSelected,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.isSelected ? AppColors.accent : AppColors.surface,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color:
                  widget.isSelected ? AppColors.accent : AppColors.divider,
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 13,
                  color:
                      widget.isSelected ? AppColors.text : AppColors.textLight,
                  fontWeight:
                      widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
            child: Text(widget.label),
          ),
        ),
      ),
    );

    if (_tapCount == 0) return pill;

    return pill
        .animate(key: ValueKey(_tapCount))
        .scaleXY(begin: 1.0, end: 0.93, duration: 80.ms, curve: Curves.easeIn)
        .then()
        .scaleXY(
            begin: 0.93, end: 1.0, duration: 80.ms, curve: Curves.easeOut);
  }
}
