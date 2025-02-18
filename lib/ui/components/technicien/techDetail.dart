import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oneHelp/apiCall/comment.dart';
import 'package:oneHelp/apiCall/user.dart';
import 'package:oneHelp/ui/components/auth/login.dart';
import 'package:oneHelp/ui/globals/toast.dart';
import 'package:oneHelp/utilities/auth.dart';
import 'package:oneHelp/utilities/connectivity.dart';
import 'package:oneHelp/utilities/constant/colors.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oneHelp/ui/globals/stringExtension.dart';
import 'package:timeago/timeago.dart' as timeago;

class TechnicianDetails extends StatefulWidget {
  TechnicianDetails({
    Key key,
    this.id,
    this.name,
    this.lastname,
    this.date,
    this.professions,
    this.techPic,
    this.town,
    this.quarter,
    this.description,
    this.phone,
    this.languages,
    this.numberOfStars,
    this.nbrOfCall,
    this.nbrOfComment,
  }) : super(key: key);

  final String id;
  final String name;
  final String lastname;
  final String quarter;
  final String town;
  final String description;
  final String date;
  final String techPic;
  final List phone;
  final List professions;
  final List languages;
  final String numberOfStars;
  final int nbrOfCall;
  final int nbrOfComment;

  _TechnicianDetailsState createState() => _TechnicianDetailsState();
}

