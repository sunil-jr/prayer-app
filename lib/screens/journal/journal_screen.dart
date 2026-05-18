import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../app.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/journal_entry.dart';
import '../../services/storage_service.dart';
import 'entry_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<JournalEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await StorageService.getEntries();
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (mounted) setState(() { _entries = entries; _loading = false; });
  }

  Future<void> _openEntry({JournalEntry? entry}) async {
    final saved = await Navigator.push<bool>(
      context,
      fadeRoute(EntryScreen(entry: entry)),
    );
    if (saved == true) _loadEntries();
  }

  Future<void> _toggleFavorite(JournalEntry entry) async {
    final updated = entry.copyWith(isFavorited: !entry.isFavorited);
    await StorageService.updateEntry(updated);
    _loadEntries();
  }

  Future<void> _confirmDelete(JournalEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.journalDeleteTitle),
        content: const Text(AppStrings.journalDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.journalDeleteCancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.journalDeleteConfirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await StorageService.deleteEntry(entry.id);
      _loadEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24, topPad + 28, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.journalTitle, style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 4),
                Text(
                  AppStrings.journalSubtitle,
                  style: GoogleFonts.nunito(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _entries.isEmpty
                    ? _EmptyState(onWrite: () => _openEntry())
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        itemCount: _entries.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          Widget tile = _JournalTile(
                            entry: _entries[i],
                            onTap: () => _openEntry(entry: _entries[i]),
                            onLongPress: () => _confirmDelete(_entries[i]),
                            onFavorite: () => _toggleFavorite(_entries[i]),
                          );
                          if (!reduceMotion) {
                            tile = tile
                                .animate()
                                .slideY(
                                  begin: 0.08,
                                  end: 0,
                                  duration: 260.ms,
                                  delay: (40 * i).ms,
                                  curve: Curves.easeOut,
                                )
                                .fadeIn(duration: 260.ms, delay: (40 * i).ms);
                          }
                          return tile;
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEntry(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        tooltip: AppStrings.semanticNewEntryFab,
        child: const Icon(Icons.edit_outlined),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onWrite;

  const _EmptyState({required this.onWrite});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 52,
              color: AppColors.primaryMid.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.journalEmptyTitle,
              style: GoogleFonts.lora(
                color: AppColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.journalEmptyBody,
              style: GoogleFonts.nunito(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            TextButton(
              onPressed: onWrite,
              child: const Text(AppStrings.journalNewEntry),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Journal entry tile ─────────────────────────────────────────────────────────

class _JournalTile extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onFavorite;

  const _JournalTile({
    required this.entry,
    required this.onTap,
    required this.onLongPress,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(entry.createdAt) ?? DateTime.now();
    final formattedDate = DateFormat('MMM d, y').format(date);
    final preview = entry.body.replaceAll('\n', ' ');
    final previewText = preview.length > 90 ? '${preview.substring(0, 90)}…' : preview;

    return Semantics(
      label: '${AppStrings.semanticJournalTile}: ${entry.title}. ${AppStrings.semanticJournalTileDeleteHint}',
      button: true,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title + heart ──────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      entry.title.isEmpty ? AppStrings.entryDefaultTitle : entry.title,
                      style: GoogleFonts.nunito(
                        color: AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onFavorite,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        entry.isFavorited ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: entry.isFavorited
                            ? Colors.redAccent
                            : AppColors.navInactive,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // ── Date + mood tags ───────────────────────────────────────────
              Row(
                children: [
                  Text(
                    formattedDate,
                    style: GoogleFonts.nunito(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  if (entry.mood != null) ...[
                    const SizedBox(width: 8),
                    _MoodTag(mood: entry.mood!),
                  ],
                ],
              ),
              if (previewText.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  previewText,
                  style: GoogleFonts.nunito(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: _bg(),
        borderRadius: BorderRadius.circular(20),
      ),
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
