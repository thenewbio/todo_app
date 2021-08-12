import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:mytodo/provider/task_provider.dart';
import 'package:mytodo/provider/theme.dart';
import 'package:mytodo/service/notification.dart';
import 'package:mytodo/widget/task_list.dart';
import 'package:mytodo/widgets/app_drawer.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';

import 'new_task_view.dart';

class ReminderScreen extends StatefulWidget {
  final String payload;
  const ReminderScreen({Key key, this.payload}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  int dropdownValue = 0;
  @override
  void initState() {
    Provider.of<TaskProvider>(context, listen: false).getReminders();
    super.initState();
  }

  void listenToNotification() =>
      LocalNotification.onNotifications.stream.listen(onClickedNotification);
  onClickedNotification(String payload) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => ReminderScreen(
                payload: payload,
              )));

  @override
  Widget build(BuildContext context) {
    dropdownValue = DynamicTheme.of(context).themeId;
    print(DateTime.now().subtract(Duration(days: 1)).day);
    return Consumer<TaskProvider>(
      builder: (context, notifier, child) => SafeArea(
        child: Scaffold(
          drawer: AppDrawer(),
          appBar: AppBar(
            centerTitle: true,
            title: Text('Tasks'),
            actions: [
              PopupMenuButton(
                onSelected: (value) async {
                  await DynamicTheme.of(context).setTheme(value);
                  setState(() => dropdownValue = value);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: AppThemes.LightRed, child: Text('Light mode')),
                  PopupMenuItem(value: AppThemes.Dark, child: Text('Dark mode'))
                ],
              )
            ],
          ),
          body: notifier.reminders.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(Icons.task_alt_outlined,
                          size: 100, color:
                          Theme.of(context).brightness==Brightness.dark?
                          Colors.grey[600]:Colors.grey),
                    ),
                    Text('No Task Added',
                        style: TextStyle(
                            color: Theme.of(context).brightness==Brightness.dark?
                            Colors.grey[600]:Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18))
                  ],
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: notifier.reminders.length,
                  itemBuilder: (context, index) {
                    final reminders = notifier.reminders[index];
                    return TaskList(
                      reminder: reminders,
                      provider: notifier,
                    );
                  },
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0x0fffd6a02),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => NewReminderScreen()));
              },
              child: Icon(Icons.add, size: 29, color: Colors.white)),
        ),
      ),
    );
  }
}