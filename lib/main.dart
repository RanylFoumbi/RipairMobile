import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui/components/Home/home.dart';
import 'ui/globals/splashScreen.dart';
//import 'package:animated_splash/animated_splash.dart';

void main() {
  /*To block Screen rotation for the whole app*/
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(new Main());
  });
}

class Main extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ripair',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Home(),
      },
    );
  }
}
