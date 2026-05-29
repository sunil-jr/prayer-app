import 'package:flutter/material.dart';
import '../../app.dart';
import '../../constants/app_strings.dart';
import '../../services/storage_service.dart';
import '../onboarding/pages/prayer_reveal_page.dart';
import '../onboarding/pages/streak_cta_page.dart';
import '../onboarding/pages/verse_reveal_page.dart';
import 'check_in_mood_page.dart';

class DailyCheckInFlow extends StatefulWidget {
  const DailyCheckInFlow({super.key});

  @override
  State<DailyCheckInFlow> createState() => _DailyCheckInFlowState();
}

class _DailyCheckInFlowState extends State<DailyCheckInFlow> {
  final _controller = PageController();
  String _mood = 'peace';
  int _streak = 1;

  @override
  void initState() {
    super.initState();
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    final streak = await StorageService.checkAndUpdateStreak();
    if (mounted) setState(() => _streak = streak);
  }

  void _advance() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    await StorageService.markDailyCheckInDone();
    if (mounted) {
      Navigator.of(context).pushReplacement(fadeRoute(const MainShell()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = StorageService.getString(StorageKeys.onboardingName) ?? '';

    return PageView(
      controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // 0 — Mood selection
        CheckInMoodPage(
          question: AppStrings.checkInDailyQuestion,
          onMoodSelected: (mood) {
            setState(() => _mood = mood);
            _advance();
          },
        ),

        // 1 — Prayer (typewriter)
        PrayerRevealPage(key: ValueKey(_mood), mood: _mood, onNext: _advance),

        // 2 — Verse (fade-in)
        VerseRevealPage(
          key: ValueKey('verse_$_mood'),
          mood: _mood,
          onNext: _advance,
        ),

        // 3 — Streak + CTA
        StreakCtaPage(name: name, streak: _streak, onNext: _finish),
      ],
    );
  }
}