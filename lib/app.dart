import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/app_colors.dart';
import 'constants/app_strings.dart';
import 'constants/app_theme.dart';
import 'screens/home/home_screen.dart';
import 'screens/answered/answered_screen.dart';
import 'screens/wellness/wellness_screen.dart';
import 'screens/breathe/breathe_screen.dart';
import 'screens/journal/journal_screen.dart';
import 'screens/check_in/daily_check_in_flow.dart';
import 'screens/check_in/quick_check_in_flow.dart';
import 'screens/onboarding/onboarding_flow.dart';
import 'services/storage_service.dart';
import 'services/purchase_service.dart';
import 'screens/onboarding/pages/paywall_page.dart';

PageRoute<T> fadeRoute<T extends Object?>(Widget page) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
    );

// ── Set to false before shipping to production ─────────────────────────────────
const bool kTestOnboarding = false;
// ── Set to false before shipping to production ─────────────────────────────────
const bool kBypassPaywall = false;

Widget _resolveHome() {
  if (StorageService.getBool(StorageKeys.onboardingCompleted) != true) {
    return const OnboardingFlow();
  }
  return const EntitlementGate();
}

class EntitlementGate extends StatefulWidget {
  const EntitlementGate({super.key});

  @override
  State<EntitlementGate> createState() => _EntitlementGateState();
}

class _EntitlementGateState extends State<EntitlementGate> {
  bool? _entitled;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    if (kBypassPaywall) {
      setState(() => _entitled = true);
      return;
    }
    final ok = await PurchaseService.isEntitled();
    if (mounted) setState(() => _entitled = ok);
  }

  @override
  Widget build(BuildContext context) {
    if (_entitled == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SizedBox.shrink(),
      );
    }
    if (!_entitled!) {
      return PaywallPage(
        onPurchased: () => setState(() => _entitled = true),
      );
    }
    if (!StorageService.isDailyCheckInDone()) {
      return const DailyCheckInFlow();
    }
    return const QuickCheckInFlow();
  }
}

class SoulGraceApp extends StatelessWidget {
  const SoulGraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: kTestOnboarding ? const OnboardingFlow() : _resolveHome(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _navigateTo(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  void _openPray() {
    Navigator.push(context, fadeRoute(const BreatheScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        sizing: StackFit.expand,
        index: _currentIndex,
        children: [
          HomeScreen(onNavigate: _navigateTo, onBreathe: _openPray),
          const AnsweredScreen(),
          const WellnessScreen(),
          const JournalScreen(),
        ],
      ),
      floatingActionButton: _PrayButton(onTap: _openPray),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomBar(
        currentIndex: _currentIndex,
        onTap: _navigateTo,
      ),
    );
  }
}

// ── Pray FAB ──────────────────────────────────────────────────────────────────

class _PrayButton extends StatelessWidget {
  final VoidCallback onTap;

  const _PrayButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      elevation: 6,
      shape: const CircleBorder(),
      tooltip: AppStrings.navPray,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.self_improvement, color: Colors.white, size: 24),
          Text(
            AppStrings.navPray,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ],
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(
          begin: 1.0,
          end: 1.08,
          duration: 1400.ms,
          curve: Curves.easeInOut,
        );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _BottomBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      color: AppColors.surface,
      elevation: 8,
      padding: EdgeInsets.zero,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
        ),
        height: kBottomNavigationBarHeight,
        child: Row(
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: AppStrings.navHome,
              selected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.favorite_border,
              activeIcon: Icons.favorite,
              label: AppStrings.navAnswered,
              selected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            // Gap for FAB
            const Expanded(child: SizedBox()),
            _NavItem(
              icon: Icons.trending_up_outlined,
              activeIcon: Icons.trending_up,
              label: AppStrings.navWellness,
              selected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavItem(
              icon: Icons.menu_book_outlined,
              activeIcon: Icons.menu_book,
              label: AppStrings.navJournal,
              selected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? activeIcon : icon,
              color: selected ? AppColors.navActive : AppColors.navInactive,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.nunito(
                color: selected ? AppColors.navActive : AppColors.navInactive,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}