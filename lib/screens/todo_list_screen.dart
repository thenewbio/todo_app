import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytodo/helper/database_helper.dart';
import 'package:mytodo/models/task_model.dart';
import 'package:mytodo/screens/add_task_screen.dart';
import 'package:mytodo/widdgets/app_drawer.dart';

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

_updateTaskList(){
  setState(() {
    _taskList = DatabaseHelper.instance.getTaskList();
  });
}

Widget _buildTask(Task task) {
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: 25.0),
    child: Column(
      children: [
        ListTile(
          leading: Text('${task.time.hour}:${task.time.minute}'),
          title: Text(task.title,
          style: TextStyle(fontSize: 18,
          decoration: task.status == 0 
          ? TextDecoration.none
          : TextDecoration.lineThrough),
          ),
          subtitle: Text("${_dateFormat.format(task.date)} + ${task.priority}",
           style: TextStyle(fontSize: 15,
          decoration: task.status == 0 
          ? TextDecoration.none
          : TextDecoration.lineThrough),
          ),
          trailing: Checkbox(
            onChanged: (value) {
            task.status = value ? 1 : 0;
            DatabaseHelper.instance.updateTask(task);
            _updateTaskList();
          },
          activeColor: Theme.of(context).primaryColor,
          value: task.status == 1 ? true : false,
          ),
          onTap: () => Navigator.push(
            context, 
          MaterialPageRoute(builder: (_) => AddTaskScreen(
            updateTasklist: _updateTaskList,
          task: task
          ),
          )),
        ),
        Divider()
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => AddTaskScreen(
          updateTasklist: _updateTaskList,
        )))
       
      ),
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

         return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 0.0),
          itemCount:  1 + snapshot.data.length,
          itemBuilder: (BuildContext context, int index){
            if(index == 0) {
              return Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Tasks',style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),),
                     SizedBox(height: 10,),
                    Text('$completedTaskCount of ${snapshot.data.length}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),)
                  ],
                ),
              );
            }
            return _buildTask(snapshot.data[index - 1]);
          }
          );
        }
      ),
    );
  }
}