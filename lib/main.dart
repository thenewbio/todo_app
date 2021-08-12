import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mytodo/provider/task_provider.dart';
import 'package:mytodo/provider/theme.dart';
import 'package:mytodo/views/task_views.dart';
import 'package:provider/provider.dart';

import 'service/notification.dart';

final FlutterLocalNotificationsPlugin flutterNotification = 
FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializeSettingsAndroid = 
   AndroidInitializationSettings('@mipmap/ic_launcher');
   var  initializeSettingsIos = IOSInitializationSettings(
     requestAlertPermission: true,
     requestBadgePermission: true,
     requestSoundPermission: true,
     onDidReceiveLocalNotification: 
     (int id, String title, String body, String payload) async {});
     var initializationSettings = InitializationSettings(
      android: initializeSettingsAndroid , iOS: initializeSettingsIos);
      await flutterNotification.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload' + payload);
        }
      });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: DynamicTheme(
        themeCollection: themeCollection,
        defaultThemeId: AppThemes.Dark,
        builder: (context, themeData) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Reminder App',
          theme: themeData,
          home: ReminderScreen(),
        ),
      ),
    );
  }
}
