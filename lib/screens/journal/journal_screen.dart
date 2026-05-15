import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    // Newest first — ISO 8601 strings sort lexicographically
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

  Future<void> _confirmDelete(JournalEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.journalDeleteTitle),
        content: const Text(AppStrings.journalDeleteBody),
        actions: [
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(64, 48)),
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.journalDeleteCancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: const Size(64, 48),
              foregroundColor: Colors.red,
            ),
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
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.journalTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? _EmptyState(onWrite: () => _openEntry())
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: _entries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    Widget tile = _JournalEntryTile(
                      entry: _entries[i],
                      onTap: () => _openEntry(entry: _entries[i]),
                      onLongPress: () => _confirmDelete(_entries[i]),
                    );
                    if (!reduceMotion) {
                      tile = tile
                          .animate()
                          .slideY(
                            begin: 0.12,
                            end: 0,
                            duration: 280.ms,
                            delay: (40 * i).ms,
                            curve: Curves.easeOut,
                          )
                          .fadeIn(
                            duration: 280.ms,
                            delay: (40 * i).ms,
                          );
                    }
                    return tile;
                  },
                ),
      floatingActionButton: Semantics(
        label: AppStrings.semanticNewEntryFab,
        child: FloatingActionButton(
          onPressed: () => _openEntry(),
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.text,
          tooltip: AppStrings.semanticNewEntryFab,
          child: const Icon(Icons.edit_outlined),
        ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExcludeSemantics(
            child: Icon(
              Icons.eco_outlined,
              size: 52,
              color: AppColors.accent.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.journalSeedEmptyState,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: onWrite,
            child: const Text(AppStrings.journalNewEntry),
          ),
        ],
      ),
    );
  }
}

// ── Entry tile ─────────────────────────────────────────────────────────────────

class _JournalEntryTile extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _JournalEntryTile({
    required this.entry,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final date = DateTime.tryParse(entry.createdAt) ?? DateTime.now();
    final formattedDate = DateFormat('d MMM y').format(date);
    final flatBody = entry.body.replaceAll('\n', ' ');
    final preview =
        flatBody.length > 80 ? '${flatBody.substring(0, 80)}…' : flatBody;

    return Semantics(
      label: '${AppStrings.semanticJournalTile}: ${entry.title}, $formattedDate. '
          '${AppStrings.semanticJournalTileDeleteHint}',
      button: true,
      excludeSemantics: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.title.isEmpty
                            ? AppStrings.entryDefaultTitle
                            : entry.title,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      formattedDate,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (preview.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    preview,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textLight,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (entry.mood != null) ...[
                  const SizedBox(height: 10),
                  _MoodPill(mood: entry.mood!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodPill extends StatelessWidget {
  final String mood;

  const _MoodPill({required this.mood});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        AppStrings.moodLabel(mood),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: AppColors.text,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
