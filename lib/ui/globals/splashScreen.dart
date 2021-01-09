import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';
import 'package:oneHelp/ui/components/bigContainer/bigContainer.dart';
import 'package:oneHelp/utilities/constant/colors.dart';
import 'package:oneHelp/utilities/permission/location.dart';

import 'onboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Location location = Location();
  final LocalStorage firstOpen = LocalStorage('firstOpen');
  final splashDelay = 5;
  String _location;

  @override
  void initState() {
    super.initState();
    location.serviceEnabled().then((value) => {
          if (value == false) {location.requestService()}
        });
    _loadWidget();
  }

  //method to get Location and save into variables
  void initPlatformState() async {
    await PermissionHandler().getUserLocation().then((first) => {
          if (first.runtimeType == Null)
            {
              setState(() {
                _location = null;
                PermissionHandler()
                    .locationStorage
                    .setItem("location", _location);
                print(_location);
                navigationPage();
              })
            }
          else
            {
              setState(() {
                _location = first.locality;
                print(_location);
                PermissionHandler()
                    .locationStorage
                    .setItem("location", _location);
                navigationPage();
              })
            }
        });
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, initPlatformState);
  }

  void navigationPage() {
    if (firstOpen.getItem('firstOpen').runtimeType == Null) {
      firstOpen.setItem('firstOpen', 'true');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => OnboardingScreen()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => BigContainer()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/icons/ripair_logo.png',
                        height: 200,
                        width: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SpinKitThreeBounce(
                          size: 25,
                          color: BLUE_COLOR,
                        ),
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
