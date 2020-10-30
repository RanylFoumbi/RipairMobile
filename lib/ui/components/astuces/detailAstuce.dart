import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:localstorage/localstorage.dart';
import 'package:oneHelp/apiCall/astuce.dart';
import 'package:oneHelp/models/astuce.dart';
import 'package:oneHelp/utilities/connectivity.dart';
import 'package:oneHelp/utilities/constant/colors.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class AstuceDetails extends StatefulWidget{
    const AstuceDetails( {Key key,
      this.astuce,
      this.star
    }): super(key: key);

    final Astuce astuce;
    final String star;

  _AstuceDetailsState createState()=> _AstuceDetailsState();
}

class _AstuceDetailsState extends State<AstuceDetails>{

   ScrollController _scrollController = new ScrollController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: (){Navigator.of(context).pop();},
      child: Scaffold(
        appBar:  PreferredSize(
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: new Swiper(
                    onTap: (index){
//                      print(image);
//                      photoView(context, photoView(context, widget.astuce.images[index]));
                    },
                    autoplayDelay: 1,
                    controller: SwiperController(),
                    itemBuilder: (BuildContext context, int index) {
                      return new Image.network(
                        widget.astuce.images[index],
                        fit: BoxFit.cover,
                      );
                    },
                    autoplay: true,
                    itemCount: widget.astuce.images.length,
                    pagination: new SwiperPagination(),
                    control: null,
                  )),

                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  padding: EdgeInsets.all(40.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: BLACK_DEGRADE_COLOR
                  ),
                ),


                Positioned(
                  left: 12.0,
                  top: 60.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),

                Positioned(
                    left: 20.0,
                    top: MediaQuery.of(context).size.height / 2.8,
                    child: Container(
                      decoration: BoxDecoration(color: BLUE_COLOR,borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(8),
                      child: Text( widget.astuce.domain.toUpperCase(), style: TextStyle(color: Colors.white)),
                    )
                ),

                Positioned(
                    right: 20.0,
                    top: MediaQuery.of(context).size.height / 2.7,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SmoothStarRating(
                          rating: double.parse(widget.star),
                          isReadOnly: true,
                          size: 16.5,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          defaultIconData: Icons.star_border,
                          color: YELLOW_COLOR,
                          borderColor: WHITE_COLOR,
                          starCount: 5,
                          allowHalfRating: true,
                          spacing: 2.0,
                        ),

                        new SizedBox(width: 5,),

                        Text("("+ widget.star +")",
                          style: TextStyle(
                              color: WHITE_COLOR,
                              fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    )
                )
              ],
            ),
            preferredSize: Size.fromHeight(280)
        ),
        body: ListView(
          padding: EdgeInsets.all(25),
          shrinkWrap: true,
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          children: <Widget>[

            Container(
                width: MediaQuery.of(context).size.width / 2,
                padding: EdgeInsets.all(7),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: BLACK_DEGRADE_COLOR.withOpacity(0.2))
                ),
                child: Text(
                  widget.astuce.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.amber),
                )
            ),

            new Divider(color: WHITE_COLOR),

            Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '        '+widget.astuce.content,
                  style: TextStyle(fontSize: 17.0,),
                )
            ),

            new Divider(color: BLACK_DEGRADE_COLOR),

            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Publié: ',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),

                            Text(
                              widget.astuce.date.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    new Spacer(),

                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Noter:",
                              style: TextStyle(
                                  color: BLACK_DEGRADE_COLOR,
                                  fontWeight: FontWeight.w600
                              ),
                            ),

                            new SizedBox(width: 5,),

                            SmoothStarRating(
                              rating: 0,
                              isReadOnly: false,
                              size: 17.5,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half,
                              defaultIconData: Icons.star_border,
                              color: YELLOW_COLOR,
                              borderColor: BLACK_DEGRADE_COLOR,
                              starCount: 5,
                              allowHalfRating: true,
                              spacing: 2.0,
                              onRated: (rating){
                                AstuceApi().rateAstuce(widget.astuce.id, rating).then((value) => {
//                                  courseRate.setItem("rate", rating)
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}