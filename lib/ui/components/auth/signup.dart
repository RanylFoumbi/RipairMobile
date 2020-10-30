
import 'package:flutter/material.dart';
import 'package:oneHelp/ui/components/auth/login.dart';
import 'package:oneHelp/utilities/constant/colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:oneHelp/apiCall/user.dart';
import 'dart:convert';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return "Adresse Email incorecte";
    else
      return null;
  }

  bool _isValidForm() {
    return passwordController.text.length > 0 &&
        _validateEmail(emailController.text) == null;
  }

  // Redirect after login
  _redirect() {
    Navigator.of(context).pop();
  }


  // Called when user submit the form
  void _handleSubmit() {
    setState(() { _loading = true; });
    String email = emailController.text;
    String password = passwordController.text;
   
  }

   Future loginDialog(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return Login();
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return  SimpleDialog(
        backgroundColor: Colors.white,
        title: Container(
          height: 70.0,
          width: 70.0,
           decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/icons/ripair_logo.png'),
              fit: BoxFit.contain,
            ),
            shape: BoxShape.circle,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new IconButton(
                   icon: new Icon(Icons.close),
                   onPressed: () => Navigator.of(context).pop(null),
                ),
              ],
            ),
        ),

        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xffdcdcdc)
          )
        ),
        contentPadding: EdgeInsets.only(left: 15,top: 5,right: 15,bottom: 15),
        children: <Widget>[

       Form(
          key: _formKey, 
          child: Column(
            children: <Widget>[

               Container(
                padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(left: 12, right: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]),
                    )
                ),
                child: TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Nom",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: BLUE_COLOR,
                    ),
                  ),
                  validator: (String value){
                    if(value.length == 0)
                     return "Nom requis";
                    else
                     return null;
                  }
                ),
              ),


              Container(
                padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(left: 12, right: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]),
                    )
                ),
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Téléphone",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: BLUE_COLOR,
                    ),
                  ),
                  validator: (String value){
                    if(value.length == 0)
                     return "Téléphone requis";
                    if(value.length < 8)
                     return "Téléphone , Min 8 caracteres"; 
                    else
                     return null;
                  }
                ),
              ),

              Container(
                padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(left: 12, right: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]),
                    )
                ),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                      Icons.email,
                      color: BLUE_COLOR,
                    ),
                  ),
                  validator: _validateEmail
                ),
              ),


               // PASSWORD FIELD
              Container(
                padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(left: 12, right: 12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[200]))
                ),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Mot de passe",
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.only(top: 14),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: BLUE_COLOR,
                    ),
                    suffixIcon: IconButton(
                      color: Colors.grey,
                      onPressed: _toggleVisibility,
                      icon: _isHidden
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                  validator: (String value) {
                    if (value.trim().length < 5) {
                      return "Password Error, Min 6 caracters";
                    } else {
                      return "";
                    }
                  },
                  obscureText: _isHidden,
                ),
              ),
              
              SizedBox(height: 15),
              DialogButton(
                color: BLUE_COLOR,
                  onPressed: () {
                     _formKey.currentState.validate();
                        if (_isValidForm()) {
                          // _handleSubmit();
                        }
                  },
                  child: Text(
                    "Créer un compte",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),

              FlatButton(
                 onPressed: (){
                  Navigator.of(context).pop(true);
                  loginDialog(context);
                }, 
                child: Text(
                    "Se connecter.",
                    style: TextStyle(color: BLUE_COLOR, fontSize: 10),
                  ),
              )  

            ],
          )
        ),
      ],
    );
  
  }
}