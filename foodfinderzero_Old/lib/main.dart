import 'package:flutter/material.dart';
import 'package:foodfinderzero/services/data.dart';
import 'package:provider/provider.dart';

import './pages/home_page.dart';

void main() => runApp(new FoodFinderZero());

class FoodFinderZero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: ChangeNotifierProvider<DataService>(
        builder: (_) => DataService(),
        child: HomePage(),
      ),
      theme: ThemeData(
        fontFamily: 'MontserratAlternates',//'Montserrat',
        canvasColor: Colors.transparent,
        cardTheme: ThemeData.light().cardTheme.copyWith(
          elevation: 5,
          color: Colors.white
        )
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}