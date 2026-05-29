import 'package:flutter/material.dart';
import 'app.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'services/purchase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await StorageService.checkAndUpdateStreak();
  await NotificationService.init();
  await PurchaseService.init();
  runApp(const SoulGraceApp());
}
