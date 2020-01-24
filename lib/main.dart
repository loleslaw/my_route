import 'package:flutter/material.dart';
import 'package:my_route/_pages/00_home_page.dart';
import 'package:my_route/_pages/00__router.dart' as router;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyRoute',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MapPage(),
      onGenerateRoute: router.generateRoute ,
      initialRoute: '/',
    );
  }
}
