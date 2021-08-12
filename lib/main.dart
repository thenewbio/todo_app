import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mytodo/models/ads_state.dart';
import 'package:mytodo/models/theme.dart';
import 'package:mytodo/screens/pdf_screen.dart';
import 'package:mytodo/screens/todo_list_screen.dart';
import 'package:mytodo/widgets/video_compress.dart';
import 'package:provider/provider.dart';
import '../settings.dart';
import '../widgets/table.dart';


final FlutterLocalNotificationsPlugin flutterNotification = 
FlutterLocalNotificationsPlugin();

main() async {
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
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  runApp(Provider.value(
    value: adState,
    builder: (context , child) => MyApp(),
     )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
         return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Todo pro',
            theme: notifier.darkTheme ? dark : light,
            home: TodoListScreen(),
            routes: {
              Settings.routeName: (context) => Settings(),
              Tables.routeName: (context) => Table(),
              VideoCompres.routeName: (ctx) => VideoCompres(),
              PDFScreen.routeName:(ctx) => PDFScreen()
            });
        },
        
      ),
    );
  }
}
