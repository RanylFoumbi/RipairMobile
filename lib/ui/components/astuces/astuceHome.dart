import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oneHelp/apiCall/astuce.dart';
import 'package:oneHelp/models/astuce.dart';
import 'package:oneHelp/ui/components/astuces/singleAstuce.dart';
import 'package:oneHelp/ui/globals/shimmers/astuces.dart';
import 'package:oneHelp/utilities/constant/colors.dart';

class AstuceHomeScreen extends StatefulWidget {
  @override
  _AstuceHomeScreenState createState() => _AstuceHomeScreenState();
}

class _AstuceHomeScreenState extends State<AstuceHomeScreen> with TickerProviderStateMixin {

  List<Astuce> _astuceList;
  bool isLoading = false;
  final ScrollController _scrollController = new ScrollController();

  void _fetchAstuces(){
    setState(() {
      isLoading = true;
    });
    AstuceApi().fetchAstuceList().then((res) {
      Iterable list = json.decode(res.body)['courses'];
      setState(() {
        _astuceList = list.map((model) => Astuce.fromJson(model)).toList();
        isLoading = false;
      });
      }).catchError((err){
        print(err);
        setState(() {
          isLoading = false;
        });
    });
  }

  void searchAstuce(String query){
    setState(() {
      isLoading = true;
    });
    AstuceApi().searchAstuce(query).then((res) {
      Iterable list = json.decode(res.body)['courses'];
      setState(() {
        _astuceList = list.map((model) => Astuce.fromJson(model)).toList();
        isLoading = false;
      });
    }).catchError((err){
      print(err);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAstuces();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
          backgroundColor: WHITE_COLOR,
          appBar: PreferredSize(
            child:AppBar(
                title: Container(
                  color: WHITE_COLOR,
                  padding: EdgeInsets.only(top: 10),
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(FontAwesome.lightbulb_o,color: BLUE_COLOR,size: 30,),
                      Container(
                        margin: EdgeInsets.only(top:8, left: 8),
                        child: Text("Astuces",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22,
                              fontFamily: "Ebrima",
                              fontWeight: FontWeight.bold,
                              color: BLACK_COLOR),
                        ),
                      )
                    ],
                  )
                ),
                backgroundColor: WHITE_COLOR,
                elevation: 0.2,
                bottom: PreferredSize(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                              height: 48,
                              margin: EdgeInsets.only(left: 17,right: 15),
                              decoration: BoxDecoration(
                                  color: BLACK_DEGRADE_COLOR_SEARCH,
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Color(0xff707070).withOpacity(0.2),
                                      offset: Offset(0, 2),
                                    )
                                  ]
                              ),
                              child: TextField(
                                onChanged: (query){
                                  print(query);
                                  searchAstuce(query);
                                },
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(color: BLACK_DEGRADE_COLOR_SEARCH)
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(color: BLACK_DEGRADE_COLOR_SEARCH)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(color: BLACK_DEGRADE_COLOR_SEARCH)
                                    ),
                                    prefixIcon: IconButton(
                                      icon: Icon(FontAwesome.search,color: Color(0xff707070),size: 15,),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    contentPadding: EdgeInsets.only(left: 25),
                                    hintText: "Essayer 'electricite'",
                                    hintStyle: TextStyle(fontStyle: FontStyle.normal),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: BLACK_DEGRADE_COLOR_SEARCH,style: BorderStyle.none),
                                      borderRadius: BorderRadius.circular(10.0),
                                    )
                                ),
                              ),
                          ),
                         Divider(color: WHITE_COLOR,)
                      ],
                    ),
                    preferredSize: null
                )
            ),
            preferredSize: Size.fromHeight(125.0), // here the desired height
          ),
          body: isLoading
                        ?
                          AstuceShimmer()
                        :
                          ( _astuceList == null || _astuceList.length == 0)
                                                                          ?
                                                                            Center(
                                                                              child: Text('Aucune astuce trouvé.'),
                                                                            )
                                                                          :
                                                                            ListView.builder(
                                                                              scrollDirection: Axis.vertical,
                                                                              shrinkWrap: true,
                                                                              controller: _scrollController,
                                                                              itemCount: _astuceList.length,
                                                                              itemBuilder: (BuildContext context, index){
                                                                                var nbrOfStar = _astuceList[index].rating.length == 0 ? 0 : (_astuceList[index].rating.reduce((curr, next) => curr + next)) / _astuceList[index].rating.length;
                                                                                var convertedStar = nbrOfStar.toString().length >= 4 ? nbrOfStar.toString().substring(0, 3) : nbrOfStar.toString();
                                                                                return SingleAstuce(
                                                                                  key: Key(index.toString()),
                                                                                  astuce: _astuceList[index],
                                                                                  star: convertedStar,
                                                                                );
                                                                              },
                                                                            ),
        );
    }
  }
