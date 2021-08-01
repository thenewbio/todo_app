import 'package:flutter/material.dart';
import 'package:mytodo/screens/todo_list_screen.dart';
import '../widgets/list_of_services.dart';
import '../widgets/app_drawer.dart';
import '../modelHomescreen/global.dart';

import 'package:marquee/marquee.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Students Comapnion (STC)"),
          centerTitle: true,
        ),
        drawer: AppDrawer(),
        body: ListView(children: [
          Container(
            padding: EdgeInsets.all(10),
            constraints: BoxConstraints(maxHeight: 130),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Marquee(
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 90,
              velocity: 150,
              pauseAfterRound: Duration(seconds: 3),
              text: 'Get Inspired everyday',
              style: titleStyleWhite,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            height: MediaQuery.of(context).size.height,
            // margin: EdgeInsets.only(top: 100),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "Our Services",
                    style: titileStyleBlack,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                      child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: choices.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 4 / 2.7,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TodoListScreen()));
                                    break;
                                  case 1:
                                    break;
                                  case 2:
                                    print('click again ');
                                    break;
                                  case 3:
                                    print('well done ');
                                    break;
                                  case 4:
                                    print('thats good of you');
                                    break;
                                  case 5:
                                    print('lasts ma');
                                    break;
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: ChoiceCard(choice: choices[index]),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            );
                          })),
                )
              ],
            ),
          ),
        ]));
  }
}
