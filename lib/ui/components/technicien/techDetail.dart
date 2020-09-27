import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oneHelp/apiCall/comment.dart';
import 'package:oneHelp/apiCall/user.dart';
import 'package:oneHelp/ui/globals/toast.dart';
import 'package:oneHelp/utilities/connectivity.dart';
import 'package:oneHelp/utilities/constant/colors.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

class TechnicianDetails extends StatefulWidget{

  TechnicianDetails({Key key,
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
  }):super(key : key);

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

class _TechnicianDetailsState extends State<TechnicianDetails> with TickerProviderStateMixin {

  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 500);
  TextEditingController _commentController = new TextEditingController();
  Future commentList;
  bool _isPosting = false;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    setState(() {
      commentList = CommentApi().fetchComment(widget.id);
    });

  }

  void _isLogged(){

  }

  Future _postComment(comment) async {
    setState(() {
      _isPosting = true;
    });
      try{
        await CommentApi().postComment(comment);
        await UserApi().commentCounter(widget.id);
        setState(() {
          commentList = CommentApi().fetchComment(widget.id);
        });
        setState(() {
          _isPosting = false;
          _commentController.text = '';
        });
      }catch(err){
        print(err);
        setState(() {
          _isPosting = false;
        });
        toast("Une erreur est survenue, veuillez reessayer svp!",Toast.LENGTH_LONG,ToastGravity.BOTTOM,Colors.red,Colors.white,15);
      }
  }

  void _validateCommentField(){
    if(_commentController.text == ''){
      toast("Remplissez le champs svp!",Toast.LENGTH_LONG,ToastGravity.BOTTOM,Colors.red,Colors.white,15);
    }else{
      var comment ={
        "content": _commentController.text,
        "authorId": "025698745",
        "technicianId": widget.id
      };
      _postComment(comment);
    }
  }

  Future _saveCall(callInfo)async{
   try{
      await UserApi().saveCall(callInfo);
      await UserApi().callCounter(widget.id);
    }catch(err){
      print(err);
      toast("Une erreur est survenue!",Toast.LENGTH_LONG,ToastGravity.BOTTOM,Colors.red,Colors.white,15);
    }
  }

  void _initiateCall() async{
    if(await checkInternet() == true){
          setState(() {
            FlutterPhoneState.startPhoneCall(widget.phone[0]);
            FlutterPhoneState.activeCalls;
          });
          var callInfo ={
            "clientId": "2152584",
            "techId": widget.id,
            "clientName": "Josua osih",
            "clientPhone": "6587925674",
            "clientPic": "",
            "techName": widget.name + " "+ widget.lastname,
            "techPhone": widget.phone[0],
            "techProf": widget.professions[0]
          };
          Timer.periodic(new Duration(seconds: 1), (timer) {

                print("5555555555555555555555555");
            for(final call in FlutterPhoneState.activeCalls){
              for (final event in call.events){
                print(event.status);
                print(event.status == PhoneCallStatus.connected);
                if(event.status == PhoneCallStatus.connected){
                  _saveCall(callInfo);
                  timer.cancel();
                }
              }
            }
          });
    }else{
      toast("Verifier votre connection internet et reeessayé!",Toast.LENGTH_LONG,ToastGravity.BOTTOM,Colors.red,Colors.white,15);
    }
  }

  Future _rateTech(techId, star) async {
    try{
      await UserApi().rateTech(techId, star);
    }catch(err){
      print(err);
      setState(() {
        _isPosting = false;
      });
      toast("Une erreur est survenue, veuillez reessayer svp!",Toast.LENGTH_LONG,ToastGravity.BOTTOM,Colors.red,Colors.white,15);
    }
  }

 void _sendMail() async {
    // Android and iOS
    var uri ='mailto:ranylfoumbi@gmail.com?subject=Plainte contre le ${widget.professions[0]['label']},'  ' ${widget.lastname} '  ' ${widget.name}s&body=Hello Ripair Assistance';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  void _showRatingDialog() {
  // We use the built in showDialog function to show our Rating Dialog
  showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) {
        return RatingDialog(
          icon: Icon(FontAwesome5.star,size: 40,color: BLACK_DEGRADE_COLOR,), // set your own image/icon widget
          title: "Appréciez",
          description: "Appréciez à sa juste valeur le travail effectué par ${widget.name}",
          submitButton: "Voter",
          alternativeButton: "Contactez nous.", // optional
          positiveComment: "Travail impeccable!", // optional
          negativeComment: "Travail insatisfaisant.!", // optional
          accentColor: YELLOW_COLOR, // optional
          onSubmitPressed: (int rating) {
            print("onSubmitPressed: rating = $rating");
            _rateTech(widget.id, rating);
            // TODO: open the app's page on Google Play / Apple App Store
          },
          onAlternativePressed: () {
            print("onAlternativePressed: do something");
            // TODO: maybe you want the user to contact you instead of rating a bad review
            _sendMail();
          },
        );
      });
}

