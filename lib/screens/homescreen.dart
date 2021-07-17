import 'package:flutter/material.dart';
import '../screens/compress_screen.dart';
import '../screens/todo_list_screen.dart';
import '../widdgets/app_drawer.dart';
import '../widdgets/table.dart';
import '../widdgets/widgetcompress/video_compress.dart';
import '../modelHomescreen/global.dart';
import '../modelHomescreen/job.dart';
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
          title: Text('Welcome'),
          centerTitle: true,
        ),
        drawer: AppDrawer(),
        body:
          SingleChildScrollView(
            child: Container(
                      color: backgroundColor,
                      child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        constraints: BoxConstraints.expand(height: 225),
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [lightBlueIsh, lightGreen],
                            begin: const FractionalOffset(1.0, 1.0),
                            end: const FractionalOffset(0.2, 0.2),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                          ),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight:  Radius.circular(30))
                        ),
                        child: 
                              Marquee(
                                crossAxisAlignment:  CrossAxisAlignment.start,
                                blankSpace: 90,
                                velocity: 150,
                                pauseAfterRound: Duration(seconds: 3),
                                text: 'Find Your New Job', style: titleStyleWhite,
                              )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        constraints: BoxConstraints.expand(height:200),
                        child: ListView(
                          padding: EdgeInsets.only(left: 40),
                          scrollDirection: Axis.horizontal,
                          children: getRecentJobs()
                        ),
                      ),
                      Container(
                        height: 500,
                        margin: EdgeInsets.only(top: 220),
                        padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Explore New Opportunities",
                                  style: titileStyleBlack, 
                                  ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 400,
                                child: ListView(
                                  children: getJobCategories(),
                                ),
                              )
                            ],
                          ),
                      )
                    ],
                  )
                ],
                      ),
            ),
          )
    );
  }
  List<String> jobCategories = ["Sales", "Engineering", "Health", "Education", "Finance"];

  Map jobCatToIcon = {
    "Sales" : Icon(Icons.monetization_on, color: lightBlueIsh, size: 50,),
    "Engineering" : Icon(Icons.settings, color: lightBlueIsh, size: 50),
    "Health" : Icon(Icons.healing, color: lightBlueIsh, size: 50),
    "Education" : Icon(Icons.search, color: lightBlueIsh, size: 50),
    "Finance" : Icon(Icons.card_membership, color: lightBlueIsh, size: 50),
  };

  Widget getCategoryContainer(String categoryName) {
    return new Container(
          margin: EdgeInsets.only(right: 10, left: 10, bottom: 10),
          height: 180,
          width: 140,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              new BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Text(categoryName, style: titileStyleLighterBlack),
              Container(
                padding: EdgeInsets.only(top: 30),
                height: 100,
                width: 70,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child:  jobCatToIcon[categoryName],
                  elevation: 10,
                  onPressed: () {
                    if (categoryName == "Sales"){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => TodoListScreen()));
                  } else if(categoryName == "Engineering"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Tables()));
                  } else if (categoryName == "Health"){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCompres()));
                  } else if (categoryName == "Education"){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CompressScreen()));
                  } else {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCompres()));
                  }
                  
                  }
                ),
              )
            ],
          ),
        );
  }

  List<Widget> getJobCategories() {
    List<Widget> jobCategoriesCards = [];
    List<Widget> rows = [];
    int i = 0;
    for (String category in jobCategories) {
      if (i < 2) {
        rows.add(getCategoryContainer(category));
        i ++;
      } else {
        i = 0;
        jobCategoriesCards.add(new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rows,
        ));
        rows = [];
        rows.add(getCategoryContainer(category));
        i++;
      }
    }
    if (rows.length > 0) {
      jobCategoriesCards.add(new Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: rows,
        ));
    }
    return jobCategoriesCards;
  }

  List<Job> findJobs() {
    List<Job> jobs = [];
    for (int i = 0; i < 10; i++) {
      jobs.add(new Job("Volvo", "Frontend Developer", 20000, "Remote", "Part time", new AssetImage("assets/images/empty.png")));
    }
    return jobs;
  }

  String makeSalaryToK(double salary) {
    String money = "";
    if (salary > 1000) {
      if (salary > 100000000) {
        salary = salary/100000000;
        money = salary.toInt().toString() + "M";
      } else {
        salary = salary/1000;
        money = salary.toInt().toString() + "K";
      }
    } else {
      money = salary.toInt().toString();
    }
    return "\$" + money;
  }

  List<Widget> getRecentJobs() {
    List<Widget> recentJobCards = [];
    List<Job> jobs = findJobs();
    for (Job job in jobs) {
      recentJobCards.add(getJobCard(job));
    }
    return recentJobCards;
  }

  Widget getJobCard(Job job) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 20, bottom: 30, top: 30),
      height: 150,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          new BoxShadow(
            color: Colors.grey,
            blurRadius: 20.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: job.companyLogo,
              ),
              Text(
                job.jobTitle,
                style: jobCardTitileStyleBlue,
              )
            ],
          ),
          Text(job.companyName + " - " + job.timeRequirement, style: jobCardTitileStyleBlack),
          Text(job.location),
          Text(makeSalaryToK(job.salary), style: salaryStyle)
        ],
      ),
    );
  }
}