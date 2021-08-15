import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:mytodo/views/note_view.dart';
import 'package:provider/provider.dart';
import 'provider/note_provider.dart';
import 'service/notification.dart';
import '../provider/task_provider.dart';
import '../provider/theme.dart';
import '../views/pdf_screen.dart';
import '../views/task_views.dart';
import '../widget/settings.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.init();
  runApp(MyApp());
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
              PDFScreen.routeName:(ctx) => PDFScreen(),
              TodoListScreen.routeName:(ctx) => TodoListScreen()
            }
        ),
      ),
    );
  }
}
