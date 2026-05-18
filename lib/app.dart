import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'constants/app_strings.dart';
import 'constants/app_theme.dart';
import 'screens/home/home_screen.dart';
import 'screens/answered/answered_screen.dart';
import 'screens/wellness/wellness_screen.dart';
import 'screens/breathe/breathe_screen.dart';
import 'screens/journal/journal_screen.dart';
import 'screens/settings/settings_screen.dart';

PageRoute<T> fadeRoute<T extends Object?>(Widget page) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
    );

class SoulGraceApp extends StatelessWidget {
  const SoulGraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MainShell(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(onNavigate: _navigateTo),
          const AnsweredScreen(),
          const WellnessScreen(),
          BreatheScreen(onNavigateToPrayer: () => _navigateTo(4)),
          const JournalScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(
            top: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _navigateTo,
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: AppStrings.navHome,
              tooltip: AppStrings.navHome,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: AppStrings.navAnswered,
              tooltip: AppStrings.navAnswered,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_outlined),
              activeIcon: Icon(Icons.trending_up),
              label: AppStrings.navWellness,
              tooltip: AppStrings.navWellness,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.air_outlined),
              activeIcon: Icon(Icons.air),
              label: AppStrings.navBreathe,
              tooltip: AppStrings.navBreathe,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: AppStrings.navJournal,
              tooltip: AppStrings.navJournal,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: AppStrings.navSettings,
              tooltip: AppStrings.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}
