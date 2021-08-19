import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:mytodo/database/note_db.dart';
import 'package:mytodo/model/notes.dart';
import 'package:mytodo/provider/ads_state.dart';
import 'package:mytodo/provider/note_provider.dart';
import 'package:mytodo/provider/theme.dart';

import 'package:mytodo/widget/app_drawer.dart';
import 'package:mytodo/widget/new_note.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TodoListScreen extends StatefulWidget {
  static const routeName = "./";
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Future<List<Note>> _taskList;
  DateTime timing;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getNoteList();
    });
  }

  Widget _buildTask(Note task) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AddTaskScreen(updateTasklist: _updateTaskList, task: task),
          )),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(task.title, style: TextStyle(fontSize: 20)),
                      IconButton(
                          onPressed: () =>
                              Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddTaskScreen(
                        updateTasklist: _updateTaskList,
                      ))),
                          icon: Icon(Icons.edit))
                    ],
                  ),
                  Text(
                    task.time,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${_dateFormat.format(task.date)}"),
                      Text("${task.priority}", style: TextStyle(fontSize: 15)),
                    ],
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

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

  int dropdownValue = 0;
  @override
  Widget build(BuildContext context) {
    dropdownValue = DynamicTheme.of(context).themeId;
    return Scaffold(
      appBar: AppBar(title: Text("MY NOTES"), centerTitle: true, actions: [
        PopupMenuButton(
          onSelected: (value) async {
            await DynamicTheme.of(context).setTheme(value);
            setState(() => dropdownValue = value);
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: AppThemes.LightRed, child: Text('Light mode')),
            PopupMenuItem(value: AppThemes.Dark, child: Text('Dark mode'))
          ],
        )
      ]),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddTaskScreen(
                        updateTasklist: _updateTaskList,
                      )))),
      body: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Container(
                          child: Image.asset("assets/images/empty.png",
                              height: 200.0),
                        ),
                        Center(
                            child: Text(
                          "No task added",
                          style: TextStyle(fontSize: 20),
                        ))
                      ])
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: 1 + snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 20.0),
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
                                                Text("Notes",
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                                Text("${snapshot.data.length}",
                                                    style:
                                                        TextStyle(fontSize: 20))
                                              ]),
                                          totalSteps: snapshot.data.length == 0
                                              ? snapshot.data.length + 1
                                              : snapshot.data.length,
                                          currentStep: 6,
                                          stepSize: 10,
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
                                      )
                                    ],
                                  ),
                                );
                              }
                              return _buildTask(snapshot.data[index - 1]);
                            }),
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
                  );
          }),
    );
  }
}
