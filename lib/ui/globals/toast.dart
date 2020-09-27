import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


Future toast(String msg, Toast toastLength, ToastGravity gravity, Color background, Color textColor, double fontSize) async{

  return Fluttertoast.showToast(
        msg: msg,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: background,
        textColor: textColor,
        fontSize: fontSize
    );
}
 