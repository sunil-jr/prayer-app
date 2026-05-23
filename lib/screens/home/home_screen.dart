import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../data/content.dart';
import '../../models/answered_prayer.dart';
import '../../models/verse_model.dart';
import '../../screens/prayer/prayer_detail_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../services/mood_filter_service.dart';
import '../../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int index) onNavigate;
  final VoidCallback onBreathe;

  const HomeScreen({super.key, required this.onNavigate, required this.onBreathe});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedMood;
  late VerseModel _verse;
  int _streakCount = 0;
  int _answeredCount = 0;
  AnsweredPrayer? _recentAnswered;

  static const _moods = [
    ('peaceful', AppStrings.moodPeaceful),
    ('anxiety', AppStrings.moodAnxious),
    ('gratitude', AppStrings.moodGrateful),
    ('hope', AppStrings.moodHopeful),
    ('grief', AppStrings.moodUncertain),
  ];

  @override
  void initState() {
    super.initState();
    _verse = MoodFilterService.getDailyVerse();
    _loadData();
  }

  Future<void> _loadData() async {
    final streak = await StorageService.checkAndUpdateStreak();
    final prayers = await StorageService.getAnsweredPrayers();
    final answered = prayers.where((p) => p.status == PrayerStatus.answered).toList();
    answered.sort((a, b) => (b.answeredDate ?? '').compareTo(a.answeredDate ?? ''));
    if (mounted) {
      setState(() {
        _streakCount = streak;
        _answeredCount = answered.length;
        _recentAnswered = answered.isNotEmpty ? answered.first : null;
      });
    }
  }

  void _onMoodSelected(String mood) {
    setState(() {
      _selectedMood = _selectedMood == mood ? null : mood;
      _verse = _selectedMood == null
          ? MoodFilterService.getDailyVerse()
          : MoodFilterService.getVerseForMood(_selectedMood!);
    });
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return AppStrings.homeGreetingMorning;
    if (h < 17) return AppStrings.homeGreetingAfternoon;
    return AppStrings.homeGreetingEvening;
  }

  String get _peaceTrend {
    final sessions = StorageService.getBreatheSessions();
    if (sessions == 0) return 'New';
    return '+${(sessions * 3).clamp(1, 99)}%';
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    Widget content = _buildBody();
    if (!reduceMotion) {
      content = content.animate().fadeIn(duration: 350.ms);
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: content,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GradientHeader(
            greeting: _greeting,
            selectedMood: _selectedMood,
            moods: _moods,
            onMoodSelected: _onMoodSelected,
            onSettings: () => Navigator.push(
              context,
              fadeRoute(const SettingsScreen()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatsRow(
                  streak: _streakCount,
                  answered: _answeredCount,
                  peaceTrend: _peaceTrend,
                ),
                const SizedBox(height: 16),
                _DailyVerseCard(verse: _verse),
                const SizedBox(height: 16),
                _BreatheBanner(onTap: widget.onBreathe),
                const SizedBox(height: 16),
                _TodaysPrayerCard(),
                if (_recentAnswered != null) ...[
                  const SizedBox(height: 16),
                  _RecentlyAnsweredCard(prayer: _recentAnswered!),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gradient header ────────────────────────────────────────────────────────────

class _GradientHeader extends StatelessWidget {
  final String greeting;
  final String? selectedMood;
  final List<(String, String)> moods;
  final void Function(String) onMoodSelected;
  final VoidCallback onSettings;

  const _GradientHeader({
    required this.greeting,
    required this.selectedMood,
    required this.moods,
    required this.onMoodSelected,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryDeep, AppColors.primaryMid],
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, topPad + 28, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  greeting,
                  style: GoogleFonts.lora(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white70, size: 22),
                onPressed: onSettings,
                tooltip: AppStrings.navSettings,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.homeMoodQuestion,
            style: GoogleFonts.nunito(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: moods.map((entry) {
                final (id, label) = entry;
                final selected = selectedMood == id;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _MoodPill(
                    label: label,
                    selected: selected,
                    onTap: () => onMoodSelected(id),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MoodPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.32)
              : Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: selected ? 0.7 : 0.35),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ── Stats row ──────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int streak;
  final int answered;
  final String peaceTrend;

  const _StatsRow({
    required this.streak,
    required this.answered,
    required this.peaceTrend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department,
            iconColor: AppColors.accentOrange,
            value: '$streak',
            label: AppStrings.statDayStreak,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_outline,
            iconColor: AppColors.accentGreen,
            value: '$answered',
            label: AppStrings.statAnswered,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.trending_up,
            iconColor: AppColors.primaryMid,
            value: peaceTrend,
            label: AppStrings.statPeaceTrend,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.nunito(
              color: AppColors.text,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Daily verse card ───────────────────────────────────────────────────────────

class _DailyVerseCard extends StatelessWidget {
  final VerseModel verse;

  const _DailyVerseCard({required this.verse});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppStrings.homeDailyVerse,
                style: GoogleFonts.nunito(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.bookmark_border,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Semantics(
            label: AppStrings.semanticDailyVerseCard,
            child: Text(
              verse.text,
              style: GoogleFonts.lora(
                color: AppColors.text,
                fontSize: 16,
                height: 1.65,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            verse.reference,
            style: GoogleFonts.nunito(
              color: AppColors.textPurple,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Breathe & Pray banner ──────────────────────────────────────────────────────

class _BreatheBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _BreatheBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.air, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.homeBreatheTitle,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    AppStrings.homeBreatheSubtitle,
                    style: GoogleFonts.nunito(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}

// ── Today's prayer card ────────────────────────────────────────────────────────

class _TodaysPrayerCard extends StatelessWidget {
  const _TodaysPrayerCard();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    final prayers = ContentData.prayers;
    final prayer = prayers[dayOfYear % prayers.length];
    final preview = prayer.body.replaceAll('\n', ' ');

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.homeTodaysPrayer,
            style: GoogleFonts.nunito(
              color: AppColors.text,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            preview.length > 100 ? '${preview.substring(0, 100)}…' : preview,
            style: GoogleFonts.nunito(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              fadeRoute(PrayerDetailScreen(prayer: prayer)),
            ),
            child: Text(
              AppStrings.homeReadMore,
              style: GoogleFonts.nunito(
                color: AppColors.textPurple,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Recently answered card ─────────────────────────────────────────────────────

class _RecentlyAnsweredCard extends StatelessWidget {
  final AnsweredPrayer prayer;

  const _RecentlyAnsweredCard({required this.prayer});

  @override
  Widget build(BuildContext context) {
    String fmtDate(String? iso) {
      if (iso == null) return '';
      final dt = DateTime.tryParse(iso);
      if (dt == null) return '';
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}';
    }

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.accentGreen, size: 18),
              const SizedBox(width: 8),
              Text(
                AppStrings.homeRecentlyAnswered,
                style: GoogleFonts.nunito(
                  color: AppColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            prayer.title,
            style: GoogleFonts.nunito(
              color: AppColors.text,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${AppStrings.homeAskedOn} ${fmtDate(prayer.askedDate)} • '
            '${AppStrings.homeAnsweredOn} ${fmtDate(prayer.answeredDate)}',
            style: GoogleFonts.nunito(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          if (prayer.answerNote != null && prayer.answerNote!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '"${prayer.answerNote}"',
              style: GoogleFonts.nunito(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Shared card container ──────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