class _TechnicianDetailsState extends State<TechnicianDetails>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 500);
  TextEditingController _commentController = new TextEditingController();
  Future commentList;
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    _controller = AnimationController(vsync: this, duration: _duration);
    setState(() {
      commentList = CommentApi().fetchComment(widget.id);
    });
  }

  Future _postComment(comment) async {
    setState(() {
      _isPosting = true;
    });
    try {
      await CommentApi().postComment(comment);
      await UserApi().commentCounter(widget.id);
      setState(() {
        commentList = CommentApi().fetchComment(widget.id);
      });
      setState(() {
        _isPosting = false;
        _commentController.text = '';
      });
    } catch (err) {
      _controller = AnimationController(vsync: this, duration: _duration);
      setState(() {
        commentList = CommentApi().fetchComment(widget.id);
      });
      print(err);
      setState(() {
        _isPosting = false;
      });
      toast("Une erreur est survenue, veuillez reessayer svp!",
          Toast.LENGTH_LONG, ToastGravity.BOTTOM, Colors.red, Colors.white, 15);
    }
  }

  void _validateCommentField() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_commentController.text == '') {
      toast("Remplissez le champs svp!", Toast.LENGTH_LONG, ToastGravity.BOTTOM,
          Colors.red, Colors.white, 15);
    } else {
      if (await isLogged) {
        var comment = {
          "content": _commentController.text,
          "authorId": jsonDecode(prefs.getString("user"))["email"],
          "authorName": jsonDecode(prefs.getString("user"))["name"],
          "technicianId": widget.id
        };
        _postComment(comment);
      } else {
        loginDialog(context);
      }
    }
  }

  Future _saveCall(callInfo) async {
    try {
      await UserApi().saveCall(callInfo);
      await UserApi().callCounter(widget.id);
    } catch (err) {
      print(err);
      toast("Une erreur est survenue!", Toast.LENGTH_LONG, ToastGravity.BOTTOM,
          Colors.red, Colors.white, 15);
    }
  }

  void _initiateCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = jsonDecode(prefs.getString("user"));
    print(user);
    if (await checkInternet() == true) {
      setState(() {
        FlutterPhoneState.startPhoneCall(widget.phone[0]);
        FlutterPhoneState.activeCalls;
      });
      var callInfo = {
        "clientId": user['_id'],
        "techId": widget.id,
        "clientName": user['name'] != null ? user['name'] : user['email'],
        "clientPhone": user['phone'][0] != null ? user['phone'][0] : "---",
        "clientPic": "---",
        "techName": widget.name + " " + widget.lastname,
        "techPhone": widget.phone[0],
        "techProf": widget.professions
      };
      Timer.periodic(new Duration(seconds: 1), (timer) {
        // print("Ranolfffffffff1");
        print(FlutterPhoneState.activeCalls);
        for (final call in FlutterPhoneState.activeCalls) {
          for (final event in call.events) {
            // print("Ranolfffffffff2");
            // print(event.status);
            print(event.status == PhoneCallStatus.connected);
            if (event.status == PhoneCallStatus.connected ||
                event.status == PhoneCallStatus.dialing) {
              _saveCall(callInfo);
              timer.cancel();
            }
          }
        }
        // print("Ranolfffffffff3");
      });
    } else {
      toast("Verifiez votre connection internet et reessayé!",
          Toast.LENGTH_LONG, ToastGravity.BOTTOM, Colors.red, Colors.white, 15);
    }
  }

  Future _rateTech(techId, star) async {
    try {
      await UserApi().rateTech(techId, star);
    } catch (err) {
      print(err);
      setState(() {
        _isPosting = false;
      });
      toast("Une erreur est survenue, veuillez reessayer svp!",
          Toast.LENGTH_LONG, ToastGravity.BOTTOM, Colors.red, Colors.white, 15);
    }
  }

  void _sendMail() async {
    // Android and iOS
    var uri =
        'mailto:ranylfoumbi@gmail.com?subject=Plainte contre le ${widget.professions[0]},'
        ' ${widget.lastname} '
        ' ${widget.name}s&body=Hello Ripair Assistance';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Future loginDialog(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Login();
        });
  }

  void _showRatingDialog() {
    // We use the built in showDialog function to show our Rating Dialog
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return RatingDialog(
            icon: Icon(
              FontAwesome5.user_circle,
              size: 40,
              color: BLACK_DEGRADE_COLOR,
            ), // set your own image/icon widget
            title: "Appréciez",
            description:
                "Appréciez à sa juste valeur le travail effectué par ${widget.name}",
            submitButton: "Voter",
            alternativeButton: "Contactez nous.",
            positiveComment: "Travail impeccable!",
            negativeComment: "Travail insatisfaisant.!",
            accentColor: YELLOW_COLOR,
            onSubmitPressed: (int rating) {
              print("onSubmitPressed: rating = $rating");
              _rateTech(widget.id, rating);
            },
            onAlternativePressed: () {
              print("onAlternativePressed: do something");
              _sendMail();
            },
          );
        });
  }

  Widget _displayMulti(listItems) {
    var list = Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[]);
    for (var item in listItems) {
      list.children.add(Text(item,
          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        body: SizedBox.expand(
      child: Stack(
        children: <Widget>[
          SizedBox(
            child: Container(
              color: WHITE_COLOR,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 400,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(10),
                      //     border: Border.all(color: BLACK_DEGRADE_COLOR.withOpacity(0.2))
                      // ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 70,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25)),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25)),
                                    child: Image.network(widget.techPic,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 350,
                                        fit: BoxFit.cover),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.only(top: 45, left: 15),
                                    icon: Icon(Icons.arrow_back_ios,
                                        color: WHITE_COLOR),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    iconSize: 30.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 295,
                            left: 20,
                            right: 20,
                            bottom: 0,
                            child: Card(
                              // elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Container(
                                height: 150,
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          widget.name + " " + widget.lastname,
                                          style: TextStyle(fontSize: 20),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                    Divider(
                                      height: 1,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Interaction(widget.nbrOfCall.toString(),
                                            'Appels reçus'),
                                        Column(
                                          children: <Widget>[
                                            SmoothStarRating(
                                              rating: double.parse(
                                                  widget.numberOfStars),
                                              isReadOnly: true,
                                              size: 13.5,
                                              filledIconData: Icons.star,
                                              halfFilledIconData:
                                                  Icons.star_half,
                                              defaultIconData:
                                                  Icons.star_border,
                                              color: YELLOW_COLOR,
                                              borderColor: BLACK_DEGRADE_COLOR,
                                              starCount: 5,
                                              allowHalfRating: true,
                                              spacing: 2.0,
                                            ),
                                            Text(
                                              widget.numberOfStars
                                                          .toString()
                                                          .length >=
                                                      4
                                                  ? widget.numberOfStars
                                                      .toString()
                                                      .substring(0, 3)
                                                  : widget.numberOfStars
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                decoration: TextDecoration.none,
                                                color: Colors.black,
                                                fontFamily: 'EbrimaBold',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Interaction(
                                            widget.nbrOfComment.toString(),
                                            'Commentaires'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 17, top: 15),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: BLUE_COLOR,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                          child: Text(
                                        widget.town.capitalize() +
                                            " , " +
                                            widget.quarter.capitalize(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ))
                                    ],
                                  ),
                                ),
                                Spacer(
                                  flex: 2,
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.language,
                                          color: BLUE_COLOR,
                                          size: 20,
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child:
                                              _displayMulti(widget.languages),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 60,
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        left:
                                            MediaQuery.of(context).size.width /
                                                3.5),
                                    decoration: BoxDecoration(
                                      color: BLUE_COLOR,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 3),
                                            blurRadius: 5,
                                            color: Colors.grey)
                                      ],
                                    ),
                                    child: Icon(
                                      FontAwesome.phone,
                                      color: WHITE_COLOR,
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                  onTap: () async {
                                    if (await isLogged)
                                      _initiateCall();
                                    else
                                      loginDialog(context);
                                  },
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.work,
                                          color: BLUE_COLOR,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child:
                                              _displayMulti(widget.professions),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: BLUE_COLOR,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4.2,
                                            height: 23,
                                            decoration: BoxDecoration(
                                              color: YELLOW_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(0, 3),
                                                    blurRadius: 5,
                                                    color: Colors.grey)
                                              ],
                                            ),
                                            child: Text(
                                              "Appréciez",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          onTap: () async {
                                            if (await isLogged)
                                              _showRatingDialog();
                                            else
                                              loginDialog(context);
                                          },
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 23,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "A propos",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 200,
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // border: Border.all(color: BLACK_DEGRADE_COLOR.withOpacity(0.2))
                                ),
                                width: MediaQuery.of(context).size.width / 1.1,
                                padding: EdgeInsets.all(10),
                                child: new Scrollbar(
                                  child: Column(
                                    children: [
                                      Text(
                                        "        " + widget.description,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                        textAlign: TextAlign.justify,
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.15,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 3),
                                      blurRadius: 5,
                                      color: Colors.grey)
                                ],
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.face), onPressed: () {}),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: "Laissez un avis...",
                                          hintStyle: TextStyle(
                                              fontStyle: FontStyle.italic),
                                          border: InputBorder.none),
                                      controller: _commentController,
                                      onChanged: (value) {
                                        print(_commentController.text);
                                      },
                                    ),
                                  ),
                                  _isPosting
                                      ? SpinKitRipple(
                                          color: BLUE_COLOR,
                                          size: 30.0,
                                          controller: AnimationController(
                                              vsync: this,
                                              duration: const Duration(
                                                  milliseconds: 1200)),
                                        )
                                      : !(_commentController.text.length == 0)
                                          ? IconButton(
                                              icon: Icon(
                                                FontAwesome.send,
                                                color: BLUE_COLOR,
                                                size: 18,
                                              ),
                                              onPressed: () {
                                                _validateCommentField();
                                              },
                                            )
                                          : Text(""),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox.expand(
            child: _buildCommentList(),
          )
        ],
      ),
    ));
  }

  DraggableScrollableSheet _buildCommentList() {
    return DraggableScrollableSheet(
      initialChildSize: 0.03,
      minChildSize: 0.03,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: Container(
                  decoration: BoxDecoration(
                    color: WHITE_COLOR,
                  ),
                  child: FutureBuilder(
                    future: commentList,
                    builder: (context, commentList) {
                      if (commentList.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
//                                        child: CircularProgressIndicator()
                            );
                      } else if (commentList.hasError) {
                        toast("Une erreur s'est produite.", Toast.LENGTH_SHORT,
                            ToastGravity.BOTTOM, Colors.red, Colors.white, 14);
                        return CustomScrollView(
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, idx) => Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(35),
                                  child: Text("une erreure s'est produite."),
                                ),
                                childCount: 1,
                              ),
                            )
                          ],
                        );
                      }
                      return CustomScrollView(
                        controller: scrollController,
                        slivers: <Widget>[
                          SliverAppBar(
                            title: Column(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 70,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      color: WHITE_COLOR,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                Divider(
                                  color: BLUE_COLOR,
                                  height: 5,
                                ),
                                Text(commentList.data.length.toString() +
                                    "  " +
                                    "Commentaires"),
                              ],
                            ),
                            backgroundColor: BLUE_COLOR,
                            automaticallyImplyLeading: false,
                            primary: false,
                            pinned: true,
                          ),
                          (commentList.data.length == 0 ||
                                  commentList.data == null)
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, idx) => Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(35),
                                      child: Text("Aucun commentaire."),
                                    ),
                                    childCount: 1,
                                  ),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, idx) => Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 40,
                                            height: 40,
                                            margin: EdgeInsets.only(left: 7),
                                            child: Icon(
                                              Icons.person,
                                              size: 30,
                                              color: WHITE_COLOR,
                                            ),
                                            decoration: BoxDecoration(
                                                color: BLUE_COLOR,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: WHITE_COLOR,
                                                    width: 0.5)),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .8),
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xfff9f9f9),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      topRight:
                                                          Radius.circular(5),
                                                      bottomLeft:
                                                          Radius.circular(5),
                                                      bottomRight:
                                                          Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                          commentList.data[idx]
                                                              ['authorName'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                        commentList.data[idx]
                                                            ['content'],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .body1
                                                            .apply(
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                timeago.format(
                                                    DateTime.parse(commentList
                                                        .data[idx]['date']),
                                                    locale: 'fr'),
                                                style: TextStyle(
                                                    color: BLACK_DEGRADE_COLOR,
                                                    fontSize: 10),
                                                textAlign: TextAlign.right,
                                              ),
                                              Divider(
                                                  height: 1,
                                                  color: BLACK_DEGRADE_COLOR)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    childCount: commentList.data.length,
                                  ),
                                )
                        ],
                      );
                    },
                  ),
                ));
          },
        );
      },
    );
  }
}

class Interaction extends StatelessWidget {
  final String quantity;
  final String label;
  const Interaction(this.quantity, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            quantity,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
              color: Colors.black,
              fontFamily: 'EbrimaBold',
            ),
          ),
          Text(label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
                color: Colors.black,
                fontFamily: 'Ebrima',
              ))
        ],
      ),
    );
  }
}
