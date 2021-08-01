import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:mytodo/models/ads_state.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../helper/database_helper.dart';
import '../models/task_model.dart';
import '../screens/add_task_screen.dart';
import '../widgets/app_drawer.dart';

class TodoListScreen extends StatefulWidget {
  static const routeName = "./";
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
   Future<List<Task>> _taskList;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Widget _buildTask(Task task) {
    return 
          Card(
            color: Colors.purple,
            child: ListTile(
              leading: Checkbox(
                onChanged: (value) {
                  task.status = value ? 1 : 0;
                  DatabaseHelper.instance.updateTask(task);
                  _updateTaskList();
                },
                activeColor: Theme.of(context).primaryColor,
                value: task.status == 1 ? true : false,
              ),
              title: Text(
                task.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              subtitle: Text(
                "${_dateFormat.format(task.date)}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              trailing: Text(
                "${task.priority}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddTaskScreen(
                        updateTasklist: _updateTaskList, task: task),
                  )),
            ),
          
        //  if(bannerAd == null) 
        //  Divider(
      
        //   )
        // else
        // Container(
        //   height: 50,
        //   child: AdWidget(ad: bannerAd,),
        // )
      
    );
  }
  BannerAd bannerAd;
  @override
  void didChangeDependencies() {
   final adState = Provider.of<AdState>(context);
   adState.initialize.then((status) {
  setState(() {
    bannerAd = BannerAd(
      size: AdSize.banner, 
    adUnitId: adState.bannerAd, 
    listener: adState.adListener, 
    request: AdRequest()
    )..load();
  });

   });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Tasks"),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
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
            final int completedTaskCount = snapshot.data
                .where((Task task) => task.status == 1)
                .toList()
                .length;

            return snapshot.data.length == 0? Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Container(
                child: Image.asset("assets/images/emty.png"),
              ),
              Center(child: Text("No task added",style: TextStyle(fontSize: 20),))
               ] ) :ListView.builder(
                itemCount: 1 + snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircularStepProgressIndicator(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Tasks",
                                        style: TextStyle(fontSize: 20)),
                                    Text("${snapshot.data.length}",
                                        style: TextStyle(fontSize: 20))
                                  ]),
                              totalSteps: snapshot.data.length == 0 ? snapshot.data.length +1 : snapshot.data.length,
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
                                colors: [Colors.cyan, Colors.purple],
                              ),
                            ),
                          ),
                          Text(
                            'Tasks completed $completedTaskCount',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    );
                  }
                  return _buildTask(snapshot.data[index - 1]);
                });
          }),
    );
  }
}
