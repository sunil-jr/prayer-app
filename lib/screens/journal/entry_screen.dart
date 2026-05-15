import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/journal_entry.dart';
import '../../services/storage_service.dart';
import '../../widgets/mood_selector.dart';

const _uuid = Uuid();

class EntryScreen extends StatefulWidget {
  final JournalEntry? entry;

  const EntryScreen({super.key, this.entry});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;
  String? _selectedMood;
  bool _saving = false;

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.entry?.title ?? '');
    _bodyCtrl = TextEditingController(text: widget.entry?.body ?? '');
    _selectedMood = widget.entry?.mood;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();

    // Require at least some body content
    if (body.isEmpty) return;

    setState(() => _saving = true);

    final entry = JournalEntry(
      id: _isEditing ? widget.entry!.id : _uuid.v4(),
      title: title.isEmpty ? AppStrings.entryDefaultTitle : title,
      body: body,
      createdAt:
          _isEditing ? widget.entry!.createdAt : DateTime.now().toIso8601String(),
      mood: _selectedMood,
    );

    if (_isEditing) {
      await StorageService.updateEntry(entry);
    } else {
      await StorageService.saveEntry(entry);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          _isEditing
              ? AppStrings.entryScreenEditTitle
              : AppStrings.entryScreenNewTitle,
        ),
        actions: [
          Semantics(
            label: AppStrings.entryScreenSave,
            button: true,
            excludeSemantics: true,
            child: TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(64, 48),
                foregroundColor: AppColors.accent,
              ),
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      AppStrings.entryScreenSave,
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title field ───────────────────────────────────────────────────
            Semantics(
              label: AppStrings.entryTitleLabel,
              textField: true,
              child: TextField(
                controller: _titleCtrl,
                style: textTheme.titleLarge?.copyWith(fontSize: 20),
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: AppStrings.entryTitleLabel,
                  hintText: AppStrings.entryTitleHint,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: 1,
              ),
            ),
            const Divider(height: 28),
            // ── Body field ────────────────────────────────────────────────────
            Semantics(
              label: AppStrings.entryBodyLabel,
              textField: true,
              child: TextField(
                controller: _bodyCtrl,
                style: GoogleFonts.lora(
                  fontSize: 16,
                  color: AppColors.text,
                  height: 1.7,
                ),
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                minLines: 6,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: AppStrings.entryBodyLabel,
                  hintText: AppStrings.entryBodyHint,
                  hintStyle: GoogleFonts.lora(
                    color: AppColors.textLight,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // ── Mood selector ─────────────────────────────────────────────────
            Text(
              AppStrings.entryMoodLabel,
              style: textTheme.titleSmall?.copyWith(color: AppColors.textLight),
            ),
            const SizedBox(height: 12),
            MoodSelector(
              selectedMood: _selectedMood,
              onMoodChanged: (mood) => setState(() => _selectedMood = mood),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
