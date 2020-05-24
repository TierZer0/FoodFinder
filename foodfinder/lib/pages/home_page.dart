import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodfinder/utils/custom_button.dart';
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

    ctrl.addListener(
      () {
        int next = ctrl.page.round();

        if (currentItem != next) {
          setState(() {
            currentItem = next;
          });
        }
      } 
    );
  }
  double distance = 5000 / 2;
  String convertToMiles(double val) {
    return (val / 1609).roundToDouble().toString();
  }
  double price = 2.0;
  double rating = 2.0;


  List<Widget> pages = [
    new MapView(),
    new NearbyView(),
    new ProfileView(),
    new Container(),
    new HistoryView(),
    new SettingsView()
  ];
  int currentPage = 0;
  int currentItem = 0;
  String currentPageName = "";
  BuildContext scaffoldContext;

  List list = [
    "test",
    "test",
    "test"
  ];
  final PageController ctrl = PageController(viewportFraction: 0.65);
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
          currentPage == 0 ? new Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: new Container(
              height: 255,
              //color: Colors.black12,
              child: list != null ? new PageView.builder(
                itemCount: list != null ? list.length : 3,
                controller: ctrl,
                itemBuilder: (context, int currentIndex) {
                  bool active = currentIndex == currentItem;
                  return _buildResults(list[currentIndex], active, elevatedBackgroundColor, textColor, context);
                },
              ) : new SizedBox(),
            ),
          ) : new SizedBox(),
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
            //Navigator.of(context).pop();
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
          showModalBottomSheet(
            context: scaffoldContext, 
            
            builder: (context) {
              return new Container(
                height: MediaQuery.of(context).size.height * .7,
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
                        new Container(
                          decoration: new BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                10
                              )
                            )
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 5
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5
                            ),
                            child: new TextField(
                              controller: null,
                              cursorColor: selectedColor, 
                              style: new TextStyle(
                                fontSize: 17
                              ),                           
                              decoration: new InputDecoration(
                                focusColor: selectedColor,
                                border: InputBorder.none
                              ),
                            ),
                          ),
                        ),
                        new SizedBox(
                          height: 30
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
                        ),
                        new SizedBox(
                          height: 20,
                        ),
                        new Text(
                          "Rating",
                          style: new TextStyle(
                            color: textColor,
                            fontSize: 16
                          )
                        ),
                        new StatefulBuilder(
                          builder: (context, setState) {
                            return new Slider(
                              value: rating,
                              onChanged: (value) {
                                setState(() {
                                  rating = value;
                                });
                              },
                              min: 1,
                              max: 5,
                              divisions: 4,
                              label: rating.round().toString(),
                              activeColor: selectedColor,
                              inactiveColor: Colors.black26,
                            );
                          },
                        ),
                        new SizedBox(
                          height: 30,
                        ),
                        new CustomButton(
                          externalPadding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 5
                          ),
                          internalPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10
                          ),
                          backgroundColor: buttonColor,
                          borderColor: Colors.transparent,
                          fontSize: 17,
                          textColor: textColor,
                          label: "Search",
                          blurRadius: 5,
                          onTap: () {

                          },
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

Widget _buildResults(String item, bool active, Color backgroundColor, Color textColor, BuildContext context) {
  final double blur = active ? 15 : 0;
  final double opacity = active ? 1 : 0;
  final double top = active ? 25 : 50;
  final double bottom = active ? 25 : 50;
  final double left = active ? 20 : 15;
  final double right = active ? 20 : 15;

  return new AnimatedContainer(
    duration: new Duration(
      milliseconds: 400
    ),
    decoration: new BoxDecoration(
      color: backgroundColor,
      boxShadow: [
        new BoxShadow(
          color: Colors.black26,
          blurRadius: blur
        )
      ],
      borderRadius: BorderRadius.all(
        Radius.circular(
          20
        )
      )
    ),
    margin: EdgeInsets.only(
      top: top,
      bottom: bottom,
      left: left,
      right: right
    ),
    child: new Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(
        Radius.circular(
          20
        )
      ),
      child: new InkWell(
        child: new Container(

        ),
        onTap: () {

        },
      ),
    ),
  );
}