import '../data/content.dart';
import '../models/prayer_model.dart';
import '../models/verse_model.dart';

class MoodFilterService {
  MoodFilterService._();

  static List<VerseModel> getVerses(String? mood) {
    if (mood == null) return ContentData.verses;
    return ContentData.verses
        .where((v) => v.moods.contains(mood))
        .toList();
  }

  static List<PrayerModel> getPrayers(String? mood) {
    if (mood == null) return ContentData.prayers;
    return ContentData.prayers
        .where((p) => p.moods.contains(mood))
        .toList();
  }

  // Deterministic — same verse for the whole day, cycles through all verses
  static VerseModel getDailyVerse() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    final verses = ContentData.verses;
    return verses[dayOfYear % verses.length];
  }

  // Picks a verse from the filtered set; stays stable within the same day
  static VerseModel getVerseForMood(String mood) {
    final matches = getVerses(mood);
    if (matches.isEmpty) return getDailyVerse();
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    return matches[dayOfYear % matches.length];
  }
}
