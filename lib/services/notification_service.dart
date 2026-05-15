import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _dailyReminderId = 0;
  static const String _channelId = 'soulgrace_daily';
  static const String _channelName = 'Daily Reminder';
  static const String _notificationTitle = 'Your daily prayer is ready';

  static const List<String> _bodies = [
    'A quiet moment with God awaits you.',
    'Open your heart. Your prayer is ready.',
    'Take a breath and reflect today.',
    'Peace is just a prayer away.',
    'A moment of stillness can change your day.',
  ];

  static Future<void> init() async {
    tzdata.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
  }

  static Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      // Returns null on Android < 13 (POST_NOTIFICATIONS not required) — treat as granted.
      return await android.requestNotificationsPermission() ?? true;
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }

    return true; // other platforms
  }

  static Future<void> scheduleDailyNotification(TimeOfDay time) async {
    await cancelAll();
    final body = _bodies[DateTime.now().weekday % _bodies.length];
    await _plugin.zonedSchedule(
      _dailyReminderId,
      _notificationTitle,
      body,
      _nextOccurrence(time),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Daily prayer and reflection reminder',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static tz.TZDateTime _nextOccurrence(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var next = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (next.isBefore(now)) next = next.add(const Duration(days: 1));
    return next;
  }

  static Future<void> cancelAll() => _plugin.cancelAll();
}
