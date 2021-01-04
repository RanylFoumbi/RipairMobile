import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oneHelp/ui/components/auth/signup.dart';
import 'package:oneHelp/utilities/constant/colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../apiCall/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;
  bool _isHidden = true;
  bool _isPhone = false;

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
      return "Email incorrecte";
    else
      return null;
  }

  String _validatePhone(String value) {
    if (value.length < 9)
      return "Numéro incorrecte; Min 6 caractères!";
    else
      return null;
  }

  bool _isValidForm() {
    if (_isPhone) {
      return passwordController.text.length > 0 &&
          _validatePhone(phoneController.text) == null;
    } else {
      return passwordController.text.length > 0 &&
          _validateEmail(emailController.text) == null;
    }
  }

  // Redirect after login
  _redirect() {
    Navigator.of(context).pop();
  }

  // Save persistant data on disk
  savePreference(String accessToken, String userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", accessToken);
    await prefs.setString("user", userData);
  }

  // Called when user submit the form
  void _handleSubmit() async {
    setState(() {
      _loading = true;
    });
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;

    if (_isPhone) {
      UserApi().loginPhone(phone, password).then((response) {
        if (response.statusCode == 200) {
          final responseJson = json.decode(response.body);
          String accessToken = responseJson["token"];
          String user = jsonEncode(responseJson["user"]);
          //   // Store user data and token locally
          savePreference(accessToken, user);
          _redirect();
        } else if (response.statusCode == 401) {
          _showDialog("Téléphone ou Mot de passe incorect.");
        }
        setState(() {
          _loading = false;
        });
        // _showDialog(json.decode(response.body)["msg"]);
      }).catchError((onError) {
        setState(() {
          _loading = false;
        });
        _showDialog("Verifiez votre connexion internet. Puis réessayer.");
      });
    } else {
      UserApi().loginEmail(email, password).then((response) {
        if (response.statusCode == 200) {
          final responseJson = json.decode(response.body);
          String accessToken = responseJson["token"];
          String user = jsonEncode(responseJson["user"]);
          //   // Store user data and token locally
          savePreference(accessToken, user);
          _redirect();
        } else if (response.statusCode == 401) {
          _showDialog("Email ou Mot de passe incorect.");
        }
        setState(() {
          _loading = false;
        });
        // _showDialog(json.decode(response.body)["msg"]);
      }).catchError((onError) {
        setState(() {
          _loading = false;
        });
        _showDialog("Verifiez votre connexion internet. Puis réessayer.");
      });
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Auth Error"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Fermer"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future signupDialog(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Signup();
        });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.white,
      title: Container(
        height: 80.0,
        width: 80.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/ripair_logo.png'),
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
          borderSide: BorderSide(color: Color(0xffdcdcdc))),
      contentPadding: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 15),
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
                  )),
                  child: TextFormField(
                      controller: _isPhone ? phoneController : emailController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: _isPhone ? "Téléphone" : "Email",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14),
                          prefixIcon: _isPhone
                              ? Icon(
                                  Icons.phone,
                                  color: BLUE_COLOR,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  color: BLUE_COLOR,
                                )),
                      validator: _isPhone ? _validatePhone : _validateEmail),
                ),

                // PASSWORD FIELD
                Container(
                  padding: EdgeInsets.all(6),
                  margin: EdgeInsets.only(left: 12, right: 12),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[200]))),
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
                  color: !_loading ? BLUE_COLOR : Colors.grey,
                  onPressed: () {
                    _formKey.currentState.validate();
                    if (_isValidForm()) {
                      _loading ? null : _handleSubmit();
                    }
                  },
                  child: !_loading
                      ? Text(
                          "Se connecter",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )
                      : SpinKitWave(
                          color: WHITE_COLOR,
                          size: 20,
                        ),
                ),

                DialogButton(
                    color: Colors.grey,
                    onPressed: () {
                      if (!_loading) {
                        setState(() {
                          _isPhone = !_isPhone;
                        });
                      } else {
                        setState(() {
                          _isPhone = _isPhone;
                        });
                      }
                    },
                    child: Text(
                      _isPhone ? "Avec Email" : "Avec Téléphone",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    )),

                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    signupDialog(context);
                  },
                  child: Text(
                    "Je n'ai pas de compte? Créer un compte.",
                    style: TextStyle(color: BLUE_COLOR, fontSize: 10),
                  ),
                )
              ],
            )),
      ],
    );
  }
}
