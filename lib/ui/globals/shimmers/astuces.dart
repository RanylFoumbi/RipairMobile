

import 'package:flutter/material.dart';
import 'package:oneHelp/utilities/constant/colors.dart';
import 'package:shimmer/shimmer.dart';

class AstuceShimmer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size screenSize = MediaQuery.of(context).size;

    return ListView.builder(
      padding: EdgeInsets.only(right: 5,top: 5),
      itemCount: 3,
      itemBuilder: (context, index) {

        return Padding(
          padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 8,
              bottom: 16
          ),
          child: InkWell(
            onTap: null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[

                        AspectRatio(
                            aspectRatio: 2,
                            child: Container(
                              width: screenSize.width/3.25,
                              height: screenSize.height/7.35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                                  gradient: LinearGradient(
                                    colors: [Colors.grey, BLACK_DEGRADE_COLOR.withOpacity(0)],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  )
                              ),
                            )
                        ),

                        Container(
                            color: WHITE_COLOR,
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Container(
                                              width: screenSize.width/1.4,
                                              margin: EdgeInsets.only(left: 5),
                                              alignment: Alignment.centerLeft,
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.grey[100],
                                                highlightColor: WHITE_COLOR,
                                                enabled: true,
                                                child:Container(
                                                  height: 12,
                                                  color: Colors.grey[100],
                                                ),
                                              )
                                          ),

                                          SizedBox(height: 8,),

                                          Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    width: screenSize.width/2.2,
                                                    margin: EdgeInsets.only(left: 5),
                                                    alignment: Alignment.centerLeft,
                                                    child: Shimmer.fromColors(
                                                      baseColor: Colors.grey[100],
                                                      highlightColor: WHITE_COLOR,
                                                      enabled: true,
                                                      child:Container(
                                                        height: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                ),

                                                SizedBox(width: 5,),

                                                Container(
                                                    width: 25,
                                                    margin: EdgeInsets.only(left: 2),
                                                    alignment: Alignment.centerLeft,
                                                    child: Shimmer.fromColors(
                                                      baseColor: Colors.grey[100],
                                                      highlightColor: WHITE_COLOR,
                                                      enabled: true,
                                                      child:Container(
                                                        height: 12,
                                                        color: Colors.grey[100],
                                                      ),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                    Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                            width: screenSize.width/4.2,
                            alignment: Alignment.centerLeft,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[100],
                              highlightColor: WHITE_COLOR,
                              enabled: true,
                              child:Container(
                                height:25,
                                decoration: BoxDecoration(color:  Colors.grey, borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.all(7),
                              ),
                            )
                        ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}