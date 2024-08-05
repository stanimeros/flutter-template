import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class LocalNotifications{
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});

      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
      await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {});
  }

  static const notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails('channelId', 'channelName', importance: Importance.max),
    iOS: DarwinNotificationDetails(),
  );

  Future showNotification({int? id, String? title, String? body, String? payload}) async {
    if (id == null){
      return;
    }

    debugPrint('Show notificaton $id');
    return notificationsPlugin.show(id++, title, body, notificationDetails);
  }

  Future<void> scheduleDailyNotification({int? id, String? hourAndMinute /*Like 10:30*/, String? title, String? body, String? payload}) async {
    if (id == null){
      return;
    }

    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    int? hour = int.tryParse(hourAndMinute!.substring(0, 2));
    int? minute = int.tryParse(hourAndMinute.substring(3, 5));
    if(hour == null || minute == null){
      debugPrint("Cannot parse $hourAndMinute");
      return;
    }

    tz.TZDateTime nextTimeToRun = _nextInstanceOfTimeOfDay(hour, minute);
    await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        nextTimeToRun,
        notificationDetails,
        // androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
    debugPrint("Scheduled $id at $hourAndMinute");
  }

  tz.TZDateTime _nextInstanceOfTimeOfDay(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
    debugPrint("Cancelled $id");
  }

  Future<int> showPendingAllNotifications() async {
    var pendingNotificationRequests = await notificationsPlugin.pendingNotificationRequests();
    debugPrint('Pending Notifications ${pendingNotificationRequests.length}');
    for (var request in pendingNotificationRequests) {
      debugPrint('Pending Notification ID: ${request.id}');
    }

    return pendingNotificationRequests.length;
  }

  Future<int> showActiveAllNotifications() async {
    var activeNotifications = await notificationsPlugin.getActiveNotifications();
    debugPrint('Active Notifications ${activeNotifications.length}');
    for (var notification in activeNotifications) {
      debugPrint('Active Notification ID: ${notification.id}');
    }

    return activeNotifications.length;
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
    debugPrint('Cancelled all notifications');
  }
}
