import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'constant/colors.dart';

// Check connection availability 
Future<bool> checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return Future<bool>.value(true);
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return Future<bool>.value(true);
  }
  return Future<bool>.value(false);
}


//verifyImageSource(image){
//
//  if(image.runtimeType == String) return true;
//  else return false;
//}
//
//photoView(context,image){
//
//  double width = MediaQuery.of(context).size.width;
//  double height = MediaQuery.of(context).size.height;
//
//  return showDialog(
//    context: context,
//    barrierDismissible: false,
//    builder: (BuildContext context) {
//      return Scaffold(
//        body: Container(
//          height: height,
//          width: width,
//          decoration: BoxDecoration(
//            color: Colors.black,
//          ),
//          child: PhotoView(
//            imageProvider: NetworkImage(image),
//            loadingChild: SpinKitWave(color: BLUE_COLOR,size: 50),
//          ),
//        ),
//        backgroundColor: Colors.black,
//      );
//    },
//  );
//}

