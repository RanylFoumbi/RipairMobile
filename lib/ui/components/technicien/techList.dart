import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oneHelp/apiCall/domain.dart';
import 'package:oneHelp/apiCall/user.dart';
import 'package:oneHelp/models/domain.dart';
import 'package:oneHelp/ui/globals/shimmers/searchTech.dart';
import 'package:oneHelp/ui/globals/shimmers/tagbutton.dart';
import 'package:oneHelp/utilities/constant/colors.dart';

import 'package:oneHelp/utilities/permission/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'techDetail.dart';

class TechList extends StatefulWidget{

  @override
  _TechListState createState() => _TechListState();
}

class _TechListState extends State<TechList> {
  var location = PermissionHandler().locationStorage.getItem("location");
  ScrollController _scrollController = new ScrollController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List _techList;
  List<Domain> _domainList;
  bool _isLoading = false;
  bool _isLoadingDomain = false;
  String _domainForSearch;
  var _isSelected  = [];
  var prevIndex = [];

  @override
  void initState(){
    super.initState();
    _fetchTechnician(location, null);
    _fetchDomain();
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));
    // if failed,use refreshFailed()
    if(mounted)
      setState(() {
        _fetchTechnician(location, _domainForSearch);
      });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));

    if(mounted)
      setState(() {
        _fetchTechnician(location, _domainForSearch);
      });
    _refreshController.loadComplete();
  }

  void _fetchDomain(){
    setState(() {
      _isLoadingDomain = true;
    });
    DomainApi().fetchAllDomain().then((res) {
      setState(() {
        _domainList = res;
        _isLoadingDomain = false;
      });
      for(var i=0; i<_domainList.length; i++){
        _isSelected.add(false);
      }
    }).catchError((err){
      print(err);
      setState(() {
        _isLoadingDomain = false;
      });
    });
  }

  void _fetchTechnician(town, domain) async{
    setState(() {
      _isLoading = true;
    });

    if(town == null && domain == null){
      UserApi().fetchAllFreeTechnician().then((res) {
        setState(() {
          _techList = res;
          _isLoading = false;
        });
      }).catchError((err){
        print(err);
        setState(() {
          _isLoading = false;
        });
      });
    }
    else if(town == null && domain != null){
      UserApi().fetchFreeTechnicianByDomain(domain).then((res) {
        setState(() {
          _techList = res;
          _isLoading = false;
        });
      }).catchError((err){
        print(err);
        setState(() {
          _isLoading = false;
        });
      });
    }
    else if(town != null && domain == null){
      UserApi().fetchFreeTechnicianByTown(town).then((res) {
        setState(() {
          _techList = res;
          _isLoading = false;
        });
      }).catchError((err){
        print(err);
        setState(() {
          _isLoading = false;
        });
      });
    }
    else if(town != null && domain != null){
      UserApi().fetchAllFreeTechByDomainTown(domain, town).then((res) {
        print(res.runtimeType);
        setState(() {
          _techList = res;
          _isLoading = false;
        });
      }).catchError((err){
        print(err);
        setState(() {
          _isLoading = false;
        });
      });
    }

  }

  Widget _getTechnician(screenSize){

    return _isLoading
                      ?
                        TechShimmer()
                      :
                        ( _techList == null || _techList.length == 0)
                            ?
                              Center(
                                child: Text('Aucun technicien trouvé.'),
                              )
                            :
                              GridView.builder(
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: MediaQuery.of(context).size.width /
                                            (MediaQuery.of(context).size.height / 1.35),
                                         ),
                                        // padding: EdgeInsets.only(right: 5,top: 5),
                                        itemCount: _techList.length,
                                        padding: EdgeInsets.only(bottom: 8),
                                        itemBuilder: (context, index) {
                                          var nbrOfStar = _techList[index]['rating'].length == 0 ? 0 : (_techList[index]['rating'].reduce((curr, next) => curr + next)) / _techList[index]['rating'].length;
                                      return GestureDetector(
                                        onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=> TechnicianDetails(
                                                  key: Key(index.toString()),
                                                  id: _techList[index]['_id'],
                                                  nbrOfCall: _techList[index]['nbrOfCall'],
                                                  techPic: _techList[index]['techPic'],
                                                  phone: _techList[index]['phone'],
                                                  professions: _techList[index]['professions'],
                                                  description: _techList[index]['description'],
                                                  quarter: _techList[index]['quarter'],
                                                  town: _techList[index]['town'],
                                                  date: _techList[index]['date'],
                                                  name: _techList[index]['name'],
                                                  languages: _techList[index]['languages'],
                                                  lastname: _techList[index]['lastname'],
                                                  nbrOfComment: _techList[index]['nbrOfComment'],
                                                  numberOfStars: nbrOfStar.toString().length >= 4 ? nbrOfStar.toString().substring(0, 3) : nbrOfStar.toString(),
                                                    ),
                                                  )
                                                );
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(top: 8,bottom: 4,left: 12,right: 5),
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
                                                              image: new NetworkImage(_techList[index]['techPic']),
                                                              fit: BoxFit.cover
                                                          )
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

                                                  Divider(color: WHITE_COLOR,height: 5,),

                                                  SizedBox(
                                                    height: 13,
                                                    width: screenSize.width/4.2,
                                                    child: Text(
                                                      _techList[index]['name'] +" "+ _techList[index]['lastname'],
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      softWrap: true,
                                                      style: TextStyle(color: BLACK_COLOR, fontWeight: FontWeight.w500, fontSize: 12),
                                                    ),
                                                  ),

                                                  const SizedBox(height: 3),

                                                  SizedBox(
                                                    height: 13,
                                                    width: screenSize.width/4.2,
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text(
                                                          _techList[index]['professions'][0],
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          softWrap: true,
                                                          style: TextStyle(color: BLACK_COLOR, fontWeight: FontWeight.w300, fontSize: 12),
                                                        ),
                                                      ],
                                                    )
                                                  ),

                                                  const SizedBox(height: 3),

                                                  SizedBox(
                                                    height: 20,
                                                      width: screenSize.width/4.2,
                                                      child: Row(
                                                        children: <Widget>[

                                                          Container(
                                                              width: 35,
                                                              height: 15,
                                                              margin: EdgeInsets.only(bottom: 3),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: <Widget>[

                                                                  Icon(Icons.comment, color: BLACK_DEGRADE_COLOR,size: 14,),

                                                                  Text(_techList[index]['nbrOfComment'].toString(),
                                                                      textAlign: TextAlign.center,
                                                                      style: new TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: BLACK_COLOR,
                                                                        fontSize: 13.5,
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

                                                                  Icon(Icons.star, color: BLACK_DEGRADE_COLOR,size: 16,),

                                                                  Text(nbrOfStar.toString().length >= 4 ? nbrOfStar.toString().substring(0, 3) : nbrOfStar.toString(),
                                                                      textAlign: TextAlign.center,
                                                                      style: new TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: BLACK_DEGRADE_COLOR,
                                                                        fontSize: 14.5,
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
                                    },
                              );

  }

 void _setButtonState(int index) {

    if(prevIndex.length != 0) {
      print(prevIndex.last);
      setState(() {
        _isSelected[prevIndex.last] = false;
        _isSelected[index] = true;
        _domainForSearch = _domainList[index].name;
        prevIndex.add(index);
      });
      _fetchTechnician(location, _domainForSearch);
    }else{
      setState(() {
        _isSelected[index]=!_isSelected[index];
        _domainForSearch = _domainList[index].name;
        prevIndex.add(index);
      });
      _fetchTechnician(location, _domainForSearch);
    }
  }

  Widget _tagDomainButtons(){
    return _isLoadingDomain
                           ?
                              TagShimmer()
                            :
                              ( _domainList == null || _domainList.length == 0)
                            ?
                              Center(
                                child: Text('Aucun domain enregistrer.'),
                              )
                            :
                              ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.only(left: 17),
                                  controller: _scrollController,
                                  itemCount: _domainList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 5,bottom: 5),
                                      padding: EdgeInsets.all(5),
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            side: BorderSide(color: BLUE_COLOR)
                                        ),
                                        color:_isSelected[index] ? BLUE_COLOR : WHITE_COLOR,
                                        onPressed:()=> _setButtonState(index),
                                        textColor:_isSelected[index] ? WHITE_COLOR : BLUE_COLOR,
                                        child: Text(_domainList[index].name,
                                            style: TextStyle(fontSize: 12)
                                        ),
                                      ),
                                    );
                                  }

                              );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    /*get the size of the screen*/
    Size _screenSize = MediaQuery.of(context).size;

    final searchInput = new Container(
      height: 38,
      margin: EdgeInsets.only(left: 13,right: 13),
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
          _fetchTechnician(query, _domainForSearch);
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
            hintText: "Essayez 'Yaoundé'",
            hintStyle: TextStyle(fontStyle: FontStyle.normal),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: BLACK_DEGRADE_COLOR_SEARCH,style: BorderStyle.none),
              borderRadius: BorderRadius.circular(10.0),
            )
        ),
      ),
    );

    return  Scaffold(
      backgroundColor: Colors.white,
      appBar:PreferredSize(
          child:  AppBar(
              title: Container(
                  color: WHITE_COLOR,
                  padding: EdgeInsets.only(top: 10),
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(AntDesign.search1,color: BLUE_COLOR,size: 30,),
                      Container(
                        margin: EdgeInsets.only(top:8, left: 8),
                        child: Text("Besoin d'un technicien?",
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
//                      searchInput,
                      Divider(color: WHITE_COLOR,),
                      SizedBox(
                        height: 45,
                        child: _tagDomainButtons(),
                      ),

                    ],
                  ),
                  preferredSize: null
              )
          ),
          preferredSize: Size.fromHeight(115.0),
      ),
//      body: ,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        enableTwoLevel: true,
        header: WaterDropMaterialHeader(
          backgroundColor: BLUE_COLOR,
          distance: 60,
          offset: 5,
        ),
        footer: ClassicFooter(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: _getTechnician(_screenSize)
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
    _scrollController.dispose();
  }



}