import 'package:flutter/material.dart';
import 'package:oneHelp/models/astuce.dart';
import 'package:oneHelp/utilities/constant/colors.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'detailAstuce.dart';

class SingleAstuce extends StatelessWidget {
  const SingleAstuce( {Key key,
    this.astuce,
    this.star
  }): super(key: key);

  final Astuce astuce;
  final String star;

  @override
  Widget build(BuildContext context) {
    return  Padding(
              padding: const EdgeInsets.only(
                  left: 24, 
                  right: 24, 
                  top: 8, 
                  bottom: 16
              ),
              child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AstuceDetails(
                          key: key,
                          astuce: astuce,
                          star: star,
                        ),
                      )
                    );
                  },
                  child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
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
                              child: Image(
                                      image: NetworkImage(astuce.images[0]),
                                      fit: BoxFit.cover,
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

                                                Text(
                                                  astuce.name,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                ),

                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      SmoothStarRating(
                                                        rating: double.parse(star),
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

                                                      Text("("+ star +")",
                                                        style: TextStyle(
                                                            color: BLACK_DEGRADE_COLOR,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      )
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
                            decoration: BoxDecoration(color: BLUE_COLOR,borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(7),
                            child: Text( astuce.domain.toUpperCase(), style: TextStyle(color: Colors.white)),
                          )
                        )
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
