import 'package:flutter/material.dart';
import '../../app.dart';
import '../../constants/app_strings.dart';
import '../../services/storage_service.dart';
import 'pages/breathe_countdown_page.dart';
import 'pages/hook_page.dart';
import 'pages/loading_page.dart';
import 'pages/paywall_page.dart';
import 'pages/prayer_reveal_page.dart';
import 'pages/q_multi_page.dart';
import 'pages/q_name_page.dart';
import 'pages/q_single_page.dart';
import 'pages/q_slider_page.dart';
import 'pages/streak_cta_page.dart';
import 'pages/verse_reveal_page.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final _pageController = PageController();

  // ── Collected answers ──────────────────────────────────────────────────────
  String _name = '';
  String _mood = 'peace';
  int _prayFrequency = 2;
  String _faithState = '';
  List<String> _barriers = [];
  List<String> _goals = [];

  void _next() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    await StorageService.setString(StorageKeys.onboardingName, _name);
    await StorageService.setString(StorageKeys.onboardingMood, _mood);
    await StorageService.setInt(StorageKeys.onboardingPrayFrequency, _prayFrequency);
    await StorageService.setString(StorageKeys.onboardingFaithState, _faithState);
    await StorageService.setStringList(StorageKeys.onboardingBarriers, _barriers);
    await StorageService.setStringList(StorageKeys.onboardingGoals, _goals);
    await StorageService.setBool(StorageKeys.onboardingCompleted, true);
    await StorageService.markDailyCheckInDone();
    if (mounted) {
      Navigator.of(context).pushReplacement(fadeRoute(const EntitlementGate()));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // 0 — Hook
        HookPage(onNext: _next),

        // 1 — Q1: Name
        QNamePage(
          onNext: (name) {
            setState(() => _name = name);
            _next();
          },
        ),

        // 2 — Q2: Mood
        QSinglePage(
          progress: 2 / 6,
          question: AppStrings.onboardingQ2Question,
          options: const [
            QOption(emoji: '😰', label: 'Anxiety — feeling overwhelmed', value: 'anxiety'),
            QOption(emoji: '🕊️', label: 'Peace — seeking stillness', value: 'peace'),
            QOption(emoji: '🙏', label: 'Gratitude — thankful heart', value: 'gratitude'),
            QOption(emoji: '💚', label: 'Hope — believing for more', value: 'hope'),
            QOption(emoji: '💔', label: 'Grief — carrying loss', value: 'grief'),
          ],
          onNext: (mood) {
            setState(() => _mood = mood);
            _next();
          },
        ),

        // 3 — Q3: Prayer frequency
        QSliderPage(
          progress: 3 / 6,
          onNext: (freq) {
            setState(() => _prayFrequency = freq);
            _next();
          },
        ),

        // 4 — Q4: Faith state
        QSinglePage(
          progress: 4 / 6,
          question: AppStrings.onboardingQ4Question,
          options: const [
            QOption(emoji: '🌱', label: 'Just starting out', value: 'starting'),
            QOption(emoji: '📈', label: 'Growing steadily', value: 'growing'),
            QOption(emoji: '🌊', label: 'Steady and rooted', value: 'steady'),
            QOption(emoji: '🌫️', label: 'Feeling distant', value: 'distant'),
          ],
          onNext: (faith) {
            setState(() => _faithState = faith);
            _next();
          },
        ),

        // 5 — Q5: Barriers (multi)
        QMultiPage(
          progress: 5 / 6,
          question: AppStrings.onboardingQ5Question,
          subtext: AppStrings.onboardingQ5Sub,
          options: const [
            QOption(emoji: '⏰', label: "I'm too busy", value: 'busy'),
            QOption(emoji: '🧠', label: 'I lose focus easily', value: 'focus'),
            QOption(emoji: '❓', label: "I don't know what to say", value: 'words'),
            QOption(emoji: '😔', label: 'I struggle with doubt', value: 'doubt'),
            QOption(emoji: '😶', label: 'I feel alone in it', value: 'alone'),
          ],
          onNext: (barriers) {
            setState(() => _barriers = barriers);
            _next();
          },
        ),

        // 6 — Q6: Goals (multi)
        QMultiPage(
          progress: 6 / 6,
          question: AppStrings.onboardingQ6Question,
          subtext: AppStrings.onboardingQ6Sub,
          options: const [
            QOption(emoji: '🙏', label: 'Track my prayers', value: 'track'),
            QOption(emoji: '🌬️', label: 'Calm my anxiety', value: 'calm'),
            QOption(emoji: '📖', label: 'Read scripture daily', value: 'scripture'),
            QOption(emoji: '✍️', label: 'Journal my thoughts', value: 'journal'),
          ],
          onNext: (goals) {
            setState(() => _goals = goals);
            _next();
          },
        ),

        // 7 — Loading
        LoadingPage(onComplete: _next),

        // 8 — Breathe countdown
        BreatheCountdownPage(onComplete: _next),

        // 9 — Prayer reveal
        PrayerRevealPage(mood: _mood, onNext: _next),

        // 10 — Verse reveal
        VerseRevealPage(mood: _mood, onNext: _next),

        // 11 — Streak + CTA
        StreakCtaPage(name: _name, onNext: _next),

        // 12 — Paywall
        PaywallPage(onPurchased: _finish, onSkip: _finish),
      ],
    );
  }
}
