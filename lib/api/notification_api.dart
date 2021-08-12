import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';


class NotificationApi {

  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails()
    );
  }

  static Future init({bool initScheduled = false}) async {
    final iOS = IOSInitializationSettings();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notification.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      }
    );

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification({
    int id = 0,
    String title,
    String body,
    String payload,
  }) async =>
    _notification.show(
      id, 
      title, 
      body, 
    await _notificationDetails(),
    payload: payload
    );
     static Future showScheduledNotification({
    int id = 0,
    String title,
    String body,
    String payload,
    @required DateTime scheduleDate,
  }) async =>
    _notification.zonedSchedule(
      id, 
      title, 
      body, 
      _scheduleWeekly(Time(8), days: [DateTime.monday, DateTime.tuesday]),
    await _notificationDetails(),
    payload: payload,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime
    );

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime( tz.local, now.year, now.month,now.day,time.hour,time.minute, time.second);

    return scheduledDate.isBefore(now)
    ? scheduledDate.add(Duration(days: 1))
    : scheduledDate;
  }

  static tz.TZDateTime _scheduleWeekly(Time time, {@required List<int> days}) {
    tz.TZDateTime scheduledDate = _scheduleDaily(time);

    while (!days.contains(scheduledDate.weekday)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }
    return scheduledDate;
  }
}