Widget _displayMulti(listItems){
    var list = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[]
    );
    for(var item in listItems){
      list.children.add(Text(item['label'],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold))) ;
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
                        height: MediaQuery.of(context).size.height / 2,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top:0,
                              left: 0,
                              right: 0,
                              bottom: 70,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25)
                                  ),
                                ),
                                child: Stack(
                                  children: <Widget>[

                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(25),
                                            bottomRight: Radius.circular(25)
                                        ),
                                        child: Image.network(widget.techPic,
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height / 2,
                                          fit: BoxFit.cover
                                        ),
                                      ),

                                    IconButton(
                                      padding: EdgeInsets.only(top: 55,left: 15),
                                      icon: Icon(Icons.arrow_back_ios,color: WHITE_COLOR),
                                      onPressed: ()=>Navigator.of(context).pop(),
                                      iconSize: 30.0,
                                    ),

                                  ],
                                ),
                              ),
                            ),

                            Positioned(
                              top:260,
                              left: 20,
                              right: 20,
                              bottom: 0,
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(widget.name +" "+ widget.lastname, style: TextStyle(fontSize: 22),)
                                        ],
                                      ),

                                      Divider(),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(

                                            child: Interaction(widget.nbrOfCall.toString(), 'Appels reçus'),
                                          ),

                                          Column(
                                            children: <Widget>[
                                              SmoothStarRating(
                                                rating: double.parse(widget.numberOfStars),
                                                isReadOnly: false,
                                                size: 13.5,
                                                filledIconData: Icons.star,
                                                halfFilledIconData: Icons.star_half,
                                                defaultIconData: Icons.star_border,
                                                color: YELLOW_COLOR,
                                                borderColor: BLACK_DEGRADE_COLOR,
                                                starCount: 5,
                                                allowHalfRating: true,
                                                spacing: 2.0,
                                              ),

                                              Text(widget.numberOfStars.toString().length >= 4 ? widget.numberOfStars.toString().substring(0, 3) : widget.numberOfStars.toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  decoration: TextDecoration.none,
                                                  color: Colors.black,
                                                  fontFamily: 'EbrimaBold',
                                                ),
                                              ),
                                            ],
                                          ),

                                          Container(
                                            child: Interaction(widget.nbrOfComment.toString(), 'Commentaires'),
                                          ),

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
                                  width: MediaQuery.of(context).size.width/2.5,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.location_on,color: BLUE_COLOR,size: 20,),
                                      SizedBox(width: 10),

                                      Expanded(
                                          child: Text(widget.town+ " , "+ widget.quarter,
                                            style: TextStyle(fontSize: 15),
                                          )
                                      )
                                    ],
                                  ),
                                ),

