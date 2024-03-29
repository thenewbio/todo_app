import 'package:flutter/material.dart';
import 'package:mytodo/provider/task_provider.dart';
import 'package:mytodo/views/note_view.dart';
import 'package:mytodo/views/task_views.dart';
import 'package:mytodo/widget/settings.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: Colors.purple),
          height: 100,
          child: Center(
              child: Text("Organise your day!",
                  style: TextStyle(color: Colors.white, fontSize: 30))),
        ),
       
        ListTile(
          leading: Icon(Icons.note),
          title: Text('Make Note'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed('./');
          },
        ),
         ListTile(
          leading: Icon(Icons.task),
          title: Text('Task'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(TaskScreen.routeName);
          },
        ),
        ListTile(
          leading: Icon(Icons.table_chart),
          title: Text('Table'),
          onTap: () {
            Provider.of<TaskProvider>(context, listen: false).createExcel();
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Settings.routeName);
          },
        ),
        // ListTile(
        //   leading: Icon(Icons.star),
        //   title: Text('Rate Us'),
        //   onTap: () {
        //      Provider.of<TaskProvider>(context,listen:false).help(context);
        //   },
        // ),
        ListTile(
            leading: Icon(Icons.contacts),
            title: Text('Follow us'),
            onTap: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .showMessageDialog(context);
            }),
      ])),
    );
  }
}
