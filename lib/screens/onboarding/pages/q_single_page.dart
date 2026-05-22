import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import 'onboarding_shared.dart';

class QOption {
  final String emoji;
  final String label;
  final String value;

  const QOption({required this.emoji, required this.label, required this.value});
}

class QSinglePage extends StatefulWidget {
  final String question;
  final double progress;
  final List<QOption> options;
  final void Function(String value) onNext;

  const QSinglePage({
    super.key,
    required this.question,
    required this.progress,
    required this.options,
    required this.onNext,
  });

  @override
  State<QSinglePage> createState() => _QSinglePageState();
}

class _QSinglePageState extends State<QSinglePage> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          OnboardingProgressBar(progress: widget.progress),
          Expanded(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 48, 28, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.question,
                      style: GoogleFonts.nunito(
                        color: AppColors.text,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.options.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final opt = widget.options[i];
                          final isSelected = _selected == opt.value;
                          return _OptionCard(
                            emoji: opt.emoji,
                            label: opt.label,
                            selected: isSelected,
                            onTap: () => setState(() => _selected = opt.value),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    OnboardingContinueButton(
                      enabled: _selected != null,
                      onTap: () => widget.onNext(_selected!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Option card ────────────────────────────────────────────────────────────────

class _OptionCard extends StatelessWidget {
  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.06)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.nunito(
                  color: selected ? AppColors.primary : AppColors.text,
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.navInactive,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
