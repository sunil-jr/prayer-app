import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../data/content.dart';
import '../../../models/prayer_model.dart';
import 'onboarding_shared.dart';

class PrayerRevealPage extends StatefulWidget {
  final String mood;
  final VoidCallback onNext;

  const PrayerRevealPage({super.key, required this.mood, required this.onNext});

  @override
  State<PrayerRevealPage> createState() => _PrayerRevealPageState();
}

class _PrayerRevealPageState extends State<PrayerRevealPage> {
  late final PrayerModel _prayer;
  String _displayedBody = '';
  bool _isTypingDone = false;
  int _charIndex = 0;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _prayer = _pick();
    _startTyping();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  PrayerModel _pick() => ContentData.pickPrayer(widget.mood);

  void _startTyping() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 30), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_charIndex >= _prayer.body.length) {
        t.cancel();
        setState(() => _isTypingDone = true);
        return;
      }
      setState(() {
        _charIndex++;
        _displayedBody = _prayer.body.substring(0, _charIndex);
      });
    });
  }

  void _skipTyping() {
    if (_isTypingDone) return;
    _typingTimer?.cancel();
    setState(() {
      _displayedBody = _prayer.body;
      _charIndex = _prayer.body.length;
      _isTypingDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 40, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Label ──────────────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppStrings.onboardingPrayerTitle.toUpperCase(),
                    style: GoogleFonts.nunito(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Prayer title (instant) ─────────────────────────────────────
              Text(
                _prayer.title,
                style: GoogleFonts.lora(
                  color: AppColors.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 24),

              // ── Prayer body (typewriter) ───────────────────────────────────
              Expanded(
                child: GestureDetector(
                  onTap: _skipTyping,
                  behavior: HitTestBehavior.opaque,
                  child: SingleChildScrollView(
                    child: Text(
                      _displayedBody,
                      style: GoogleFonts.lora(
                        color: AppColors.text,
                        fontSize: 17,
                        height: 1.85,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Amen + Continue (hidden during typing) ─────────────────────
              IgnorePointer(
                ignoring: !_isTypingDone,
                child: AnimatedOpacity(
                  opacity: _isTypingDone ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 600),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          AppStrings.onboardingPrayerAmen,
                          style: GoogleFonts.lora(
                            color: AppColors.primaryMid,
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OnboardingContinueButton(
                        enabled: true,
                        onTap: widget.onNext,
                        label: AppStrings.onboardingPrayerNext,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}