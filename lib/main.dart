import 'package:flutter/material.dart';
import 'package:mytodo/screens/homescreen.dart';
// import 'package:mytodo/widdgets/widgetcompress/video_compress.dart';
// import '../screens/homescreen.dart';
// import '../screens/todo_list_screen.dart';
import '../settings.dart';
import '../widdgets/table.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo pro',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
      routes: {
          Settings.routeName: (context) => Settings(),
          Tables.routeName: (context) => Table()
        }
    );
  }
}

