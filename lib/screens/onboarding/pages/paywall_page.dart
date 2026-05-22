import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';

class PaywallPage extends StatefulWidget {
  final VoidCallback onFinish;

  const PaywallPage({super.key, required this.onFinish});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  int _selectedPlan = 1; // 0=monthly, 1=yearly, 2=lifetime

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Header gradient ──────────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryDeep, AppColors.primaryMid],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              28,
              MediaQuery.of(context).padding.top + 32,
              28,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.onboardingPaywallTitle,
                  style: GoogleFonts.lora(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.onboardingPaywallSub,
                  style: GoogleFonts.nunito(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                // ── Features ───────────────────────────────────────────────
                ...[
                  AppStrings.onboardingPaywallFeature1,
                  AppStrings.onboardingPaywallFeature2,
                  AppStrings.onboardingPaywallFeature3,
                  AppStrings.onboardingPaywallFeature4,
                ].map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 10),
                        Text(
                          f,
                          style: GoogleFonts.nunito(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Plan cards ───────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              children: [
                _PlanCard(
                  title: AppStrings.onboardingPaywallMonthly,
                  price: AppStrings.onboardingPaywallMonthlyPrice,
                  badge: null,
                  selected: _selectedPlan == 0,
                  onTap: () => setState(() => _selectedPlan = 0),
                ),
                const SizedBox(height: 12),
                _PlanCard(
                  title: AppStrings.onboardingPaywallYearly,
                  price: AppStrings.onboardingPaywallYearlyPrice,
                  badge: AppStrings.onboardingPaywallYearlyBadge,
                  selected: _selectedPlan == 1,
                  onTap: () => setState(() => _selectedPlan = 1),
                ),
                const SizedBox(height: 12),
                _PlanCard(
                  title: AppStrings.onboardingPaywallLifetime,
                  price: AppStrings.onboardingPaywallLifetimePrice,
                  badge: null,
                  selected: _selectedPlan == 2,
                  onTap: () => setState(() => _selectedPlan = 2),
                ),
                const SizedBox(height: 24),

                // ── Subscribe button ─────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onFinish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.onboardingPaywallCta,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Skip ─────────────────────────────────────────────────
                Center(
                  child: TextButton(
                    onPressed: widget.onFinish,
                    child: Text(
                      AppStrings.onboardingPaywallSkip,
                      style: GoogleFonts.nunito(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Plan card ──────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.badge,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.06)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.nunito(
                          color: selected ? AppColors.primary : AppColors.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            badge!,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    price,
                    style: GoogleFonts.nunito(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
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
