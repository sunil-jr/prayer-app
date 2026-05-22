import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';
import '../models/answered_prayer.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Generic ────────────────────────────────────────────────────────────────

  static String? getString(String key) => _prefs.getString(key);
  static Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  static bool? getBool(String key) => _prefs.getBool(key);
  static Future<bool> setBool(String key, bool value) =>
      _prefs.setBool(key, value);

  static int? getInt(String key) => _prefs.getInt(key);
  static Future<bool> setInt(String key, int value) =>
      _prefs.setInt(key, value);

  static List<String>? getStringList(String key) =>
      _prefs.getStringList(key);
  static Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  static Future<bool> remove(String key) => _prefs.remove(key);

  // ── Journal entries ────────────────────────────────────────────────────────

  static Future<List<JournalEntry>> getEntries() async {
    final raw = _prefs.getStringList(StorageKeys.journalEntries) ?? [];
    return raw.map((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return JournalEntry.fromJson(map);
    }).toList();
  }

  static Future<void> saveEntry(JournalEntry entry) async {
    final entries = await getEntries();
    entries.add(entry);
    await _persistEntries(entries);
  }

  static Future<void> updateEntry(JournalEntry entry) async {
    final entries = await getEntries();
    final i = entries.indexWhere((e) => e.id == entry.id);
    if (i != -1) entries[i] = entry;
    await _persistEntries(entries);
  }

  static Future<void> deleteEntry(String id) async {
    final entries = await getEntries();
    entries.removeWhere((e) => e.id == id);
    await _persistEntries(entries);
  }

  static Future<void> _persistEntries(List<JournalEntry> entries) async {
    final raw = entries.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(StorageKeys.journalEntries, raw);
  }

  // ── Answered prayers ───────────────────────────────────────────────────────

  static Future<List<AnsweredPrayer>> getAnsweredPrayers() async {
    final raw = _prefs.getStringList(StorageKeys.answeredPrayers) ?? [];
    return raw.map((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return AnsweredPrayer.fromJson(map);
    }).toList();
  }

  static Future<void> saveAnsweredPrayer(AnsweredPrayer prayer) async {
    final list = await getAnsweredPrayers();
    list.add(prayer);
    await _persistAnsweredPrayers(list);
  }

  static Future<void> updateAnsweredPrayer(AnsweredPrayer prayer) async {
    final list = await getAnsweredPrayers();
    final i = list.indexWhere((p) => p.id == prayer.id);
    if (i != -1) list[i] = prayer;
    await _persistAnsweredPrayers(list);
  }

  static Future<void> deleteAnsweredPrayer(String id) async {
    final list = await getAnsweredPrayers();
    list.removeWhere((p) => p.id == id);
    await _persistAnsweredPrayers(list);
  }

  static Future<void> _persistAnsweredPrayers(
      List<AnsweredPrayer> list) async {
    final raw = list.map((p) => jsonEncode(p.toJson())).toList();
    await _prefs.setStringList(StorageKeys.answeredPrayers, raw);
  }

  // ── Streak ─────────────────────────────────────────────────────────────────

  static Future<int> checkAndUpdateStreak() async {
    final today = _dateKey(DateTime.now());
    final lastDate = _prefs.getString(StorageKeys.streakLastDate);
    int streak = _prefs.getInt(StorageKeys.streakCount) ?? 0;

    if (lastDate == null) {
      streak = 1;
    } else if (lastDate == today) {
      return streak;
    } else {
      final yesterday =
          _dateKey(DateTime.now().subtract(const Duration(days: 1)));
      streak = (lastDate == yesterday) ? streak + 1 : 1;
    }

    await _prefs.setString(StorageKeys.streakLastDate, today);
    await _prefs.setInt(StorageKeys.streakCount, streak);
    return streak;
  }

  // ── Breathe sessions ───────────────────────────────────────────────────────

  static int getBreatheSessions() =>
      _prefs.getInt(StorageKeys.breatheSessions) ?? 0;

  static Future<void> incrementBreatheSessions() async {
    final current = getBreatheSessions();
    await _prefs.setInt(StorageKeys.breatheSessions, current + 1);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';
}

class StorageKeys {
  StorageKeys._();

  static const String journalEntries = 'journal_entries';
  static const String answeredPrayers = 'answered_prayers';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String reminderHour = 'reminder_hour';
  static const String reminderMinute = 'reminder_minute';
  static const String lastVerseIndex = 'last_verse_index';
  static const String lastVerseDate = 'last_verse_date';
  static const String streakCount = 'streak_count';
  static const String streakLastDate = 'streak_last_date';
  static const String breatheSessions = 'breathe_sessions';

  // ── Onboarding ─────────────────────────────────────────────────────────────
  static const String onboardingCompleted = 'onboarding_completed';
  static const String onboardingName = 'onboarding_name';
  static const String onboardingMood = 'onboarding_mood';
  static const String onboardingPrayFrequency = 'onboarding_pray_frequency';
  static const String onboardingFaithState = 'onboarding_faith_state';
  static const String onboardingBarriers = 'onboarding_barriers';
  static const String onboardingGoals = 'onboarding_goals';
}
