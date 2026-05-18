import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/answered_prayer.dart';
import '../../services/storage_service.dart';

const _uuid = Uuid();

class AnsweredScreen extends StatefulWidget {
  const AnsweredScreen({super.key});

  @override
  State<AnsweredScreen> createState() => _AnsweredScreenState();
}

class _AnsweredScreenState extends State<AnsweredScreen> {
  List<AnsweredPrayer> _all = [];
  int _tabIndex = 0; // 0=pending, 1=answered, 2=archive
  bool _loading = true;

  static const _tabs = [
    AppStrings.answeredTabPending,
    AppStrings.answeredTabAnswered,
    AppStrings.answeredTabArchive,
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await StorageService.getAnsweredPrayers();
    list.sort((a, b) => b.askedDate.compareTo(a.askedDate));
    if (mounted) setState(() { _all = list; _loading = false; });
  }

  List<AnsweredPrayer> get _filtered {
    switch (_tabIndex) {
      case 0: return _all.where((p) => p.status == PrayerStatus.pending).toList();
      case 1: return _all.where((p) => p.status == PrayerStatus.answered).toList();
      case 2: return _all.where((p) => p.status == PrayerStatus.archive).toList();
      default: return [];
    }
  }

  Future<void> _addPrayer() async {
    final result = await showModalBottomSheet<AnsweredPrayer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddPrayerSheet(),
    );
    if (result != null) {
      await StorageService.saveAnsweredPrayer(result);
      _load();
    }
  }

  Future<void> _onTapCard(AnsweredPrayer prayer) async {
    if (prayer.status != PrayerStatus.pending) return;
    final updated = await showModalBottomSheet<AnsweredPrayer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MarkAnsweredSheet(prayer: prayer),
    );
    if (updated != null) {
      await StorageService.updateAnsweredPrayer(updated);
      _load();
    }
  }

  Future<void> _confirmDelete(AnsweredPrayer prayer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.answeredDeleteTitle),
        content: const Text(AppStrings.answeredDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.answeredDeleteCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(AppStrings.answeredDeleteConfirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await StorageService.deleteAnsweredPrayer(prayer.id);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(24, topPad + 28, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.answeredTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.answeredSubtitle,
                  style: GoogleFonts.nunito(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                _SegmentedTabs(
                  tabs: _tabs,
                  selectedIndex: _tabIndex,
                  onChanged: (i) => setState(() => _tabIndex = i),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // ── List ────────────────────────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                    ? _EmptyState(tabIndex: _tabIndex)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
                        itemCount: _filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final prayer = _filtered[i];
                          return _PrayerCard(
                            prayer: prayer,
                            onTap: () => _onTapCard(prayer),
                            onLongPress: () => _confirmDelete(prayer),
                          ).animate()
                            .slideY(begin: 0.08, end: 0, duration: 260.ms, delay: (40 * i).ms, curve: Curves.easeOut)
                            .fadeIn(duration: 260.ms, delay: (40 * i).ms);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPrayer,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        tooltip: AppStrings.answeredAddTitle,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── Segmented tabs ─────────────────────────────────────────────────────────────

class _SegmentedTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final void Function(int) onChanged;

  const _SegmentedTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final active = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[i],
                  style: GoogleFonts.nunito(
                    color: active ? Colors.white : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Prayer card ────────────────────────────────────────────────────────────────

class _PrayerCard extends StatelessWidget {
  final AnsweredPrayer prayer;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _PrayerCard({
    required this.prayer,
    required this.onTap,
    required this.onLongPress,
  });

  String _fmt(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    prayer.title,
                    style: GoogleFonts.nunito(
                      color: AppColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _StatusBadge(status: prayer.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${AppStrings.answeredAsked} ${_fmt(prayer.askedDate)}',
              style: GoogleFonts.nunito(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            if (prayer.mood != null) ...[
              const SizedBox(height: 8),
              _MoodTag(mood: prayer.mood!),
            ],
            if (prayer.status == PrayerStatus.answered &&
                prayer.answerNote != null &&
                prayer.answerNote!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Text(
                AppStrings.answeredHowLabel,
                style: GoogleFonts.nunito(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
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
      ),
    );
  }
}

// ── Status badge ───────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final PrayerStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bg, icon, label) = switch (status) {
      PrayerStatus.answered => (
          AppColors.accentGreen,
          AppColors.accentGreenBg,
          Icons.eco_outlined,
          AppStrings.answeredStatusTransforming,
        ),
      PrayerStatus.pending => (
          AppColors.accentOrange,
          AppColors.accentOrangeBg,
          Icons.access_time,
          AppStrings.answeredStatusAwaiting,
        ),
      PrayerStatus.archive => (
          AppColors.textSecondary,
          AppColors.surfaceMuted,
          Icons.archive_outlined,
          'Archived',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mood tag ───────────────────────────────────────────────────────────────────

class _MoodTag extends StatelessWidget {
  final String mood;

  const _MoodTag({required this.mood});

  Color _bg() => switch (mood) {
        'anxiety' => AppColors.tagAnxiety,
        'peace' => AppColors.tagPeace,
        'gratitude' => AppColors.tagGratitude,
        'hope' => AppColors.tagHope,
        'grief' => AppColors.tagGrief,
        _ => AppColors.tagUncertain,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: _bg(), borderRadius: BorderRadius.circular(20)),
      child: Text(
        AppStrings.moodLabel(mood),
        style: GoogleFonts.nunito(
          color: AppColors.text,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final int tabIndex;

  const _EmptyState({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final messages = [
      AppStrings.answeredEmptyPending,
      AppStrings.answeredEmptyAnswered,
      AppStrings.answeredEmptyArchive,
    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tabIndex == 1 ? Icons.favorite_border : Icons.hourglass_empty,
              size: 48,
              color: AppColors.primaryMid.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              messages[tabIndex],
              style: GoogleFonts.nunito(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Add prayer bottom sheet ────────────────────────────────────────────────────

class _AddPrayerSheet extends StatefulWidget {
  const _AddPrayerSheet();

  @override
  State<_AddPrayerSheet> createState() => _AddPrayerSheetState();
}

class _AddPrayerSheetState extends State<_AddPrayerSheet> {
  final _ctrl = TextEditingController();
  String? _mood;

  static const _moods = [
    ('anxiety', 'Anxiety'),
    ('peace', 'Peace'),
    ('gratitude', 'Gratitude'),
    ('hope', 'Hope'),
    ('grief', 'Grief'),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _ctrl.text.trim();
    if (title.isEmpty) return;
    Navigator.pop(
      context,
      AnsweredPrayer(
        id: _uuid.v4(),
        title: title,
        mood: _mood,
        askedDate: DateTime.now().toIso8601String(),
        status: PrayerStatus.pending,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(AppStrings.answeredAddTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: AppStrings.answeredAddHint),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _moods.map((entry) {
              final (id, label) = entry;
              final sel = _mood == id;
              return GestureDetector(
                onTap: () => setState(() => _mood = sel ? null : id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.primary : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.nunito(
                      color: sel ? Colors.white : AppColors.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: const Text(AppStrings.answeredAddButton),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mark answered bottom sheet ────────────────────────────────────────────────

class _MarkAnsweredSheet extends StatefulWidget {
  final AnsweredPrayer prayer;

  const _MarkAnsweredSheet({required this.prayer});

  @override
  State<_MarkAnsweredSheet> createState() => _MarkAnsweredSheetState();
}

class _MarkAnsweredSheetState extends State<_MarkAnsweredSheet> {
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _markAnswered() {
    Navigator.pop(
      context,
      widget.prayer.copyWith(
        status: PrayerStatus.answered,
        answeredDate: DateTime.now().toIso8601String(),
        answerNote: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      ),
    );
  }

  void _archive() {
    Navigator.pop(context, widget.prayer.copyWith(status: PrayerStatus.archive));
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(AppStrings.answeredMarkAnswered, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            widget.prayer.title,
            style: GoogleFonts.nunito(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteCtrl,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            decoration: InputDecoration(hintText: AppStrings.answeredAnswerNoteHint),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _markAnswered,
              child: const Text(AppStrings.answeredMarkAnswered),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _archive,
              child: const Text('Move to Archive'),
            ),
          ),
        ],
      ),
    );
  }
}
