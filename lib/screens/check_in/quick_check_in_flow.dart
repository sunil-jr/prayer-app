import 'package:flutter/material.dart';
import '../../app.dart';
import '../../constants/app_strings.dart';
import 'check_in_mood_page.dart';
import 'quick_prayer_page.dart';

class QuickCheckInFlow extends StatefulWidget {
  const QuickCheckInFlow({super.key});

  @override
  State<QuickCheckInFlow> createState() => _QuickCheckInFlowState();
}

class _QuickCheckInFlowState extends State<QuickCheckInFlow> {
  final _controller = PageController();
  String _mood = 'peace';

  void _advance() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _finish() {
    Navigator.of(context).pushReplacement(fadeRoute(const MainShell()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // 0 — Mood selection
        CheckInMoodPage(
          question: AppStrings.checkInQuickQuestion,
          onMoodSelected: (mood) {
            setState(() => _mood = mood);
            _advance();
          },
        ),

        // 1 — Quick prayer (fade-in)
        QuickPrayerPage(key: ValueKey(_mood), mood: _mood, onNext: _finish),
      ],
    );
  }
}