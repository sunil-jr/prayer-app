import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

class StreakBadge extends StatelessWidget {
  final int streakCount;

  const StreakBadge({super.key, required this.streakCount});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppStrings.semanticStreakBadge(streakCount),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CD),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Color(0xFF856404),
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              AppStrings.homeStreakBadge(streakCount),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF856404),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
