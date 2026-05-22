import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../data/content.dart';
import '../../services/storage_service.dart';
import '../prayer/prayer_detail_screen.dart';
import '../../app.dart';

class BreatheScreen extends StatefulWidget {
  final VoidCallback onNavigateToPrayer;

  const BreatheScreen({super.key, required this.onNavigateToPrayer});

  @override
  State<BreatheScreen> createState() => _BreatheScreenState();
}

enum _Phase { intro, breatheIn, breatheOut, complete }

class _BreatheScreenState extends State<BreatheScreen> {
  _Phase _phase = _Phase.intro;
  int _cycle = 1;
  bool _breatheForPrayer = false;
  Timer? _timer;

  static const int _totalCycles = 3;
  static const Duration _breatheDuration = Duration(seconds: 4);

  static const double _minCircle = 120;
  static const double _maxCircle = 210;

  double get _circleSize =>
      _phase == _Phase.breatheIn ? _maxCircle : _minCircle;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start({bool forPrayer = false}) {
    setState(() {
      _phase = _Phase.breatheIn;
      _cycle = 1;
      _breatheForPrayer = forPrayer;
    });
    _scheduleNext();
  }

  void _scheduleNext() {
    _timer?.cancel();
    _timer = Timer(_breatheDuration, () {
      if (!mounted) return;
      setState(() {
        if (_phase == _Phase.breatheIn) {
          _phase = _Phase.breatheOut;
        } else if (_phase == _Phase.breatheOut) {
          if (_cycle >= _totalCycles) {
            _phase = _Phase.complete;
            StorageService.incrementBreatheSessions();
            if (_breatheForPrayer) {
              _timer = Timer(const Duration(milliseconds: 800), () {
                if (mounted) _openPrayer();
              });
            }
            return;
          }
          _cycle++;
          _phase = _Phase.breatheIn;
        }
      });
      if (_phase != _Phase.complete) _scheduleNext();
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _phase = _Phase.intro;
      _cycle = 1;
      _breatheForPrayer = false;
    });
  }

  void _openPrayer() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    final prayers = ContentData.prayers;
    final prayer = prayers[dayOfYear % prayers.length];
    Navigator.push(context, fadeRoute(PrayerDetailScreen(prayer: prayer)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryDeep, AppColors.primaryLight],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: _phase == _Phase.intro
                  ? _buildIntro()
                  : _phase == _Phase.complete
                      ? _buildComplete()
                      : _buildActive(),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom +
                  kBottomNavigationBarHeight,
            ),
          ],
        ),
      ),
    );
  }

  // ── Intro state ──────────────────────────────────────────────────────────────

  Widget _buildIntro() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.breatheTitle,
            style: GoogleFonts.lora(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.breatheDescription,
            style: GoogleFonts.nunito(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 15,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 52),

          // ── Begin ──────────────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _start(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: Text(
                AppStrings.breatheBegin,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ── Breathe before a prayer ────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _start(forPrayer: true),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.55), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                AppStrings.breatheBeforeAPrayer,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Active breathing state ───────────────────────────────────────────────────

  Widget _buildActive() {
    final label = _phase == _Phase.breatheIn
        ? AppStrings.breatheIn
        : AppStrings.breatheOut;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Stroke-only animated circle ──────────────────────────────────────
        AnimatedContainer(
          duration: _breatheDuration,
          curve: Curves.easeInOut,
          width: _circleSize,
          height: _circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.65),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.12),
                blurRadius: 36,
                spreadRadius: _phase == _Phase.breatheIn ? 14 : 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 52),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: Text(
            label,
            key: ValueKey(label),
            style: GoogleFonts.lora(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppStrings.breatheCycle(_cycle),
          style: GoogleFonts.nunito(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 52),
        TextButton(
          onPressed: _reset,
          child: Text(
            AppStrings.breatheCancel,
            style: GoogleFonts.nunito(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  // ── Complete state ───────────────────────────────────────────────────────────

  Widget _buildComplete() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 28),
          Text(
            AppStrings.breatheCompleteTitle,
            style: GoogleFonts.lora(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.breatheCompleteSubtitle,
            style: GoogleFonts.nunito(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 15,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _openPrayer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: Text(
                AppStrings.breatheOpenPrayer,
                style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: _reset,
            child: Text(
              AppStrings.breatheAgain,
              style: GoogleFonts.nunito(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
