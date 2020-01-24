import 'package:flutter/material.dart';

class RoutesListPage extends StatelessWidget {
  const RoutesListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(appBar: AppBar(title: Text('Twoje trasy'),),),
    );
  }
}