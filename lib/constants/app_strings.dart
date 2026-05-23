class AppStrings {
  AppStrings._();

  static const String appName = 'SoulGrace';

  // ── Navigation ─────────────────────────────────────────────────────────────
  static const String navHome = 'Home';
  static const String navAnswered = 'Answered';
  static const String navWellness = 'Wellness';
  static const String navBreathe = 'Breathe';
  static const String navJournal = 'Journal';
  static const String navSettings = 'Settings';

  // ── Home ───────────────────────────────────────────────────────────────────
  static const String homeGreetingMorning = 'Good morning';
  static const String homeGreetingAfternoon = 'Good afternoon';
  static const String homeGreetingEvening = 'Good evening';
  static const String homeMoodQuestion = 'How are you feeling today?';
  static const String homeDailyVerse = 'DAILY VERSE';
  static const String homeBreatheTitle = 'Breathe & Pray';
  static const String homeBreatheSubtitle = 'Start your practice';
  static const String homeTodaysPrayer = "Today's Prayer";
  static const String homeReadMore = 'Read more';
  static const String homeRecentlyAnswered = 'Recently Answered';
  static const String homeAskedOn = 'Asked on';
  static const String homeAnsweredOn = 'Answered on';
  static String homeStreakBadge(int n) => '$n ${n == 1 ? 'day' : 'days'} streak';

  // ── Mood labels ────────────────────────────────────────────────────────────
  static const String moodPeaceful = 'Peaceful';
  static const String moodAnxious = 'Anxious';
  static const String moodGrateful = 'Grateful';
  static const String moodHopeful = 'Hopeful';
  static const String moodUncertain = 'Uncertain';

  // mood IDs → labels
  static const String moodAnxiety = 'Anxiety';
  static const String moodGratitude = 'Gratitude';
  static const String moodPeace = 'Peace';
  static const String moodGrief = 'Grief';
  static const String moodHope = 'Hope';

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
        return id[0].toUpperCase() + id.substring(1);
    }
  }

  // ── Stats ──────────────────────────────────────────────────────────────────
  static const String statDayStreak = 'Day Streak';
  static const String statAnswered = 'Answered';
  static const String statPeaceTrend = 'Peace Trend';

  // ── Answered Prayers ───────────────────────────────────────────────────────
  static const String answeredTitle = 'Answered Prayers';
  static const String answeredSubtitle = 'Watch God work in your life';
  static const String answeredTabPending = 'Pending';
  static const String answeredTabAnswered = 'Answered';
  static const String answeredTabArchive = 'Archive';
  static const String answeredAsked = 'Asked';
  static const String answeredOn = 'Answered on';
  static const String answeredHowLabel = 'How God answered:';
  static const String answeredStatusTransforming = 'Transforming';
  static const String answeredStatusAwaiting = 'Awaiting';
  static const String answeredStatusAnswered = 'Answered';
  static const String answeredEmptyPending = 'No pending prayers yet.';
  static const String answeredEmptyAnswered = 'No answered prayers recorded yet.';
  static const String answeredEmptyArchive = 'Archive is empty.';
  static const String answeredAddTitle = 'New Prayer Request';
  static const String answeredAddHint = 'What are you praying for?';
  static const String answeredAddButton = 'Add Prayer';
  static const String answeredMarkAnswered = 'Mark as Answered';
  static const String answeredAnswerNoteHint = 'How did God answer this prayer?';
  static const String answeredDeleteTitle = 'Delete prayer?';
  static const String answeredDeleteBody = 'This cannot be undone.';
  static const String answeredDeleteCancel = 'Cancel';
  static const String answeredDeleteConfirm = 'Delete';

  // ── Wellness ───────────────────────────────────────────────────────────────
  static const String wellnessTitle = 'Wellness Dashboard';
  static const String wellnessSubtitle = 'Track your spiritual journey';
  static const String wellnessMoodTrend = 'Mood Trend This Week';
  static const String wellnessPrayerFreq = 'Prayer Frequency';
  static const String wellnessPrayersThisWeek = 'prayers this week';
  static const String wellnessAnsweredMonth = 'Answered this month';
  static const String wellnessBreathingSessions = 'Breathing sessions';
  static const String wellnessInsightsTitle = 'Prayer Insights';
  static const String wellnessAnxietyPrayers = 'Anxiety prayers';
  static const String wellnessGratitudePrayers = 'Gratitude prayers';
  static const String wellnessPeacePrayers = 'Peace prayers';
  static const String wellnessAnsweredSuffix = '% answered';
  static const String wellnessNoData = 'Write journal entries to see your trends.';

  // ── Breathe ────────────────────────────────────────────────────────────────
  static const String breatheTitle = 'Breathe & Pray';
  static const String breatheDescription =
      "Take a moment to center yourself. We'll guide you through 3 breathing cycles, then invite you to pray.";
  static const String breatheBegin = 'Begin';
  static const String breatheIn = 'Breathe in...';
  static const String breatheOut = 'Breathe out...';
  static String breatheCycle(int n) => 'Cycle $n of 3';
  static const String breatheCompleteTitle = 'You\'re ready to pray';
  static const String breatheCompleteSubtitle =
      'Your mind is calm. Open your heart.';
  static const String breatheOpenPrayer = 'Open a Prayer';
  static const String breatheAgain = 'Breathe Again';
  static const String breatheBeforeAPrayer = 'Breathe Before a Prayer';
  static const String breatheCancel = 'Cancel';

  // ── Journal ────────────────────────────────────────────────────────────────
  static const String journalTitle = 'Prayer Journal';
  static const String journalSubtitle = 'Your conversations with God';
  static const String journalNewEntry = 'New Entry';
  static const String journalEmptyTitle = 'Your prayers are seeds.';
  static const String journalEmptyBody = 'Write your first one.';
  static const String journalDeleteTitle = 'Delete entry?';
  static const String journalDeleteBody = 'This action cannot be undone.';
  static const String journalDeleteCancel = 'Cancel';
  static const String journalDeleteConfirm = 'Delete';
  static const String journalStatusAwaiting = 'Awaiting answer';
  static const String journalStatusAnswered = 'Answered';

  // ── Entry screen ───────────────────────────────────────────────────────────
  static const String entryScreenNewTitle = 'New Entry';
  static const String entryScreenEditTitle = 'Edit Entry';
  static const String entryScreenSave = 'Save';
  static const String entryDefaultTitle = 'Untitled';
  static const String entryTitleLabel = 'Title';
  static const String entryTitleHint = 'Give your entry a title…';
  static const String entryBodyLabel = 'Prayer or reflection';
  static const String entryBodyHint = 'Write freely. This is your space.';
  static const String entryMoodLabel = 'How are you feeling?';

  // ── Settings ───────────────────────────────────────────────────────────────
  static const String settingsTitle = 'Settings';
  static const String settingsSubtitle = 'Customize your experience';
  static const String settingsCurrentStreak = 'Current prayer streak';
  static const String settingsNotifications = 'Notifications';
  static const String settingsDailyReminders = 'Daily reminders';
  static const String settingsReminderTime = 'Reminder time';
  static const String settingsSleepMode = 'Sleep Mode';
  static const String settingsDarkMode = 'Dark mode';
  static const String settingsDoNotDisturb = 'Do Not Disturb Prayer';
  static const String settingsSleepPack = 'Sleep Prayer Pack';
  static const String settingsSleepPackSub = '3-5 minute bedtime prayers';
  static const String settingsAbout = 'About';
  static const String settingsVersion = 'SoulGrace v1.0.0';
  static const String settingsTagline =
      '"Track your prayers. Breathe through anxiety. Watch God answer."';
  static const String settingsMadeWith = 'Made with reverence and care';

  // ── Prayer screen (sub-screen, not in nav) ─────────────────────────────────
  static const String prayerTitle = 'Prayers';
  static const String prayerEmptyForMood = 'No prayers for this mood yet.';
  static const String prayerMoodChipPrefix = 'Showing prayers for';
  static const String prayerMoodChipDismissLabel = 'Dismiss mood filter';
  static const String prayerDetailAmen = 'Amen';
  static const String prayerDetailAmenSemantic = 'Say Amen';
  static const String prayerDetailShareSemantic = 'Share this prayer';

  // ── Semantics ──────────────────────────────────────────────────────────────
  static const String semanticBookmarkVerse = 'Bookmark this verse';
  static const String semanticDailyVerseCard = 'Daily scripture verse';
  static const String semanticNewEntryFab = 'Write a new journal entry';
  static const String semanticJournalTile = 'Journal entry';
  static const String semanticJournalTileDeleteHint = 'Long press to delete';
  static String semanticStreakBadge(int n) =>
      'Current streak: $n ${n == 1 ? 'day' : 'days'}';

  // ── Onboarding ─────────────────────────────────────────────────────────────
  static const String onboardingHookLine1 = 'life gets loud.';
  static const String onboardingHookLine2 = 'God gets quiet.';
  static const String onboardingHookLine3 = "let's change that.";
  static const String onboardingHookSub =
      'Are you ready to begin your journey with God?';
  static const String onboardingBegin = "Let's Begin";
  static const String onboardingContinue = 'Continue';

  static const String onboardingQ1Question = 'what should we call you?';
  static const String onboardingQ1Hint = 'Your name';

  static const String onboardingQ2Question =
      'what brings you to SoulGrace today?';

  static const String onboardingQ3Question =
      'how often do you currently pray?';
  static const String onboardingQ3Unit = 'days a week';
  static const String onboardingQ3Never = 'never';
  static const String onboardingQ3Daily = 'every day';

  static const String onboardingQ4Question =
      'how would you describe your faith right now?';

  static const String onboardingQ5Question =
      'what gets in the way of your prayer life?';
  static const String onboardingQ5Sub = 'Select all that apply';

  static const String onboardingQ6Question =
      'what do you want from SoulGrace?';
  static const String onboardingQ6Sub = 'Select all that apply';

  static const String onboardingLoadingTitle = 'preparing your journey...';
  static const List<String> onboardingLoadingMessages = [
    'rooting you in the word...',
    'making sure this is tailored to you...',
    'gathering prayers for your heart...',
    'your experience is almost ready...',
  ];

  static const String onboardingBreathePrompt = 'Before we begin, take a breath';
  static const String onboardingBreatheIntroSub =
      'A moment of stillness before prayer goes a long way.';
  static const String onboardingBreatheStart = 'Start Breathing';
  static const String onboardingBreatheSkip = 'Continue without breathing';
  static const String onboardingBreatheIn = 'Breathe in...';
  static const String onboardingBreatheOut = 'Breathe out...';
  static const String onboardingBreatheDone = 'Great. Continue with the Prayer';

  static const String onboardingPrayerTitle = 'a prayer for you';
  static const String onboardingPrayerAmen = 'Amen';
  static const String onboardingPrayerNext = 'Continue';

  static const String onboardingVerseTitle = "today's verse";
  static const String onboardingVerseNext = 'Continue';

  static const String onboardingStreakHeading = 'your journey begins.';
  static String onboardingStreakDay(int n) => 'Day $n';
  static const String onboardingStreakSub =
      'Keep showing up. God is faithful.';
  static const String onboardingStreakCta = 'Continue Your Journey With God';

  static const String onboardingPaywallTitle = 'SoulGrace Pro';
  static const String onboardingPaywallSub = 'Deepen your faith. Every day.';
  static const String onboardingPaywallFeature1 = 'Unlimited prayer tracking';
  static const String onboardingPaywallFeature2 =
      'Daily personalized prayers & verses';
  static const String onboardingPaywallFeature3 =
      'Guided breathing & meditation';
  static const String onboardingPaywallFeature4 =
      'Spiritual wellness insights';
  static const String onboardingPaywallMonthly = 'Monthly';
  static const String onboardingPaywallMonthlyPrice = r'$4.99 / month';
  static const String onboardingPaywallYearly = 'Yearly';
  static const String onboardingPaywallYearlyPrice = r'$29.99 / year';
  static const String onboardingPaywallYearlyBadge = 'Most Popular';
  static const String onboardingPaywallLifetime = 'Lifetime';
  static const String onboardingPaywallLifetimePrice = r'$79.99 once';
  static const String onboardingPaywallCta = 'Start My Journey';
  static const String onboardingPaywallSkip = 'Maybe later';

  // ── Deprecated / legacy (kept for EntryScreen / MoodSelector) ─────────────
  static const String journalSeedEmptyState =
      'Your prayers are seeds.\nWrite your first one.';
  static const String semanticMoodFilterPrefix = 'Filter prayers by';
  static const String semanticMoodSelected = 'selected';
  static const String semanticMoodNotSelected = 'not selected';
  static const String checkInMoodAnxious = 'Anxious';
  static const String checkInMoodGrateful = 'Grateful';
  static const String checkInMoodHopeful = 'Hopeful';
  static const String checkInMoodPeaceful = 'Peaceful';
  static const String checkInMoodGrieving = 'Grieving';
  static const String settingsStreakTitle = 'Current Streak';
  static const String moodCheckInGreeting = 'How are you feeling today, friend?';
  static const String moodCheckInSubtext = "We'll find the right prayers for you.";
  static const String moodCheckInSkip = 'Skip for now';
  static const String semanticMoodCheckInSelect = 'Select mood';
  static const String prayerBegin = 'Begin Prayer';
  static const String homeDailyPrayer = 'Daily Prayer';
  static const String semanticTodaysPrayerButton = "Open today's prayer";
}
