import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';

enum _Phase { intro, countdown3, countdown2, countdown1, breatheIn, breatheOut, done }

class BreatheCountdownPage extends StatefulWidget {
  final VoidCallback onComplete;

  const BreatheCountdownPage({super.key, required this.onComplete});

  @override
  State<BreatheCountdownPage> createState() => _BreatheCountdownPageState();
}

class _BreatheCountdownPageState extends State<BreatheCountdownPage> {
  _Phase _phase = _Phase.intro;
  Timer? _timer;
  bool _circleReady = false;

  static const Duration _countdownStep = Duration(seconds: 1);
  static const Duration _breatheDuration = Duration(seconds: 4);

  static const double _minCircle = 20;
  static const double _maxCircle = 210;

  // On first frame of breatheIn, _circleReady is false so we render at _minCircle.
  // The post-frame callback sets it true, triggering the expand animation.
  double get _circleSize =>
      (_phase == _Phase.breatheIn && _circleReady) ? _maxCircle : _minCircle;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startBreathing() {
    setState(() => _phase = _Phase.countdown3);
    _scheduleNext();
  }

  void _scheduleNext() {
    _timer?.cancel();
    final duration =
        (_phase == _Phase.breatheIn || _phase == _Phase.breatheOut)
            ? _breatheDuration
            : _countdownStep;
    _timer = Timer(duration, _advance);
  }

  void _advance() {
    if (!mounted) return;

    _Phase? next;
    switch (_phase) {
      case _Phase.intro:
        return;
      case _Phase.countdown3:
        next = _Phase.countdown2;
      case _Phase.countdown2:
        next = _Phase.countdown1;
      case _Phase.countdown1:
        next = _Phase.breatheIn;
      case _Phase.breatheIn:
        next = _Phase.breatheOut;
      case _Phase.breatheOut:
        next = _Phase.done;
      case _Phase.done:
        return;
    }

    setState(() {
      _phase = next!;
      if (_phase == _Phase.breatheIn) _circleReady = false;
    });

    if (_phase == _Phase.breatheIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _circleReady = true);
      });
    }

    if (_phase != _Phase.done) _scheduleNext();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(decoration: TextDecoration.none),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDeep, AppColors.primary, AppColors.primaryMid],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: _phase == _Phase.intro
                ? _buildIntro()
                : _phase == _Phase.done
                    ? _buildDone()
                    : _isCountdown
                        ? _buildCountdown()
                        : _buildBreathe(),
          ),
        ),
      ),
    );
  }

  bool get _isCountdown =>
      _phase == _Phase.countdown3 ||
      _phase == _Phase.countdown2 ||
      _phase == _Phase.countdown1;

  String get _countdownNumber => switch (_phase) {
        _Phase.countdown3 => '3',
        _Phase.countdown2 => '2',
        _Phase.countdown1 => '1',
        _ => '',
      };

  // ── Intro ────────────────────────────────────────────────────────────────────

  Widget _buildIntro() {
    return Padding(
      key: const ValueKey('intro'),
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.onboardingBreathePrompt,
            style: GoogleFonts.lora(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Text(
            AppStrings.onboardingBreatheIntroSub,
            style: GoogleFonts.nunito(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 15,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 52),

          // ── Start Breathing ────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _startBreathing,
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
                AppStrings.onboardingBreatheStart,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ── Skip ──────────────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onComplete,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                AppStrings.onboardingBreatheSkip,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.88),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Countdown ────────────────────────────────────────────────────────────────

  Widget _buildCountdown() {
    return Column(
      key: const ValueKey('countdown'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.onboardingBreathePrompt,
          style: GoogleFonts.nunito(
            color: Colors.white.withValues(alpha: 0.72),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: anim,
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: Text(
            _countdownNumber,
            key: ValueKey(_countdownNumber),
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 120,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  // ── Breathe ──────────────────────────────────────────────────────────────────

  Widget _buildBreathe() {
    final label = _phase == _Phase.breatheIn
        ? AppStrings.onboardingBreatheIn
        : AppStrings.onboardingBreatheOut;

    return Column(
      key: const ValueKey('breathe'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Circle starts tiny (pea), expands on inhale, contracts on exhale
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
      ],
    );
  }

  // ── Done ─────────────────────────────────────────────────────────────────────

  Widget _buildDone() {
    return Padding(
      key: const ValueKey('done'),
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
            AppStrings.onboardingBreatheDone,
            style: GoogleFonts.lora(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onComplete,
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
                AppStrings.onboardingBreatheDone,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}