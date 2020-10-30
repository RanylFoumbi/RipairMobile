
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oneHelp/ui/components/Home/home.dart';
import 'package:oneHelp/ui/components/astuces/astuceHome.dart';
import 'package:oneHelp/ui/components/auth/login.dart';
import 'package:oneHelp/ui/components/technicien/techList.dart';
import 'package:oneHelp/utilities/constant/colors.dart';

class BigContainer extends StatefulWidget {
  @override
  _BigContainerState createState() => _BigContainerState();
}

class _BigContainerState extends State<BigContainer> with SingleTickerProviderStateMixin {

  int _selectedIndex = 0;
  PageController _pageController;
  List<Widget> _screenList = [Home(),TechList(),AstuceHomeScreen(),Login()];

/*when init component*/
  @override
  void initState() {
    _pageController = new PageController();
    super.initState();
  }

  /*On item click in the nav bar*/
  void _onTap(index)async{
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
          children: <Widget>[

            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(bottom: 0),
              child: PageView(
                children: _screenList,
                controller: _pageController,
                onPageChanged: (index) => setState(() {
                  _selectedIndex = index;
                }),
              ),
            ),

          ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: WHITE_COLOR,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedItemColor: BLUE_COLOR,
        unselectedItemColor: BLACK_DEGRADE_COLOR,
        currentIndex: _selectedIndex,
        onTap:  (index) =>setState(() {
          _selectedIndex = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        }),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Accueil"),
            activeIcon: Icon(Icons.home, color: BLUE_COLOR),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesome.search),
            title: Text("Recherche"),
            activeIcon: Icon(FontAwesome.search, color: BLUE_COLOR),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update, size: 27,),
            title: Text("Astuces"),
            activeIcon: Icon(Icons.update, size: 27, color: BLUE_COLOR),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline, size: 27,),
            title: Text("Profil"),
            activeIcon: Icon(Icons.lightbulb_outline, size: 27, color: BLUE_COLOR),
          ),
        ],
      )
    );
  }


  /*when the component die*/
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}