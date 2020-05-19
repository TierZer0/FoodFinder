import 'package:flutter/material.dart';
import 'package:foodfinder/pages/home_page.dart';
import 'package:provider/provider.dart';


import './services/data_service.dart';

void main() => runApp(new FoodFinder());

class FoodFinder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: ChangeNotifierProvider<DataService>(
        builder: (_) => DataService(),
        child: HomePage(),
      ),
      theme: ThemeData(
        fontFamily: 'Montserrat',
        canvasColor: Colors.transparent
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}