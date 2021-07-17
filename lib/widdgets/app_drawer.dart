import 'package:flutter/material.dart';
import 'package:mytodo/settings.dart';
import 'package:mytodo/widdgets/table.dart';


class AppDrawer extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    return Drawer(
       child: ListView(
            padding: EdgeInsets.zero,
            children: [
           Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
               color: Colors.purple
             ),
             height: 150,
             child: Center(child: Text("Organise your day!",style: TextStyle(color: Colors.white,fontSize: 30))),
           ),

            ListTile(
              leading: Icon(Icons.task),
              title: Text('Tasks'),
              onTap: (){
             Navigator.of(context).pushReplacementNamed('/');
              },
            ),
           ListTile(
              leading: Icon(Icons.table_chart),
              title: Text('Table'),
              onTap: (){
                Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => Tables(
         
        )));
              },
            ),
             ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: (){
                Navigator.of(context).pushReplacementNamed(Settings.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('Follow us'),
              onTap: (){},
            ),

             ListTile(
              leading: Icon(Icons.share),
              title: Text('Share App'),
              onTap: (){},
            ),
             ListTile(
              leading: Icon(Icons.person),
              title: Text('About us'),
              onTap: (){},
            ),
             ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: (){},
            ),
            ]
     )
   );
  }
  
}