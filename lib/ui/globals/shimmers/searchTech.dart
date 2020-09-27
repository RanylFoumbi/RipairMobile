

import 'package:flutter/material.dart';
import 'package:oneHelp/utilities/constant/colors.dart';
import 'package:shimmer/shimmer.dart';

class TechShimmer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size screenSize = MediaQuery.of(context).size;

    return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.35),
              ),
              padding: EdgeInsets.only(right: 5,top: 5),
              itemCount: 9,
              itemBuilder: (context, index) {

                return GestureDetector(
                  onTap: (){},
                  child: Container(
                      margin: EdgeInsets.only(top: 8,bottom: 2,left: 12,right: 5),
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
                                ),
                                child: new Stack(
                                  children: <Widget>[
                                    Container(
                                      width: screenSize.width/3.25,
                                      height: screenSize.height/7.35,
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

                            Container(
                                width: screenSize.width/4.2,
                                margin: EdgeInsets.only(left: 10),
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

                            const SizedBox(height: 5),

                            Container(
                              width: screenSize.width/5.2,
                              margin: EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              child: Shimmer.fromColors(
                                      baseColor: Colors.grey[100],
                                      highlightColor: WHITE_COLOR,
                                      enabled: true,
                                      child:Container(
                                        alignment: Alignment.centerLeft,
                                        height: 12,
                                        width: screenSize.width/5.2,
                                        color: Colors.grey[100],
                                      ),
                                  )
                            ),

                            const SizedBox(height: 8),


                            Container(
                                width: screenSize.width/4.2,
                                margin: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[

                                    Container(
                                        width: 25,
                                        alignment: Alignment.centerLeft,
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey[100],
                                          highlightColor: WHITE_COLOR,
                                          enabled: true,
                                          child:Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Colors.grey[100],
                                            ),
                                            alignment: Alignment.centerLeft,
                                            height: 12,
                                          ),
                                        )
                                    ),

                                    const SizedBox(width: 15),

                                    Container(
                                        width: 40,
                                        child:  Shimmer.fromColors(
                                          baseColor: Colors.grey[100],
                                          highlightColor: WHITE_COLOR,
                                          enabled: true,
                                          child:Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Colors.grey[100],
                                            ),
                                            alignment: Alignment.centerLeft,
                                            height: 13,
                                            width: screenSize.width/8.2,
                                          ),
                                        )
                                    )


                                  ],
                                )
                            ),
                          ]
                      )
                  ),
                );
              },
            );
  }

}