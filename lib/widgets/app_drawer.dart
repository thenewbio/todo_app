import 'package:flutter/material.dart';
import 'package:mytodo/screens/pdf_screen.dart';
import 'package:mytodo/settings.dart';
import 'package:mytodo/widgets/table.dart';
import 'package:mytodo/widgets/video_compress.dart';
// import 'package:mytodo/widgets/table.dart';

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
          leading: Icon(Icons.task),
          title: Text('Task'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
         ListTile(
          leading: Icon(Icons.table_chart),
          title: Text('Table'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Tables.routeName);
          },
        ),
         ListTile(
          leading: Icon(Icons.picture_as_pdf),
          title: Text('Convert to PDF'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(PDFScreen.routeName);
          },
        ),
         ListTile(
          leading: Icon(Icons.video_call),
          title: Text('Compress Video file'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(VideoCompres.routeName);
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Settings.routeName);
          },
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Help'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.contacts),
          title: Text('Follow us'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.share),
          title: Text('Share App'),
          onTap: () {},
        ),
      ])),
    );
  }
}
