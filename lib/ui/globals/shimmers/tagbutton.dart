

import 'package:flutter/material.dart';
import 'package:oneHelp/utilities/constant/colors.dart';
import 'package:shimmer/shimmer.dart';

class TagShimmer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return  ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 17),
                controller: ScrollController(),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(right: 5,bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(5),
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey[200],
                        highlightColor: WHITE_COLOR,
                        enabled: true,
                        child:
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(color: BLUE_COLOR)
                          ),
                          color:Colors.grey[200],
                          onPressed: null,
                          textColor:WHITE_COLOR,
                          child: Text("loading...",
                              style: TextStyle(fontSize: 12)
                          ),
                      )
                    ),
                  );
                }

            );
  }

}