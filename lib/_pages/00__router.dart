import 'package:flutter/material.dart';
import 'package:my_route/_pages/00_home_page.dart';
import 'package:my_route/_pages/01_map_page.dart';
import 'package:my_route/_pages/02_routesList_page.dart';
import 'package:my_route/_pages/03_sendData_page.dart';
import 'package:my_route/_pages/04_setup_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/' : return MaterialPageRoute(builder: (context)=>HomePage());
    case 'map' : return MaterialPageRoute(builder: (contex)=> MapPage());
    case 'routesList' : return MaterialPageRoute(builder: (contex)=> RoutesListPage());
    case 'sendData' : return MaterialPageRoute(builder: (contex)=> SendDataPage());
    case 'setup' : return MaterialPageRoute(builder: (contex)=> SetupPage());
    default: return MaterialPageRoute(builder: (context)=>HomePage());
    
    
  }
}