//

                                Container(
                                    width: MediaQuery.of(context).size.width/2.5,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.language,color: BLUE_COLOR,size: 20,),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: _displayMulti(widget.languages),
                                        )

                                      ],
                                    )
                                )
                              ],
                            ),

                            SizedBox(height: 8,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: 60,
                                    height: 40,
                                    margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width/3,
                                      left: MediaQuery.of(context).size.width/3.5
                                    ),
                                    decoration: BoxDecoration(
                                      color: BLUE_COLOR,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 3),
                                            blurRadius: 5,
                                            color: Colors.grey)
                                      ],
                                    ),
                                    child: Icon(FontAwesome.phone,color: WHITE_COLOR,),
                                    alignment: Alignment.center,
                                  ),
                                  onTap: (){
                                    _initiateCall();
                                  },
                                )
                              ],
                            ),

                            SizedBox(height: 8,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width/2.5,
                                    child:Row(
                                      children: <Widget>[
                                        Icon(Icons.work,color: BLUE_COLOR,size: 20,),
                                        SizedBox(width: 10),
                                        Expanded(
                                            child: _displayMulti(widget.professions),
                                        ),
                                      ],
                                    )
                                ),

                                SizedBox(
                                  width: 10,
                                ),

                                Container(
                                    width: MediaQuery.of(context).size.width/2.5,
                                    child:Row(
                                      children: <Widget>[
                                        Icon(Icons.star,color: BLUE_COLOR,size: 20,),
                                        SizedBox(width: 10),
                                        InkWell(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width/4.2,
                                            height: 23,
                                            decoration: BoxDecoration(
                                              color: YELLOW_COLOR,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(0, 3),
                                                    blurRadius: 5,
                                                    color: Colors.grey)
                                              ],
                                            ),
                                            child: Text("Appréciez",
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          onTap: _showRatingDialog,
                                        )
                                      ],
                                    )
                                ),
                              ],
                            ),

                            SizedBox(height: 10,),

                            Row(
                              children: <Widget>[
                                Text("A propos",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                SizedBox(width: 10),
                              ],
                            ),

                            SizedBox(height: 10,),

                            Container(
                              margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: BLACK_DEGRADE_COLOR.withOpacity(0.2))
                                ),
                                width: MediaQuery.of(context).size.width / 1.1,
                                padding: EdgeInsets.all(10),
                                child: Text(widget.description,
//                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontSize: 14.0,),
                                )
                            ),

                          ],
                        )
                      ),

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
                                  borderRadius: BorderRadius.circular(15.0),
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
                                            hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                            border: InputBorder.none),
                                        controller: _commentController,
                                        onChanged: (value){
                                          print(_commentController.text);
                                        },
                                      ),
                                    ),

                                    _isPosting
                                              ?
                                                SpinKitRipple(
                                                  color: BLUE_COLOR,
                                                  size: 30.0,
                                                  controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                                                )
                                              :
                                                IconButton(
                                                  icon: Icon(
                                                    FontAwesome.send,
                                                    color: BLUE_COLOR,
                                                    size: 18,
                                                  ),
                                                  onPressed: () {
                                                    _validateCommentField();
                                                  },
                                                ),
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
      )
    );
  }

  DraggableScrollableSheet _buildCommentList() {

    return  DraggableScrollableSheet(
                initialChildSize: 0.03,
                minChildSize: 0.03,
                maxChildSize: 0.8,
                builder: (BuildContext context, ScrollController scrollController){
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: WHITE_COLOR,
                          ),
                          child: FutureBuilder(
                            future: commentList,
                            builder: (context, commentList) {
                                if (commentList.connectionState == ConnectionState.waiting ) {
                                return Center(
//                                        child: CircularProgressIndicator()
                                     );
                                  }
                                else if (commentList.hasError){
                                      toast("Une erreur s'est produite.",Toast.LENGTH_SHORT ,ToastGravity.BOTTOM, Colors.red, Colors.white, 14);
                                      return CustomScrollView(slivers: <Widget>[
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
                                              SizedBox(width: MediaQuery.of(context).size.width / 1,),
                                              Container(
                                                alignment: Alignment.center,
                                                width: 70,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                    color: WHITE_COLOR,
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                              ),
                                              Divider(color: BLUE_COLOR,height: 5,),
                                              Text(commentList.data.length.toString() +"  "+ "Commentaires"),
                                            ],
                                          ),
                                          backgroundColor: BLUE_COLOR,
                                          automaticallyImplyLeading: false,
                                          primary: false,
                                          pinned: true,
                                        ),
                                        (commentList.data.length == 0 || commentList.data == null)
                                                                        ?
                                                                           SliverList(
                                                                              delegate: SliverChildBuilderDelegate(
                                                                                    (context, idx) => Container(
                                                                                  alignment: Alignment.center,
                                                                                  padding: EdgeInsets.all(35),
                                                                                  child: Text("Aucun commentaire."),
                                                                                ),
                                                                                childCount: 1,
                                                                              ),
                                                                            )
                                                                        :
                                                                           SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                                (context, idx) => ListTile(
                                              leading: Container(
                                                  width: 40,
                                                  height: 40,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(50),
                                                    child: Icon(FontAwesome.user_circle,size: 30,),
                                                  )
                                              ),
                                              title: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: MediaQuery.of(context).size.width * .8),
                                                    padding: const EdgeInsets.all(15.0),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xfff9f9f9),
                                                      borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(25),
                                                        bottomLeft: Radius.circular(25),
                                                        bottomRight: Radius.circular(25),
                                                      ),
                                                    ),
                                                    child: Text( commentList.data[idx]['content'],
                                                      style: Theme.of(context).textTheme.body1.apply(
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(commentList.data[idx]['date'],
                                                      style: TextStyle(
                                                          color: BLACK_DEGRADE_COLOR,
                                                          fontSize: 10
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  )
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
                            )
                      );
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

          Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
                color: Colors.black,
                fontFamily: 'Ebrima',
              )
          )
        ],
      ),
    );

  }

}
