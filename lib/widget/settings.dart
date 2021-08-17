import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  static const routeName = "/settings";
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/')),
        automaticallyImplyLeading: true,
        title: Text("Settings"),
      ),
      // drawer: AppDrawer(),
      body: SingleChildScrollView(
         padding: EdgeInsets.all(16),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text('General',
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
        //     Consumer<ThemeNotifier>(
        //   builder:(contex , notifier, child) => SwitchListTile(
        //       title: Text("Dark Mode"),
        //       onChanged: (val) {
        //         notifier.toggleTheme();
        //       },
        //       value: notifier.darkTheme,
        //       ),
        // ),
            
            buildTile(
              title: 'Status bar ',
              subtitle: 'Disabled', 
              onTap: null),
            Container(
              child: Text('Notifications', style: TextStyle(fontSize: 20)),
            ),
            buildTile(
             title: 'Sound ', 
              subtitle:'Phone Default notification tone', 
              onTap: null),
          
            Container(
              child: Column(
                children: [
                  Text(
                    'About',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            buildList('Send feedback', Icon(Icons.feedback),
            () => openEmail(
                toEmail: 'okamainnocent2020@gmail.com',
                subject: "",
                body: ''
              ) ),
               buildList('About Us', Icon(Icons.person),
            () => openEmail(
                toEmail: 'okamainnocent2020@gmail.com',
                subject: "",
                body: ''
              ) ),
               buildList('Version', Icon(Icons.approval_rounded),
            () => openEmail(
                toEmail: 'okamainnocent2020@gmail.com',
                subject: "",
                body: ''
              ) ),
               buildList('Privacy Policy', Icon(Icons.privacy_tip),
            () => openEmail(
                toEmail: 'okamainnocent2020@gmail.com',
                subject: "",
                body: ''
              ) ),
              
          ],
        ),
      ),
    );
  }


Widget buildTile(
  {@required String title, @required String subtitle, @required VoidCallback onTap}) {
  return ListTile(
    title: Text(title),
    subtitle: Text(subtitle),
    onTap: onTap,
    trailing: Checkbox(value: true, onChanged: (value){value = false;}),

  );
}

  Widget buildList(String title, Icon icon, VoidCallback ontap) {
    return TextButton.icon(onPressed: ontap, icon: icon, label: Text(title));
  }
  // ignore: unused_element
  static Future openLink({@required String url}) => _launch(url);

  static _launch(String url) async{
    if(await canLaunch(url)) {
      await launch(url);
    }
  }
  static openEmail(
    {
    @required  String toEmail, 
     @required  String subject, 
     @required  String body,
     }) async{
       final url  = 'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';
       await _launch(url);
     }
}
