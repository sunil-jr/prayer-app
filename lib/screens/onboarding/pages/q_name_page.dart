import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import 'onboarding_shared.dart';

class QNamePage extends StatefulWidget {
  final void Function(String name) onNext;

  const QNamePage({super.key, required this.onNext});

  @override
  State<QNamePage> createState() => _QNamePageState();
}

class _QNamePageState extends State<QNamePage> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          OnboardingProgressBar(progress: 1 / 6),
          Expanded(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 48, 28, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.onboardingQ1Question,
                      style: GoogleFonts.nunito(
                        color: AppColors.text,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 36),
                    TextField(
                      controller: _controller,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        hintText: AppStrings.onboardingQ1Hint,
                        hintStyle: GoogleFonts.nunito(
                          color: AppColors.textSecondary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.divider, width: 2),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.only(bottom: 8),
                      ),
                      onSubmitted: (_) {
                        if (_hasText) {
                          FocusScope.of(context).unfocus();
                          widget.onNext(_controller.text.trim());
                        }
                      },
                    ),
                    const Spacer(),
                    OnboardingContinueButton(
                      enabled: _hasText,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        widget.onNext(_controller.text.trim());
                      },
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
