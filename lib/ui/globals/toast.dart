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

showAlertDialog(BuildContext context){
  AlertDialog alert = AlertDialog(
    content: new Row(
        children: [
           CircularProgressIndicator(),
           Container(
             margin: EdgeInsets.only(left: 15),
             child:Text("Loading" )
           ),
        ],),
  );
  showDialog(
    context:context,
    barrierDismissible: false,
    builder:(BuildContext context){
      return alert;
    },
  );
}
 