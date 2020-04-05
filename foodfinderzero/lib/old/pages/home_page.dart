import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodfinderzero/services/data.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../services/auth.dart';

import '../utils/navigation_item.dart';

import '../ui/map_ui.dart';
import '../ui/profile_ui.dart';
import '../ui/list_ui.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  
  
  bool darkTheme;
  @override
  void initState() {
    super.initState();
  }
  double _contentHeight = Platform.isIOS ? 0.91 : 0.95;

  int _selectedViewIndex = 1;
  List<Widget> views = [
    ProfileView(),
    MapView(),
    NearbyView()
  ];

  final primaryColor = new Color(0xFF1de9b6);
  final darkColor = new Color(0xFF263238);
  final whiteColor = new Color(0xFFF8F8F9);
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<DataService>(context);
    Color textColorOnPrimary = appState.getTextColorOnPrimaryColor();
    Color textColor = appState.getTextColor();
    Color elevatedBackgroundColor = appState.getElevatedBackgroundColor();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: primaryColor
    ));
    return new Stack(
      children: <Widget>[
        new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: primaryColor,
          child: new Stack(
            children: <Widget>[
              new AnimatedPositioned(
                duration: new Duration(milliseconds: 400),
                bottom: 0,
                left: 0,
                right: 0,
                child: new SafeArea(
                  bottom: true,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new NavigationItem(
                        label: "Profile",
                        opacity: _selectedViewIndex == 0 ? 1 : .69,
                        fontSize: _selectedViewIndex == 0 ? 25 : 22,
                        color: textColorOnPrimary,
                        width: 100,
                        onTap: () {
                          setState(() {
                            _selectedViewIndex = 0;
                            _contentHeight = Platform.isAndroid == true ? 0.95 : 0.91;
                          });
                        },
                      ),
                      new NavigationItem(
                        label: "Map",
                        opacity: _selectedViewIndex == 1 ? 1 : .69,
                        fontSize: _selectedViewIndex == 1 ? 25 : 22,
                        color: textColorOnPrimary,
                        width: 100,
                        onTap: () {
                          setState(() {
                            _selectedViewIndex = 1;
                            _contentHeight = Platform.isAndroid == true ? 0.95 : 0.91;
                          });
                        },
                      ),
                      new NavigationItem(
                        label: "List",
                        opacity: _selectedViewIndex == 2 ? 1 : .69,
                        fontSize: _selectedViewIndex == 2 ? 25 : 22,
                        color: textColorOnPrimary,
                        width: 100,
                        onTap: () {
                          setState(() {
                            _selectedViewIndex = 2;
                            _contentHeight = Platform.isAndroid == true ? 0.95 : 0.91;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        new AnimatedContainer(
          duration: new Duration(milliseconds: 500),
          height: MediaQuery.of(context).size.height * _contentHeight,
          decoration: new BoxDecoration(
            color: appState.getBackgroundColor(),
            borderRadius: new BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)
            ),
            boxShadow: [
              new BoxShadow(
                color: Colors.black45,
                offset: Offset.zero,
                blurRadius: 10
              )
            ]
          ),
          child: new Container(
            //clipBehavior: Clip.antiAlias,
            child: views[_selectedViewIndex],
            constraints: BoxConstraints.expand(),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)
              )
            ),
          ),
        ),
      ],
    );
  }
}