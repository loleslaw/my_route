import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_route/_pages/01_map_page.dart';
import 'package:my_route/_pages/02_routesList_page.dart';
import 'package:my_route/_pages/03_sendData_page.dart';
import 'package:my_route/_pages/04_setup_page.dart';

const routes =['/','map', 'routesList', 'sendData', 'setup'];

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;
  MapPage _mapPage = MapPage();
  RoutesListPage _routesListPage = RoutesListPage();
  SendDataPage _sendDataPage = SendDataPage();
  SetupPage _setupPage = SetupPage();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          height: 50,
          animationDuration: Duration(milliseconds: 200),
          backgroundColor: Colors.blue,
          items: <Widget>[
            Icon(Icons.add, size: 30,),
            Icon(Icons.list, size: 30,),
            Icon(Icons.compare_arrows, size: 30,)
          ],
          onTap: (index) {
            debugPrint('current page index $index');
            setState(() {
              _page = index;
            });
          },

        ),
        body: ReturnSubpage(page: _page),
      ),
    );
  }
  Widget ReturnSubpage({int page}) {
    switch (page) {
      case 0 : return _mapPage;
      case 1 : return _routesListPage;
      case 2 : return _sendDataPage;
      case 3 : return _setupPage;
      default: return _mapPage;
    }
      

  }
}
