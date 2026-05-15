import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/prayer_model.dart';

class PrayerDetailScreen extends StatelessWidget {
  final PrayerModel prayer;

  const PrayerDetailScreen({super.key, required this.prayer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          prayer.title,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Semantics(
            label: AppStrings.prayerDetailShareSemantic,
            button: true,
            excludeSemantics: true,
            child: IconButton(
              onPressed: () =>
                  Share.share(prayer.body, subject: prayer.title),
              icon: const Icon(Icons.share_outlined),
              tooltip: AppStrings.prayerDetailShareSemantic,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Text(
                  prayer.body,
                  style: GoogleFonts.lora(
                    fontSize: 18,
                    color: AppColors.text,
                    height: 1.8,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
              child: _AmenButton(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Amen button with scale-pulse animation on press ───────────────────────────

class _AmenButton extends StatefulWidget {
  const _AmenButton();

  @override
  State<_AmenButton> createState() => _AmenButtonState();
}

class _AmenButtonState extends State<_AmenButton> {
  int _tapCount = 0;

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => setState(() => _tapCount++),
        child: const Text(AppStrings.prayerDetailAmen),
      ),
    );

    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final animated = (_tapCount == 0 || reduceMotion)
        ? button
        : button
            .animate(key: ValueKey(_tapCount))
            .scaleXY(
              begin: 1.0,
              end: 1.06,
              duration: 130.ms,
              curve: Curves.easeOut,
            )
            .then(delay: 30.ms)
            .scaleXY(
              begin: 1.06,
              end: 1.0,
              duration: 130.ms,
              curve: Curves.easeIn,
            );

    return Semantics(
      label: AppStrings.prayerDetailAmenSemantic,
      button: true,
      excludeSemantics: true,
      child: animated,
    );
  }
}
