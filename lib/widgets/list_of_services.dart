import 'package:flutter/material.dart';

class Choice {
  const Choice({this.title, this.icon});

  final String title;

  final IconData icon;
}

const List<Choice> choices = const [
  const Choice(title: 'Organize your Day', icon: Icons.local_activity),
  const Choice(title: 'Convert to PDF', icon: Icons.picture_as_pdf),
  const Choice(title: 'Create tables', icon: Icons.table_chart),
  const Choice(title: 'Compress Videos', icon: Icons.video_collection),
  const Choice(title: 'Compress PDF', icon: Icons.picture_as_pdf),
  const Choice(title: 'Create tables', icon: Icons.table_chart)
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.purple,
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Icon(choice.icon, size: 30.0, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  choice.title,
                  style: TextStyle(
                      color: Colors.white, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ]),
        ));
  }
}
