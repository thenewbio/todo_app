import 'package:flutter/material.dart';

class Settings extends StatefulWidget {

  static const routeName = "/settings";
  const Settings({ Key key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new),
        onPressed: () => Navigator.of(context).pushReplacementNamed('/')
        ),
        automaticallyImplyLeading: true,
        title: Text("Settings"),
      ),
      // drawer: AppDrawer(),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Container(
            child: Text('General',style: TextStyle(fontSize: 20,)),
          ),
            buildList('Remove Ads', 'One payment to remove ads forever', null),
            buildListTile('Status bar ', 'Disabled', false),
        Container(child: Text('Notifications',style: TextStyle(fontSize:20)),),
         buildListTile('Sound ', 'Default ringtone{pebble}', false),
          buildListTile('Voice', 'Uses system default speech synthesizer(TTS)', true),
          buildListTile('Vibration ', 'Disabled', false),
           buildList('Task notification', 'On time', null),
           Container(
             child: Text('About',style: TextStyle(fontSize:20),),
           ),
           buildList('Send feedback', 'Auto', null),
        ],
      ),
    );
  }
Widget buildListTile(String title, String subtitle, bool checkbox){
   return ListTile(
     title: Text(title),
     subtitle: Text(subtitle),
     trailing: Checkbox(value: true, onChanged: (value){value = false;}),
   );

}
  
Widget buildList(String title, String subtitle, Function ontap){
   return ListTile(
     title: Text(title),
     subtitle: Text(subtitle),
     onTap: () => print('fine'),
   );

}
 Widget buildSingleCheckBox(CheckBoxState checkbox) =>  CheckboxListTile(
            activeColor: Colors.red,
          value: checkbox.value,
          title: Text("Messages",style: TextStyle(fontSize: 20),),
         onChanged: (value){
           setState(() {
             checkbox.value = value;
           });
         });
  Widget buildGroupCheckBox(CheckBoxState checkbox) =>  CheckboxListTile(
            activeColor: Colors.red,
          value: checkbox.value,
          title: Text(checkbox.title,style: TextStyle(fontSize: 20),),
         onChanged: toggleGroupCheckedbox,
         );
      void toggleGroupCheckedbox(bool value){
        if(value == null) return;

        setState(() {
           });
      }
}

class CheckBoxState {
  final String title;
  bool value;
  CheckBoxState({
    @required this.title,
    this.value = false
  });
}