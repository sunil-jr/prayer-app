import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';

enum _Phase { countdown3, countdown2, countdown1, breatheIn, breatheOut }

class BreatheCountdownPage extends StatefulWidget {
  final VoidCallback onComplete;

  const BreatheCountdownPage({super.key, required this.onComplete});

  @override
  State<BreatheCountdownPage> createState() => _BreatheCountdownPageState();
}

class _BreatheCountdownPageState extends State<BreatheCountdownPage> {
  _Phase _phase = _Phase.countdown3;
  Timer? _timer;

  static const Duration _countdownStep = Duration(seconds: 1);
  static const Duration _breatheDuration = Duration(seconds: 4);

  static const double _minCircle = 110;
  static const double _maxCircle = 210;

  double get _circleSize =>
      _phase == _Phase.breatheIn ? _maxCircle : _minCircle;

  @override
  void initState() {
    super.initState();
    _scheduleNext();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _scheduleNext() {
    _timer?.cancel();
    final duration = (_phase == _Phase.breatheIn || _phase == _Phase.breatheOut)
        ? _breatheDuration
        : _countdownStep;
    _timer = Timer(duration, _advance);
  }

  void _advance() {
    if (!mounted) return;

    // Determine next phase
    _Phase? next;
    switch (_phase) {
      case _Phase.countdown3:
        next = _Phase.countdown2;
      case _Phase.countdown2:
        next = _Phase.countdown1;
      case _Phase.countdown1:
        next = _Phase.breatheIn;
      case _Phase.breatheIn:
        next = _Phase.breatheOut;
      case _Phase.breatheOut:
        widget.onComplete();
        return;
    }

    setState(() => _phase = next!);
    _scheduleNext();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDeep, AppColors.primary, AppColors.primaryMid],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: SafeArea(
        child: _isCountdown ? _buildCountdown() : _buildBreathe(),
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

  Widget _buildCountdown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.onboardingBreathePrompt,
          style: GoogleFonts.nunito(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
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

  Widget _buildBreathe() {
    final label = _phase == _Phase.breatheIn
        ? AppStrings.onboardingBreatheIn
        : AppStrings.onboardingBreatheOut;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stroke-only circle — consistent with the main BreatheScreen
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
          duration: const Duration(milliseconds: 400),
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
}
