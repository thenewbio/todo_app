// import 'package:flutter/material.dart';
// import 'package:mytodo/api/notification_api.dart';
// import 'package:mytodo/screens/second.dart';
// // import 'package:mytodo/widgets/widgetcompress/button_widget.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({ Key key }) : super(key: key);

//   @override
//   _MainPageState createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   @override
//   void initState() {
//   NotificationApi.init(initScheduled: true);
//   listenNotifications();

//   // NotificationApi.showScheduledNotification(
//   //            title: "Sara Abs",
//   //            body: "Hey I sent you a notification from manager innocent okwuchukwu",
//   //            payload: "sara.abs",
//   //            scheduleDate: DateTime.now().add(Duration(seconds: 12))
//   //          );
//     super.initState();
//   }

//  void listenNotifications() {
//    NotificationApi.onNotifications.stream.listen(onClickedNotification);
//  }

//  void onClickedNotification(String payload) => 
//  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecondPage(payload: payload,)));
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.amber.shade300,
//       body: Container(
//       padding: EdgeInsets.all(32),
//       child: Column(
//         children: [
//           Spacer(),
//           FlutterLogo(size: 160,),
//           Text("Local Notifications",
//           style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
//           ),
//        const SizedBox(height: 20,),
//          buildButton(
//            "Simple Notification",
//            Icons.notifications, 
//            () => NotificationApi.showNotification(
//              title: "Sara Abs",
//              body: "Hey I sent you a notification",
//              payload: "sara.abs"
//            )),
//       const SizedBox(height: 20,),
//          buildButton(
//            "Scheduled Notification",
//            Icons.notifications_active, 
//            () {NotificationApi.showScheduledNotification(
//              title: "Sara Abs",
//              body: "Hey I sent you a notification from manager innocent okwuchukwu",
//              payload: "sara.abs",
//              scheduleDate: DateTime.now().add(Duration(seconds: 12))
//            );
//            final snackBar = SnackBar(
//              content: Text("Schedule in 12 seconds!",
//              style: TextStyle(fontSize: 24),
//              ),
//              backgroundColor: Colors.blue, 
//            );
//            ScaffoldMessenger.of(context)
//            ..removeCurrentSnackBar()
//            ..showSnackBar(snackBar);
//            }
//           ),
//       const SizedBox(height: 20,),
//          buildButton(
//            "Remove Notification",
//            Icons.notifications, 
//            () => NotificationApi.showNotification(
//              title: "Sara Abs",
//              body: "Hey I sent you a notification",
//              payload: "sara.abs"
//            )),
//         ],
//       ),
//     ));
//   }
// }
// Widget buildButton(String title, IconData icon, VoidCallback ontap){
//   return ButtonWidgeted(text: title,icon: icon, onClicked: ontap);
// }

// class ButtonWidgeted extends StatelessWidget {
//   final String text;
//   final IconData icon;
//   final VoidCallback onClicked;

//   const ButtonWidgeted({
//     Key key,
//     @required this.text,
//     @required this.icon,
//     @required this.onClicked,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         minimumSize: Size.fromHeight(50),
//         shape: StadiumBorder(),
//       ),
//       child: FittedBox(
//         child: Text(
//           text,
//           style: TextStyle(fontSize: 20, color: Colors.white),
          
//         ),
//       ),
//       onPressed: onClicked,
//     );
//   }
// }