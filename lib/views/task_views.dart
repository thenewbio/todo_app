import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mytodo/provider/ads_state.dart';
import 'package:mytodo/provider/task_provider.dart';
import 'package:mytodo/provider/theme.dart';
import 'package:mytodo/service/notification.dart';
import 'package:mytodo/widget/task_list.dart';
import 'package:mytodo/widget/app_drawer.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'new_task_view.dart';

class TaskScreen extends StatefulWidget {
  static const routeName = "/task";
  final String payload;
  const TaskScreen({Key key, this.payload}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
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
          builder: (ctx) => TaskScreen(
                payload: payload,
              )));

  BannerAd banner;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adstate = Provider.of<AdState>(context);
    adstate.initialize.then((status) {
      setState(() {
        banner = BannerAd(
            size: AdSize.banner,
            adUnitId: adstate.bannerAd,
            listener: adstate.adListener,
            request: AdRequest())
          ..load();
      });
    });
  }

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
          body: notifier.reminders.length == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(Icons.task_alt_outlined,
                          size: 150,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[600]
                              : Colors.grey),
                    ),
                    Text('No Task Added',
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[600]
                                    : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18))
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: notifier.reminders.length,
                        itemBuilder: (context, index) {
                          final reminders = notifier.reminders[index];
                          if (index == 0) {
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 20.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: CircularStepProgressIndicator(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Tasks",
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                                Text(
                                                    "${notifier.reminders.length}",
                                                    style:
                                                        TextStyle(fontSize: 20))
                                              ]),
                                          totalSteps:
                                              notifier.reminders.length == 1
                                                  ? notifier.reminders.length +
                                                      1
                                                  : notifier.reminders.length,
                                          currentStep: 5,
                                          stepSize: 8,
                                          selectedColor: Colors.redAccent,
                                          unselectedColor: Colors.grey[200],
                                          selectedStepSize: 10.0,
                                          height: 150,
                                          width: 150,
                                          gradientColor: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.cyan,
                                              Colors.purple
                                            ],
                                          ),
                                        ),
                                      ),
                                      TaskList(
                                        reminder: reminders,
                                        provider: notifier,
                                      )
                                    ]));
                          }
                          return TaskList(
                            reminder: reminders,
                            provider: notifier,
                          );
                        },
                      ),
                    ),
                    if (banner == null)
                      SizedBox(
                        height: 50,
                      )
                    else
                      Container(
                        height: 50,
                        child: AdWidget(
                          ad: banner,
                        ),
                      )
                  ],
                ),
          // floatingActionButtonLocation:
          // FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0x0fffd6a02),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => NewTaskScreen()));
              },
              child: Icon(Icons.add, size: 29, color: Colors.white)),
        ),
      ),
    );
  }
}
