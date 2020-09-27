//import 'package:country_code_picker/country_code_picker.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:oneHelp/ui/components/Home/home.dart';
//import 'package:oneHelp/providers/user.dart';
//import 'package:oneHelp/utilities/constant/colors.dart';
//import '../../../utilities/connectivity.dart';
//import '../../globals/toast.dart';
//
//class LoginPage extends StatefulWidget {
//
//  LoginPage({Key key}) : super(key: key);
//  @override
//  _LoginPageState createState() => _LoginPageState();
//}
//
//class _LoginPageState extends State<LoginPage> {
//
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//  final _numController = TextEditingController();
//
//  String smsCode;
//  String verificationId;
//  String phoneNumber;
//  String inputMsg;
//  bool _loading;
//
//  @override
//  void initState() {
//    super.initState();
//    _numController.text = "+237";
//    _loading = false;
//
//  }
//
//
//  _redirect(user){
//
//  }
//
//  Future<bool> loginUser(String phone, BuildContext context)async{
//    FirebaseAuth _auth = FirebaseAuth.instance;
//
//    try{
//        setState(() {
//          _loading = true;
//        });
//          await _auth.verifyPhoneNumber(
//                phoneNumber: phone,
//                timeout:  const Duration(seconds: 10),
//                verificationCompleted: (AuthCredential credential) async{
//                AuthResult result = await _auth.signInWithCredential(credential);
//
//                FirebaseUser user = result.user;
//
//                if(user != null){
//
//                }
//
//                // This callback would gets called when verification is done automatically
//              },
//              verificationFailed: (AuthException exception) {
//                toast("Le format du numero est incorrect.", Toast.LENGTH_LONG, ToastGravity.BOTTOM, Colors.red, Colors.white, 16);
//                print("${exception.message}");
//              },
//              codeSent: (String verId, [int forceCodeResend]) {
//                this.verificationId = verId;
//                print("Sign in");
//                setState(() {
//                  _loading = true;
//                });
//                smsCodeDialog(context).then((value) {
//                  print("Signed in");
////                  Navigator.of(context).pushReplacementNamed("/home");
//                });
//                setState(() {
//                  _loading = false;
//                });
//
//              },
//              codeAutoRetrievalTimeout: (String verId) {
//                this.verificationId = verId;
//              }
//          );
//
//      }catch(err){
//        setState(() {
//          _loading = false;
//        });
//        toast("Erreur, Veuillez reésayer.", Toast.LENGTH_LONG, ToastGravity.BOTTOM, Colors.red, Colors.white, 16);
//        print("Error");
//        print(err);
//      }
//
//  }
//
//
//  Future<bool> smsCodeDialog(BuildContext context) {
//    return showDialog(
//      context: context,
//      barrierDismissible: false,
//      builder: (BuildContext context) {
//        return new AlertDialog(
//          title: Text("Entrer le code sms reçu."),
//          content: TextField(
//            onChanged: (value){
//              this.smsCode = value;
//            },
//          ),
//          contentPadding: EdgeInsets.all(10.0),
//          actions: <Widget>[
//            new FlatButton(
//              child: Text("Valider"),
//              onPressed: (){
//                FirebaseAuth.instance.currentUser().then((user) {
//                   signIn().then((user) {
//
//                        }).catchError((err) {
//                           setState(() {
//                             _loading = false;
//                           });
//                          Navigator.of(context).pop();
//                          print(err);
//                        });
//                     if(user != null){
////                       Navigator.of(context).pop();
////                       Navigator.push(
////                         context,
////                         MaterialPageRoute(builder: (context) => Home()),
////                       );
//                     }else{
//                       Navigator.of(context).pop();
//                       setState(() {
//                         _loading = false;
//                       });
//                     }
//                });
//              },
//              )
//          ],
//        );
//      }
//      );
//  }
//
//   Future<FirebaseUser> signIn() async {
//    final AuthCredential credential = PhoneAuthProvider.getCredential(
//      verificationId: this.verificationId,
//      smsCode: this.smsCode,
//    );
//    final AuthResult _auth = await FirebaseAuth.instance.signInWithCredential(credential);
//    return _auth.user;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    double width = MediaQuery.of(context).size.width;
//
//    return WillPopScope(
//        child: Scaffold(
//          resizeToAvoidBottomPadding: false,
//          body: Container(
//              color: WHITE_COLOR,
//              padding: EdgeInsets.only(top: 100.0, right: 25.0, left: 25.0, bottom: 20.0),
//              child: Form(
//                key: _formKey,
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Container(
//                      alignment: Alignment.center,
//                      child: Image.asset("assets/images/ripair_logo.png", height: 110, width: 110),
//                    ),
//                    const SizedBox(height: 10.0),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                      CountryCodePicker(
//                        onChanged: (val) {
//                          _numController.text = val.toString();
//                          },
//                        initialSelection: 'CM',
//                        favorite: ['+237','FR'],
//                        showCountryOnly: false,
//                        alignLeft: false,
//                      ),
//                    ],
//                    ),
//                    const SizedBox(height: 16.0),
//                    TextFormField(
//                      controller: _numController,
//                      keyboardType: TextInputType.phone,
//                      decoration: InputDecoration(
//                        filled: true,
//                        fillColor: WHITE_COLOR,
//                        hintText: "Numéro de tel",
//                        hintStyle: TextStyle(
//                          fontSize: 16.0,
//                        ),
//                        enabledBorder: OutlineInputBorder(
//                            borderSide: const BorderSide(color: Color(0xffdcdcdc)),
//                            borderRadius: BorderRadius.circular(10.0)),
//                        border: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(10.0),
//                        ),
//                        prefixIcon: Icon(
//                          Icons.phone,
//                          color: Color(0xfff4f4f4),
//                        ),
//                      ),
//                      validator: (String value) {
//                        if(value.isEmpty) {
//                          inputMsg = "Entrer un numéro de téléphone";
//                        }
//                        else if(value.length <= 5) {
//                          inputMsg = "Entrer un numéro de téléphone valide";
//                        }
//                        return inputMsg;
//                      },
//                    ),
//                    const SizedBox(height: 17.0),
//                    Container(
//                        width: MediaQuery.of(context).size.width,
//                        alignment: _loading ? Alignment.center : null,
//                        height: 50,
//                        child: Container(
//                                width: width/1.2,
//                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(10),
//                                  color: BLUE_COLOR,
//                                ),
//                                child:FloatingActionButton.extended(
//                                    backgroundColor: BLUE_COLOR,
//                                    heroTag: "codephone",
//                                    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: BLUE_COLOR)),
//                                    label: _loading ? CupertinoActivityIndicator() : Text("SE CONNECTER",style: TextStyle(color: Colors.white,fontFamily: "Raleway",fontWeight: FontWeight.bold,fontSize: 17),
//                                    ),
//                                  onPressed:() async {
//                                              setState(() {
//                                                _loading = true;
//                                              });
//                                              if (await checkInternet() == true) {
//                                                if(_numController.text[0] == '+'){
//                                                  _formKey.currentState.validate();
//                                                 var user = await UserProvider().verifyIfUserExist(_numController.text);
//                                                 if(user == null){
//                                                         loginUser(_numController.text, context).then((val) {
//                                                           setState(() {
//                                                             _loading = false;
//                                                           });
//                                                         })
//                                                         .catchError((err) {
//                                                           setState(() {
//                                                             _loading = false;
//                                                           });
//                                                           toast("Numéro invalide", Toast.LENGTH_SHORT, ToastGravity.BOTTOM, Colors.red, Colors.white, 16);
//
//                                                          print(err);
//                                                     });
//                                                 }else{
//
//                                                   // Api call to create a new user
//                                                   setState(() {
//                                                     _loading = false;
//                                                   });
//                                                   print("already have and acount");
//                                                 }
//
//                                                }else{
//                                                  setState(() {
//                                                    _loading = false;
//                                                  });
//                                                   toast("Le format du numéro est incorrect", Toast.LENGTH_SHORT, ToastGravity.BOTTOM, Colors.orange[700], Colors.white, 16);
//
//                                                }
//
//                                              }
//                                              else {
//                                                setState(() {
//                                                  _loading = false;
//                                                });
//                                                toast("Veuillez vérifier votre connexion internet, puis réessayez", Toast.LENGTH_SHORT, ToastGravity.BOTTOM, Colors.red, Colors.white, 16);
//
//                                              }
//                                            }
//                                )
//                            )
//                    ),
//                    const SizedBox(height: 27.0),
//                    Container(
//                      alignment: Alignment.center,
//                      child: Text("Entrez votre numéro de téléphone. Vous recevrez un code de confirmation par sms.",
//                          style: TextStyle(
//                            fontFamily: "Raleway"
//                          ),
//                          textAlign: TextAlign.center,
//                      ),
//                    )
//                  ],
//                ),
//              )),
//        ),
//        onWillPop: (){
//          Navigator.of(context).pop();
//        }
//    );
//  }
//}
