import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mytodo/provider/task_provider.dart';
import 'package:mytodo/provider/theme.dart';
import 'package:mytodo/screens/pdf_screen.dart';
import 'package:mytodo/views/task_views.dart';
import 'package:mytodo/widgets/settings.dart';
import 'package:provider/provider.dart';

import 'service/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.init();
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
          title: 'Todo-Plus',
          theme: themeData,
          home: ReminderScreen(),
           routes: {
              Settings.routeName: (context) => Settings(),
              PDFScreen.routeName:(ctx) => PDFScreen()
            }
        ),
      ),
    );
  }
}
