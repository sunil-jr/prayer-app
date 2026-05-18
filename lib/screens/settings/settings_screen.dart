import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../services/notification_service.dart';
import '../../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  int _streakCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final enabled = StorageService.getBool(StorageKeys.notificationsEnabled) ?? false;
    final hour = StorageService.getInt(StorageKeys.reminderHour) ?? 9;
    final minute = StorageService.getInt(StorageKeys.reminderMinute) ?? 0;
    final streak = StorageService.getInt(StorageKeys.streakCount) ?? 0;
    setState(() {
      _notificationsEnabled = enabled;
      _reminderTime = TimeOfDay(hour: hour, minute: minute);
      _streakCount = streak;
      _loading = false;
    });
  }

  Future<void> _toggleNotifications(bool enabled) async {
    setState(() => _notificationsEnabled = enabled);
    await StorageService.setBool(StorageKeys.notificationsEnabled, enabled);
    if (enabled) {
      await NotificationService.requestPermission();
      await NotificationService.scheduleDailyNotification(_reminderTime);
    } else {
      await NotificationService.cancelAll();
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked == null || !mounted) return;
    setState(() => _reminderTime = picked);
    await StorageService.setInt(StorageKeys.reminderHour, picked.hour);
    await StorageService.setInt(StorageKeys.reminderMinute, picked.minute);
    if (_notificationsEnabled) {
      await NotificationService.scheduleDailyNotification(picked);
    }
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')} : $minute  $period';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: EdgeInsets.fromLTRB(20, topPad + 28, 20, 40),
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Text(AppStrings.settingsTitle, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 4),
          Text(
            AppStrings.settingsSubtitle,
            style: GoogleFonts.nunito(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // ── Streak card ──────────────────────────────────────────────────────
          _StreakCard(streak: _streakCount),
          const SizedBox(height: 16),

          // ── Notifications ────────────────────────────────────────────────────
          _SectionCard(
            icon: Icons.notifications_none,
            title: AppStrings.settingsNotifications,
            children: [
              _ToggleRow(
                label: AppStrings.settingsDailyReminders,
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
              ),
              if (_notificationsEnabled) ...[
                const Divider(height: 1, indent: 16, endIndent: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.settingsReminderTime,
                        style: GoogleFonts.nunito(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickTime,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.divider),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _formatTime(_reminderTime),
                            style: GoogleFonts.nunito(
                              color: AppColors.text,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // ── Sleep Mode ───────────────────────────────────────────────────────
          _SectionCard(
            icon: Icons.nightlight_round_outlined,
            title: AppStrings.settingsSleepMode,
            children: [
              _ToggleRow(
                label: AppStrings.settingsDarkMode,
                value: false,
                onChanged: (_) {},
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _ToggleRow(
                label: AppStrings.settingsDoNotDisturb,
                value: false,
                onChanged: (_) {},
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.tagPeace,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.settingsSleepPack,
                              style: GoogleFonts.nunito(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              AppStrings.settingsSleepPackSub,
                              style: GoogleFonts.nunito(
                                color: AppColors.primaryMid,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── About ────────────────────────────────────────────────────────────
          _SectionCard(
            icon: Icons.info_outline,
            title: AppStrings.settingsAbout,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.settingsVersion,
                      style: GoogleFonts.nunito(
                        color: AppColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.settingsTagline,
                      style: GoogleFonts.lora(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.settingsMadeWith,
                      style: GoogleFonts.nunito(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Streak card ────────────────────────────────────────────────────────────────

class _StreakCard extends StatelessWidget {
  final int streak;

  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppStrings.semanticStreakBadge(streak),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$streak ${streak == 1 ? 'Day' : 'Days'}',
                  style: GoogleFonts.nunito(
                    color: AppColors.text,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  AppStrings.settingsCurrentStreak,
                  style: GoogleFonts.nunito(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section card ───────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

// ── Toggle row ─────────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool) onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.nunito(color: AppColors.text, fontSize: 14),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
