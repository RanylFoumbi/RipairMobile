import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oneHelp/apiCall/astuce.dart';
import 'package:oneHelp/apiCall/user.dart';
import 'package:oneHelp/models/astuce.dart';
import 'package:oneHelp/ui/components/astuces/detailAstuce.dart';
import 'package:oneHelp/ui/components/technicien/techDetail.dart';
import 'package:oneHelp/utilities/constant/colors.dart';

import 'package:oneHelp/utilities/permission/location.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Home extends StatefulWidget{

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var location = PermissionHandler().locationStorage.getItem("location");
  ScrollController _scrollController = new ScrollController();

  @override
  void initState(){
    super.initState();

  }

  Widget _getCourseList(screenSize){
    return FutureBuilder(
        builder: (context, astuceSnap) {
          if (astuceSnap.connectionState == ConnectionState.none &&
              astuceSnap.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Center(
              child: Text('Aucune astuce trouvée.'),
            );
          }
          if (astuceSnap.connectionState == ConnectionState.waiting) {
            return Center(
                child: SpinKitDualRing(color: BLUE_COLOR, size: 35,)
            );
          }
          if (astuceSnap.hasError)
            return Container(
              margin: EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.signal_wifi_off,size: 30,),
                  SizedBox(height: 10,),
                  Text('Verifier votre connexion internet!'),
                ],
              ),
            );
          else
            return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      itemCount: astuceSnap.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var nbrOfStar = astuceSnap.data[index]['rating'].length == 0 ? 0 : (astuceSnap.data[index]['rating'].reduce((curr, next) => curr + next)) / astuceSnap.data[index]['rating'].length;
                        var convertedStar = nbrOfStar.toString().length >= 4 ? nbrOfStar.toString().substring(0, 3) : nbrOfStar.toString();
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AstuceDetails(
                              key: Key(index.toString()),
                              astuce: Astuce.fromJson(astuceSnap.data[index]),
                              star: convertedStar,
                            )));
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 8,bottom: 2,left: 15,right: 3),
                              decoration: BoxDecoration(
                                  color: WHITE_COLOR,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Color(0xff707070).withOpacity(0.2),
                                      offset: Offset(0, 2),
                                    )
                                  ]
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          image: DecorationImage(
                                              colorFilter: ColorFilter.mode(BLACK_COLOR.withOpacity(0.35), BlendMode.overlay),
//                                              image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSgtTSEUFFEUqtzf_oun_Y2pbrpVvds4pVMsQ&usqp=CAU"),
                                              image: new NetworkImage(astuceSnap.data[index]['images'][0]),
                                              fit: BoxFit.cover
                                          )
                                      ),
                                      width: screenSize.width/2,
                                      child: new Stack(
                                        children: <Widget>[

                                          Container(
                                            width: screenSize.width/2,
                                            height: screenSize.height/7.3,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                  colors: [Colors.black54, BLACK_COLOR.withOpacity(0)],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                )
                                            ),
                                          ),

                                        ],
                                      )
                                  ),

                                  const SizedBox(height: 5),

                                  Container(
                                    width: screenSize.width/2.1,
                                    padding: EdgeInsets.all(4),
                                    child: Text(
                                      astuceSnap.data[index]['name'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(color: BLACK_COLOR, fontWeight: FontWeight.w400, fontSize: 14.0),
                                    ),
                                  ),

                                  Container(
                                    width: screenSize.width/2.3,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(width: 5,),
                                        SmoothStarRating(
                                            rating: double.parse(convertedStar),
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

                                        SizedBox(width: 5,),

                                        Text("("+ convertedStar +")",
                                          style: TextStyle(
                                              color: BLACK_DEGRADE_COLOR,
                                              fontWeight: FontWeight.w600
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ]
                              )
                          ),
                        );
                      }
                  );
        },
      future:  AstuceApi().fetchAstuce(),
    );
  }

  Widget _getTechnician(town) {
    return FutureBuilder(
      builder: (context, techSnap) {
        if (techSnap.connectionState == ConnectionState.none &&
            techSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Center(
            child: Text('Aucun technicien trouvé.'),
          );
        }
        if (techSnap.connectionState == ConnectionState.waiting) {
          return Center(
              child: SpinKitDoubleBounce(color: BLUE_COLOR, size: 35,)
          );
        }
        if (techSnap.hasError)
          return Container(
            margin: EdgeInsets.only(top: 50),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.signal_wifi_off,size: 30,),
                SizedBox(height: 10,),
                Text('Verifier votre connexion internet!'),
              ],
            ),
          );
        else
        return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemCount: techSnap.data.length,
            itemBuilder: (BuildContext context, int index) {
              var nbrOfStar = techSnap.data[index]['rating'].length == 0 ? 0 : (techSnap.data[index]['rating'].reduce((curr, next) => curr + next)) / techSnap.data[index]['rating'].length;

              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> TechnicianDetails(
                    key: Key(index.toString()),
                      id: techSnap.data[index]['_id'],
                      nbrOfCall: techSnap.data[index]['nbrOfCall'],
                      techPic: techSnap.data[index]['techPic'],
                      phone: techSnap.data[index]['phone'],
                      professions: techSnap.data[index]['professions'],
                      description: techSnap.data[index]['description'],
                      quarter: techSnap.data[index]['quarter'],
                      town: techSnap.data[index]['town'],
                      date: techSnap.data[index]['date'],
                      name: techSnap.data[index]['name'],
                      languages: techSnap.data[index]['languages'],
                      lastname: techSnap.data[index]['lastname'],
                      nbrOfComment: techSnap.data[index]['nbrOfComment'],
                      numberOfStars: nbrOfStar.toString().length >= 4 ? nbrOfStar.toString().substring(0, 3) : nbrOfStar.toString(),
                    )
                   )
                  );
                },
                child: Container(
                    margin: EdgeInsets.only(top: 4,bottom: 2,left: 12,right: 5),
                    decoration: BoxDecoration(
                        color: WHITE_COLOR,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          new BoxShadow(
                            color: Color(0xff707070).withOpacity(0.2),
                            offset: Offset(0, 2),
                          )
                        ]
                    ),
                    child: Column(
                        children: <Widget>[
                          new Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      colorFilter: ColorFilter.mode(BLACK_COLOR.withOpacity(0.35), BlendMode.overlay),
                                      image: new NetworkImage(techSnap.data[index]['techPic']),
                                      fit: BoxFit.cover
                                  )
                              ),
                              child: new Stack(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width/3.3,
                                    height: MediaQuery.of(context).size.height/7.3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                          colors: [Colors.black54, BLACK_COLOR.withOpacity(0)],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        )
                                    ),
                                  ),

                                ],
                              )
                          ),

                          Divider(color: WHITE_COLOR,),

                          SizedBox(
                            width: MediaQuery.of(context).size.width/4.2,
                            child: Text(techSnap.data[index]['name']+" " +techSnap.data[index]['lastname'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(color: BLACK_COLOR, fontWeight: FontWeight.w400, fontSize: 12),
                            ),
                          ),

                          const SizedBox(height: 3),

                          SizedBox(
                            width: MediaQuery.of(context).size.width/4.2,
                            child: Text(
                              techSnap.data[index]['professions'][0],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(color: BLACK_COLOR, fontWeight: FontWeight.w300, fontSize: 12),
                            ),
                          ),

                          const SizedBox(height: 3),

                          SizedBox(
                              width: MediaQuery.of(context).size.width/4.2,
                              child: Row(
                                children: <Widget>[

                                  Container(
                                      width: 35,
                                      height: 15,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[

                                          Icon(Icons.phone_in_talk, color: BLACK_DEGRADE_COLOR,size: 15     ,),

                                          Text(techSnap.data[index]['nbrOfCall'].toString(),
                                              textAlign: TextAlign.center,
                                              style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: BLACK_COLOR,
                                                fontSize: 13,
                                              )
                                          ),
                                        ],
                                      )
                                  ),

                                  Spacer(),

                                  Container(
                                      width: 43,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: YELLOW_COLOR
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[

                                          Icon(Icons.star, color: BLACK_DEGRADE_COLOR,size: 15,),

                                          Text(nbrOfStar.toString().length >= 4 ? nbrOfStar.toString().substring(0, 3) : nbrOfStar.toString(),
                                              textAlign: TextAlign.center,
                                              style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: BLACK_DEGRADE_COLOR,
                                                fontSize: 13.5,
                                              )
                                          ),
                                        ],
                                      )
                                  )


                                ],
                              )
                          ),
                        ]
                    )
                ),
              );
            }
        );
      },
      future: town == "recent" ? UserApi().fetchMostRecentTech() :  UserApi().fetchBestTech(town),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    /*get the size of the screen*/
    Size _screenSize = MediaQuery.of(context).size;

    return  Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
                title: Container(
                  color: WHITE_COLOR,
                  alignment: Alignment.center,
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Image(
                          image:AssetImage("assets/icons/ripair_logo_small.png"),
                          height: 45,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        child: GestureDetector(
                          child: Icon(Icons.more_vert, color: BLACK_DEGRADE_COLOR,size: 22,),
                          onTap: (){},
                        ),
                      )

                    ],
                  )
                ),
                backgroundColor: WHITE_COLOR,
          ),
          body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              Divider(color: WHITE_COLOR,),
              Container(
                padding: EdgeInsets.only(right: 20,left: 16,top: 10),
//                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Découvrir',
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontFamily: "Ebrima",
                              fontWeight: FontWeight.bold,
                              color: BLACK_COLOR,
                              fontSize: 20.0,
                            )
                        ),

                        new Spacer(),

                        GestureDetector(
                          child: Text("voir plus",style: TextStyle(color: BLUE_COLOR,fontSize: 13),),
                          onTap: null,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Decouvrez',
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontFamily: "Ebrima",
                              fontWeight: FontWeight.w100,
                              color: BLACK_COLOR,
                              fontSize: 13.0,
                            )
                        ),

                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 170,
                child: _getCourseList(_screenSize),
              ),
              Container(
                padding: EdgeInsets.only(right: 20,left: 16),
                margin: EdgeInsets.only(top: 12,bottom: 5),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Les meilleurs(5)',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          fontFamily: "Ebrima",
                          fontWeight: FontWeight.bold,
                          color: BLACK_COLOR,
                          fontSize: 20.0,
                        )
                    ),

                    new Spacer(),

                    GestureDetector(
                      child: Text("voir plus",style: TextStyle(color: BLUE_COLOR,fontSize: 13),),
                      onTap: null,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 180,
                child: _getTechnician(location),
              ),

              Container(
                padding: EdgeInsets.only(right: 20,left: 16),
                margin: EdgeInsets.only(top: 10,bottom: 5),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Plus récents',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          fontFamily: "Ebrima",
                          fontWeight: FontWeight.bold,
                          color: BLACK_COLOR,
                          fontSize: 20.0,
                        )
                    ),

                    new Spacer(),

                    GestureDetector(
                      child: Text("voir plus",style: TextStyle(color: BLUE_COLOR,fontSize: 13),),
                      onTap: null,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 180,
                child: _getTechnician('recent'),
              ),
            ],
          ),
        );
  }

  @override
  void dispose(){
    super.dispose();
  }

}