import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app.dart';
import '../../constants/app_strings.dart';
import '../../models/verse_model.dart';
import '../../screens/prayer/prayer_screen.dart';
import '../../services/mood_filter_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/daily_verse_card.dart';
import '../../widgets/mood_selector.dart';
import '../../widgets/streak_badge.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int index) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedMood;
  late VerseModel _displayedVerse;
  int _streakCount = 1;

  @override
  void initState() {
    super.initState();
    _displayedVerse = MoodFilterService.getDailyVerse();
    _streakCount = StorageService.getInt(StorageKeys.streakCount) ?? 1;
  }

  void _onMoodChanged(String? mood) {
    setState(() {
      _selectedMood = mood;
      _displayedVerse = mood == null
          ? MoodFilterService.getDailyVerse()
          : MoodFilterService.getVerseForMood(mood);
    });
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.homeGreetingMorning;
    if (hour < 17) return AppStrings.homeGreetingAfternoon;
    return AppStrings.homeGreetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    Widget moodSelector = MoodSelector(
      selectedMood: _selectedMood,
      onMoodChanged: _onMoodChanged,
    );
    if (!reduceMotion) {
      moodSelector = moodSelector.animate().fadeIn(duration: 400.ms);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_greeting, style: textTheme.headlineMedium),
              const SizedBox(height: 20),
              moodSelector,
              const SizedBox(height: 24),
              DailyVerseCard(
                key: ValueKey(_displayedVerse.id),
                verse: _displayedVerse,
              ),
              const SizedBox(height: 20),
              StreakBadge(streakCount: _streakCount),
              const SizedBox(height: 32),
              Semantics(
                label: AppStrings.semanticTodaysPrayerButton,
                button: true,
                excludeSemantics: true,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      fadeRoute(PrayerScreen(initialMood: _selectedMood)),
                    ),
                    child: const Text(AppStrings.homeTodaysPrayer),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
