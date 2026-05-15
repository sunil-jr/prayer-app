import 'package:flutter/material.dart';
import 'constants/app_strings.dart';
import 'constants/app_theme.dart';
import 'screens/home/home_screen.dart';
import 'screens/prayer/prayer_screen.dart';
import 'screens/journal/journal_screen.dart';
import 'screens/settings/settings_screen.dart';

/// Gentle 300 ms opacity crossfade — used everywhere instead of the default slide.
PageRoute<T> fadeRoute<T extends Object?>(Widget page) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 300),
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
          const PrayerScreen(),
          const JournalScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateTo,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.navHome,
            tooltip: AppStrings.navHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            activeIcon: Icon(Icons.self_improvement),
            label: AppStrings.navPrayer,
            tooltip: AppStrings.navPrayer,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
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
    );
  }
}

// Helper accessible anywhere below MainShell to jump tabs.
class NavController extends InheritedWidget {
  final void Function(int index) navigateTo;

  const NavController({
    super.key,
    required this.navigateTo,
    required super.child,
  });

  static NavController? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NavController>();

  @override
  bool updateShouldNotify(NavController oldWidget) =>
      navigateTo != oldWidget.navigateTo;
}
