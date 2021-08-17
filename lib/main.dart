import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mytodo/provider/ads_state.dart';
import 'package:mytodo/views/note_view.dart';
import 'package:provider/provider.dart';
import 'provider/note_provider.dart';
import 'service/notification.dart';
import '../provider/task_provider.dart';
import '../provider/theme.dart';
import '../views/task_views.dart';
import '../widget/settings.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.init();
  final initFuture = MobileAds.instance.initialize();
  final adstate = AdState(initFuture);
  runApp(Provider.value(
    value: adstate,
    builder: (context, child) => MyApp()
    ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
    ChangeNotifierProvider(
      create: (context) => TaskProvider()),
      ChangeNotifierProvider(
      create: (context) => NoteProvider()),
    ],
    
      child: DynamicTheme(
        themeCollection: themeCollection,
        defaultThemeId: AppThemes.Dark,
        builder: (context, themeData) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo-Plus',
          theme: themeData,
          home: ReminderScreen(),
           routes: {
              Settings.routeName: (context) => Settings(),
              TodoListScreen.routeName:(ctx) => TodoListScreen()
            }
        ),
      ),
    );
  }
}
