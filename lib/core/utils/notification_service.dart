import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }

  static Future showNotification(String title, String body) async {
    final androidDetails = AndroidNotificationDetails(
      'price_channel',
      'Price Alerts',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'New Price Alert',
      enableLights: true,
      enableVibration: true,
      color: Color(0xFFFBC700),
      ledColor: Color(0xFFFBC700),
      ledOnMs: 1000,
      ledOffMs: 500,
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        summaryText: 'Crypto Price Update',
      ),
    );

    final notificationDetails = NotificationDetails(android: androidDetails);
    await _notifications.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}
