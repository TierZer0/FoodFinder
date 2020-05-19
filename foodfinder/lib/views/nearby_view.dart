import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foodfinder/services/data_service.dart';

class NearbyView extends StatefulWidget {

  @override
  NearbyViewState createState() => NearbyViewState();
}

class NearbyViewState extends State<NearbyView> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<DataService>(context);
    Color backgroundColor = appState.getBackgroundColor();
    return new Container(
      color: backgroundColor,
    );
  }
}