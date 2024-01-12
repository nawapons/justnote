import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotifcationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('launcher_icon');

  void initializeNotificaions() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: _androidInitializationSettings); //
    await _flutterLocalNotifcationsPlugin.initialize(initializationSettings);
  }

  void scheduleNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.max);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotifcationsPlugin.periodicallyShow(
        0,
        "You have tasks not done",
        "Go check to tasks now!!",
        RepeatInterval.hourly,
        notificationDetails);
  }
}
