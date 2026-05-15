class AppStrings {
  AppStrings._();

  static const String appName = 'SoulGrace';

  // Navigation
  static const String navHome = 'Home';
  static const String navPrayer = 'Prayer';
  static const String navJournal = 'Journal';
  static const String navSettings = 'Settings';

  // Home
  static const String homeGreeting = 'Peace be with you';
  static const String homeDailyVerse = 'Daily Verse';
  static const String homeDailyPrayer = 'Daily Prayer';

  // Prayer
  static const String prayerTitle = 'Prayers';
  static const String prayerBegin = 'Begin Prayer';

  // Journal
  static const String journalTitle = 'Journal';
  static const String journalNewEntry = 'New Entry';
  static const String journalEmptyState = 'Your spiritual journey begins here.';
  static const String journalEntryHint = 'Write your thoughts and reflections…';

  // Settings
  static const String settingsTitle = 'Settings';
  static const String settingsNotifications = 'Daily Reminder';
  static const String settingsNotificationsSubtitle = 'Receive a daily prayer reminder';
  static const String settingsReminderTime = 'Reminder Time';
  static const String settingsStreakTitle = 'Current Streak';
  static const String settingsAbout = 'About';
  static const String settingsVersion = 'Version 1.0.0';

  // Greetings (time-aware)
  static const String homeGreetingMorning = 'Good morning, friend';
  static const String homeGreetingAfternoon = 'Good afternoon, friend';
  static const String homeGreetingEvening = 'Good evening, friend';

  // Home extras
  static const String homeTodaysPrayer = "Today's Prayer";
  static String homeStreakBadge(int count) =>
      '$count ${count == 1 ? 'day' : 'days'} streak';

  // Semantic labels
  static const String semanticBookmarkVerse = 'Bookmark this verse';
  static const String semanticDailyVerseCard = 'Daily scripture verse';
  static const String semanticTodaysPrayerButton = "Open today's prayer";
  static String semanticStreakBadge(int count) =>
      'Current streak: $count ${count == 1 ? 'day' : 'days'}';

  // Mood labels (displayed in pill buttons)
  static const String moodAnxiety = 'Anxiety';
  static const String moodGratitude = 'Gratitude';
  static const String moodPeace = 'Peace';
  static const String moodGrief = 'Grief';
  static const String moodHope = 'Hope';

  // Mood selector semantics
  static const String semanticMoodFilterPrefix = 'Filter prayers by';
  static const String semanticMoodSelected = 'selected';
  static const String semanticMoodNotSelected = 'not selected';

  // Journal screen
  static const String journalSeedEmptyState =
      'Your prayers are seeds.\nWrite your first one.';
  static const String journalDeleteTitle = 'Delete entry?';
  static const String journalDeleteBody = 'This action cannot be undone.';
  static const String journalDeleteCancel = 'Cancel';
  static const String journalDeleteConfirm = 'Delete';

  // Entry screen
  static const String entryScreenNewTitle = 'New Entry';
  static const String entryScreenEditTitle = 'Edit Entry';
  static const String entryScreenSave = 'Save';
  static const String entryDefaultTitle = 'Untitled';
  static const String entryTitleLabel = 'Title';
  static const String entryTitleHint = 'Give your entry a title…';
  static const String entryBodyLabel = 'Prayer or reflection';
  static const String entryBodyHint = 'Write freely. This is your space.';
  static const String entryMoodLabel = 'How are you feeling?';

  // Journal semantic labels
  static const String semanticNewEntryFab = 'Write a new journal entry';
  static const String semanticJournalTile = 'Journal entry';
  static const String semanticJournalTileDeleteHint = 'Long press to delete';

  // Prayer screen
  static const String prayerMoodChipPrefix = 'Showing prayers for';
  static const String prayerMoodChipDismissLabel = 'Dismiss mood filter';
  static const String prayerEmptyForMood = 'No prayers for this mood yet.';

  // Prayer detail screen
  static const String prayerDetailAmen = 'Amen';
  static const String prayerDetailAmenSemantic = 'Say Amen';
  static const String prayerDetailShareSemantic = 'Share this prayer';

  // Converts a mood ID ('anxiety', 'peace', etc.) to its display label
  static String moodLabel(String id) {
    switch (id) {
      case 'anxiety':
        return moodAnxiety;
      case 'gratitude':
        return moodGratitude;
      case 'peace':
        return moodPeace;
      case 'grief':
        return moodGrief;
      case 'hope':
        return moodHope;
      default:
        return id;
    }
  }
}
