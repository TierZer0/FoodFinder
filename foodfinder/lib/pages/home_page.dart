import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodfinder/utils/input_field.dart';
import 'package:provider/provider.dart';

import 'package:foodfinder/services/data_service.dart';

import 'package:foodfinder/views/map_view.dart';
import 'package:foodfinder/views/nearby_view.dart';
import 'package:foodfinder/views/profile_view.dart';
import 'package:foodfinder/views/history_view.dart';
import 'package:foodfinder/views/settings_view.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }
  double distance = 5000 / 2;
  String convertToMiles(double val) {
    return (val / 1609).roundToDouble().toString();
  }
  double price = 2.0;


  List<Widget> pages = [
    new MapView(),
    new NearbyView(),
    new ProfileView(),
    new Container(),
    new HistoryView(),
    new SettingsView()
  ];
  int currentPage = 0;
  String currentPageName = "";
  BuildContext scaffoldContext;
  bool bottomSheetActive = false;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<DataService>(context);
    Color backgroundColor = appState.getBackgroundColor();
    Color elevatedBackgroundColor = appState.getBackgroundColorElevated();
    Color buttonColor = appState.getButtonColor();
    Color selectedColor = appState.getActiveIconColor();
    bool isDarkTheme = appState.darkTheme;
    Color textColor = appState.getTextColor();

    var currentLocation = appState.getCurrentLocation();

    isDarkTheme ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor:  elevatedBackgroundColor//new Color(0xFFEEF1F0)
    )) : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor:  elevatedBackgroundColor//new Color(0xFFEEF1F0)
    ));
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          pages[currentPage],
          new Builder(
            builder: (BuildContext context) {
              scaffoldContext = context;
              return new SizedBox();
            },
          )
        ],
      ),
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      bottomNavigationBar: new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: elevatedBackgroundColor,
        elevation: 5,
        selectedItemColor: isDarkTheme ? buttonColor : selectedColor,
        unselectedItemColor: textColor,
        currentIndex: currentPage < 3 ? currentPage : 3,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              size: 30,
            ),
            title: new Text(
              "Map"
            )
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              size: 30,
            ),
            title: new Text(
              "Nearby"
            )
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30,
            ),
            title: new Text(
              "Profile"
            )
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.dehaze,
              size: 30,
            ),
            title: new Text(
              currentPageName
            )
          )
        ],
        onTap: (int page) {
          if (page != 3) {
            if (bottomSheetActive) {
              bottomSheetActive = !bottomSheetActive;
              Navigator.of(context).pop();
            }
            setState(() {
              currentPage = page;
            });
          } else {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return new Container(
                  height: MediaQuery.of(context).size.height * .2,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0
                  ),
                  decoration: new BoxDecoration(
                    color: elevatedBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                    )
                  ),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new ListTile(
                        leading: Icon(
                          Icons.history,
                          color: textColor,
                        ),
                        title: new Text(
                          "History",
                          style: new TextStyle(
                            color: textColor,
                          )
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            currentPageName = "History";
                            currentPage = 4;
                          });
                        },
                      ),
                      new ListTile(
                        leading: Icon(
                          Icons.settings,
                          color: textColor,
                        ),
                        title: new Text(
                          "Settings",
                          style: new TextStyle(
                            color: textColor,
                          )
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            currentPageName = "Settings";
                            currentPage = 5;
                          });
                        },
                      )
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: currentPage == 0 ? new FloatingActionButton(
        backgroundColor: buttonColor,
        elevation: 3,
        child: new Center(
          child: Icon(
            Icons.search,
            size: 35,
            color: selectedColor,
          )
        ),
        onPressed: () {
          setState(() {
            bottomSheetActive = !bottomSheetActive;
          });
          showBottomSheet(
            context: scaffoldContext, 
            builder: (context) {
              return new Container(
                height: MediaQuery.of(context).size.height * .6,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0
                ),
                decoration: new BoxDecoration(
                  color: elevatedBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                  )
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 30
                ),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Text(
                      "Search For Restaurants",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        color: textColor,
                        fontSize: 18
                      ),
                    ),
                    new Divider(
                      thickness: 0.5,
                      color: textColor,
                      height: 40,
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Text(
                          "Type Of Food",
                          style: new TextStyle(
                            color: textColor,
                            fontSize: 16
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25
                          ),
                          child: new TextField(
                            controller: null,
                            cursorColor: buttonColor,                            
                            decoration: new InputDecoration(
                              focusColor: buttonColor,
                            ),
                          ),
                        ),
                        new SizedBox(
                          height: 20
                        ),
                        new Text(
                          "Search Distance",
                          style: new TextStyle(
                            color: textColor,
                            fontSize: 16
                          ),
                        ),
                        new StatefulBuilder(
                          builder: (context, setState) {
                            return new Slider(
                              value: distance,
                              onChanged: (value) {
                                setState(() {
                                  distance = value;
                                });
                              },
                              min: 100,
                              max: 5000,
                              divisions: 100,
                              label: convertToMiles(distance) + " Miles",
                              activeColor: selectedColor,
                              inactiveColor: Colors.black26,
                            );
                          }
                        ),
                        new SizedBox(
                          height: 20
                        ),
                        new Text(
                          "Price",
                          style: new TextStyle(
                            color: textColor,
                            fontSize: 16
                          ),
                        ),
                        new StatefulBuilder(
                          builder: (context, setState) {
                            return new Slider(
                              value: price,
                              onChanged: (value) {
                                setState(() {
                                  price = value;
                                });
                              },
                              min: 1,
                              max: 4,
                              divisions: 3,
                              label: price.round().toString(),
                              activeColor: selectedColor,
                              inactiveColor: Colors.black26,
                            );
                          }
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          );
        },
      ) : null,
      
    );
  }
}