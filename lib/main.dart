import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mytodo/models/ads_state.dart';
import 'package:mytodo/models/theme.dart';
import 'package:provider/provider.dart';
import '../screens/homescreen.dart';
import '../settings.dart';
import '../widgets/table.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  runApp(Provider.value(
    value: adState,
    builder: (context , child) => MyApp(),
     )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
         return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Todo pro',
            theme: notifier.darkTheme ? dark : light,
            home: MyHomePage(),
            routes: {
              Settings.routeName: (context) => Settings(),
              Tables.routeName: (context) => Table()
            });
        },
        
      ),
    );
  }
}
