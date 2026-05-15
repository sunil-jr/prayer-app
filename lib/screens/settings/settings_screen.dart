import 'package:flutter/material.dart';
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
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);
  int _streakCount = 1;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final enabled =
        StorageService.getBool(StorageKeys.notificationsEnabled) ?? false;
    final hour = StorageService.getInt(StorageKeys.reminderHour) ?? 8;
    final minute = StorageService.getInt(StorageKeys.reminderMinute) ?? 0;
    final streak = StorageService.getInt(StorageKeys.streakCount) ?? 1;
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
    await StorageService.setInt(StorageKeys.reminderHour, picked.hour);
    await StorageService.setInt(StorageKeys.reminderMinute, picked.minute);
    if (_notificationsEnabled) {
      await NotificationService.scheduleDailyNotification(picked);
    }
    setState(() => _reminderTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
        children: [
          _StreakCard(streakCount: _streakCount),
          const SizedBox(height: 32),
          Text(
            AppStrings.settingsNotifications,
            style: textTheme.titleSmall?.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                Semantics(
                  label:
                      '${AppStrings.settingsNotifications}, ${_notificationsEnabled ? 'enabled' : 'disabled'}',
                  toggled: _notificationsEnabled,
                  excludeSemantics: true,
                  child: SwitchListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: const Text(AppStrings.settingsNotifications),
                    subtitle:
                        const Text(AppStrings.settingsNotificationsSubtitle),
                    value: _notificationsEnabled,
                    activeThumbColor: AppColors.accent,
                    activeTrackColor: AppColors.accent.withValues(alpha: 0.5),
                    onChanged: _toggleNotifications,
                  ),
                ),
                if (_notificationsEnabled) ...[
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  Semantics(
                    label:
                        '${AppStrings.settingsReminderTime}: ${_reminderTime.format(context)}',
                    button: true,
                    excludeSemantics: true,
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      minTileHeight: 48,
                      title: const Text(AppStrings.settingsReminderTime),
                      trailing: Text(
                        _reminderTime.format(context),
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            AppStrings.settingsAbout,
            style: textTheme.titleSmall?.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              minTileHeight: 48,
              title: const Text(AppStrings.appName),
              trailing: Text(
                AppStrings.settingsVersion,
                style: textTheme.bodySmall?.copyWith(color: AppColors.textLight),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int streakCount;

  const _StreakCard({required this.streakCount});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: AppStrings.semanticStreakBadge(streakCount),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CD),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Color(0xFF856404),
              size: 32,
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.settingsStreakTitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF856404),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  AppStrings.homeStreakBadge(streakCount),
                  style: textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF856404),
                    fontWeight: FontWeight.w700,
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
