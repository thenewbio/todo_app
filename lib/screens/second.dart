// import 'package:flutter/material.dart';
// class SecondPage extends StatelessWidget {
//   const SecondPage({ Key key, @required this.payload }) : super(key: key);

//   final String payload;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Second page"),
//         centerTitle: true,
//       ),
//       body: Container(
//         padding: EdgeInsets.all(32),
//         alignment: Alignment.center,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//          children: [
//            Text(
//              payload ?? '',
//              style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
//              textAlign: TextAlign.center,
//            ),
//            const SizedBox(height: 24),
//            Text('PAYLOAD',
//            style: TextStyle(fontSize: 35),)
//          ],
//         ),
//       )
//     );
//   }
// }