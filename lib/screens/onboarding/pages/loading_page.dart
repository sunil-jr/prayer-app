import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';

class LoadingPage extends StatefulWidget {
  final VoidCallback onComplete;

  const LoadingPage({super.key, required this.onComplete});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnim;

  int _messageIndex = 0;
  Timer? _messageTimer;
  bool _done = false;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _progressAnim = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    );

    _progressController.forward();

    _messageTimer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      if (!mounted) return;
      setState(() {
        _messageIndex = (_messageIndex + 1) %
            AppStrings.onboardingLoadingMessages.length;
      });
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_done) {
        _done = true;
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) widget.onComplete();
        });
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDeep, AppColors.primary, AppColors.primaryMid],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // ── Title ────────────────────────────────────────────────────
                Text(
                  AppStrings.onboardingLoadingTitle,
                  style: GoogleFonts.lora(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // ── Percentage ───────────────────────────────────────────────
                AnimatedBuilder(
                  animation: _progressAnim,
                  builder: (_, _) {
                    final pct = (_progressAnim.value * 100).round();
                    return Text(
                      '$pct%',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                // ── Progress bar ─────────────────────────────────────────────
                AnimatedBuilder(
                  animation: _progressAnim,
                  builder: (_, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _progressAnim.value,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 5,
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // ── Rotating message ─────────────────────────────────────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    AppStrings.onboardingLoadingMessages[_messageIndex],
                    key: ValueKey(_messageIndex),
                    style: GoogleFonts.nunito(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
