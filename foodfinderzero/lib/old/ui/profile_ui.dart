import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodfinderzero/services/data.dart';
import 'package:foodfinderzero/ui/preferences_ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../services/auth.dart';

import '../utils/input_field.dart';
import '../utils/navigation_item.dart';
import '../utils/custom_button.dart';
import '../utils/preference_item.dart';

class ProfileView extends StatefulWidget {

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {

  bool isLoggedIn;
  bool darkTheme;
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  @override
  void initState() {
    super.initState();

  
    authService.isLoggedIn().then(
      (value) {
        setState(() {
          value != true ? value = false : value = true;
          isLoggedIn = value;
        });
        getUserName();
        getUserId();
      }
    );

    //darkTheme = dataService.darkTheme;
    
  }

  int _selectedIndex = 0;

  String username;
  getUserName() {
    authService.getUserName().then(
      (result) {
        setState(() {
          username = result;
        });
      }
    );
  }

  String uid;
  getUserId() {
    authService.getUserId().then(
      (result) {
        setState(() {
          uid = result;
        });
      }
    );
  }

  final primaryColor = new Color(0xFF1de9b6);
  final darkColor = new Color(0xFF263238);
  final whiteColor = new Color(0xFFF8F8F9);
  Duration _duration = new Duration(milliseconds: 500);
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<DataService>(context);
    setState(() {
      darkTheme = appState.darkTheme;
    });
    Color textColorOnPrimary = appState.getTextColorOnPrimaryColor();
    Color textColor = appState.getTextColor();
    Color elevatedBackgroundColor = appState.getElevatedBackgroundColor();
    Color backgroundColor = appState.getBackgroundColor();

    return new Container(
      constraints: BoxConstraints.expand(),
      //clipBehavior: Clip.antiAlias,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            40
          ),
          bottomRight: Radius.circular(
            40
          )
        ),
        // color: Colors.amberAccent,
      ),
      child: isLoggedIn != true ? new AnimatedOpacity(
        opacity: isLoggedIn == false ? 1 : 0,
        duration: _duration,
        child: new Material(
          //color: Colors.amberAccent,
          clipBehavior: Clip.antiAlias,
          child: new Container(
            width: MediaQuery.of(context).size.width,
            child: new Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .15,
                left: 30,
                right: 30
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Food Finder",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontSize: 33,
                      color: textColor
                    ),
                  ),
                  new Text(
                    "By TierZero",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontSize: 15,
                      color: textColor
                    )
                  ),
                  new Padding(
                    padding: EdgeInsets.only(
                      top: 30,
                      left: 30,
                      right: 30
                    ),
                    child: new InputField(
                      height: 40,
                      backgroundColor: elevatedBackgroundColor,
                      hint: "Email",
                      focusColor: primaryColor,
                      textColor: textColor,
                      obscure: false,
                      controller: emailController,
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 30,
                      right: 30
                    ),
                    child: new InputField(
                      height: 40,
                      backgroundColor: elevatedBackgroundColor,
                      hint: "Password",
                      focusColor: primaryColor,
                      textColor: textColor,
                      obscure: true,
                      controller: passwordController,
                    ),
                  ),
                  new CustomButton(
                    externalPadding: EdgeInsets.symmetric(
                      vertical: 30
                    ),
                    buttonColor: primaryColor,
                    shadowColor: Colors.black38,
                    buttonWidth: 125,
                    internalPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10
                    ),
                    label: "Login",
                    labelColor: textColorOnPrimary,
                    labelSize: 19,
                    blurRadius: 6,
                    onTap: () {
                      authService.signIn(emailController.text, passwordController.text).then(
                        (response) {
                          setState(() {
                            isLoggedIn = authService.isLoggedIn();
                          });
                        }
                      );
                    },
                  ),
                  new CustomButton(
                    externalPadding: EdgeInsets.symmetric(
                      vertical: 0,
                    ),
                    buttonColor: elevatedBackgroundColor,
                    shadowColor: Colors.black38,
                    blurRadius: 5,
                    buttonWidth: 150,
                    internalPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10
                    ),
                    label: "Create Account",
                    labelColor: textColor,
                    labelSize: 16,
                    onTap: () {
                      authService.signUp(emailController.text, passwordController.text).then(
                        (response) {
                          setState(() {
                            isLoggedIn = authService.isLoggedIn();
                          });
                          getUserName();
                        }
                      );
                    },
                  ),
                  new SizedBox(
                    height: 30,
                  ),
                  new Text(
                    "or Login with",
                    style: new TextStyle(
                      fontSize: 17,
                      color: textColor
                    )
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new IconButton(
                        icon: new Icon(
                          FontAwesomeIcons.google,
                          color: textColor,
                        ),
                        onPressed: () {
                          authService.googleSignIn().then(
                            (response) {
                              authService.isLoggedIn().then(
                                (response) {
                                  setState(() {
                                    isLoggedIn = response;
                                  });
                                }
                              );
                              getUserName();
                            }
                          );
                        },
                        iconSize: 30,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ) : new AnimatedOpacity(
        opacity: isLoggedIn == true ? 1 : 0,
        duration: _duration,
        child: new Material(
          // decoration: new BoxDecoration(

          // ),
          //clipBehavior: Clip.antiAlias,
          child: new SafeArea(
            top: true,
            child: new Container(
              height: MediaQuery.of(context).size.height,
              constraints: BoxConstraints.expand(),
              width: MediaQuery.of(context).size.width,
              child: new Stack(
                children: <Widget>[
                  new Positioned(
                    top: 25,
                    left: 10,
                    child: new Text(
                      "Food Finder",
                      style: new TextStyle(
                        fontSize: 31,
                        color: textColor
                      )
                    ),
                  ),
                  new Positioned(
                    top: 75,
                    left: 0,
                    child: new Container(
                      width: MediaQuery.of(context).size.width,
                      height: 125,
                      decoration: new BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)
                        ),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black38,
                            blurRadius: 7
                          )
                        ]
                      ),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  left: 13
                                ),
                                child: new Text(
                                  username,
                                  style: new TextStyle(
                                    color: textColorOnPrimary,
                                    fontSize: 25
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              )
                            ],
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new SizedBox(
                                width: 10
                              ),
                              new NavigationItem(
                                label: "Preferences",
                                fontSize: _selectedIndex == 0 ? 19 : 18,
                                opacity: _selectedIndex == 0 ? 1 : .69,
                                color: textColorOnPrimary,
                                width: 115,
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 0;
                                  });
                                },
                              ),
                              new NavigationItem(
                                label: "History",
                                fontSize: _selectedIndex == 1 ? 19 : 18,
                                opacity: _selectedIndex == 1 ? 1 : .69,
                                color: textColorOnPrimary,
                                width: 110,
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 1;
                                  });
                                },
                              ),
                              new NavigationItem(
                                label: "Settings",
                                fontSize: _selectedIndex == 2 ? 19 : 18,
                                opacity: _selectedIndex == 2 ? 1 : 0.69,
                                color: textColorOnPrimary,
                                width: 110,
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 2;
                                  });
                                },
                              ),
                              new SizedBox(
                                width: 10
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  _selectedIndex == 0 ? new Positioned(
                      top: 210,
                      left: 0,
                      right: 0,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new PreferencesItem(
                            label: "Category",
                            fieldName: "foodTypes",
                            uid: uid,
                            backgroundColor: elevatedBackgroundColor,
                            backgroundTextColor: textColor,
                            textColor: textColor,
                            buttonColor: primaryColor,
                            buttonTextColor: textColorOnPrimary,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => new PreferencesView(
                                    uid: uid,
                                    label: "Category",
                                    fieldName: "foodTypes",
                                    primaryColor: primaryColor,
                                    textColor: textColor,
                                    textColorOnPrimary: textColorOnPrimary,
                                    elevatedBackgroundColor: elevatedBackgroundColor,
                                    backgroundColor: backgroundColor
                                  )
                                )
                              );
                            },
                          ),
                          new PreferencesItem(
                            label: "Prices",
                            fieldName: "prices",
                            uid: uid,
                            backgroundColor: elevatedBackgroundColor,
                            backgroundTextColor: textColor,
                            textColor: textColor,
                            buttonColor: primaryColor,
                            buttonTextColor: textColorOnPrimary,
                            onTap: () {

                            },
                          )
                        ],
                      ),
                    ) 
                    : _selectedIndex == 1 ? new Positioned(
                      top: 200,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: new StreamBuilder(
                        stream: Firestore.instance.collection('users').document(uid).collection('history').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return new Center(
                              child: new CircularProgressIndicator(),
                            );
                          } else if (!snapshot.hasData) {
                            return new Center(
                              child: new Text(
                                "No Restaurants in History"
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return new Container(
                              constraints: BoxConstraints.expand(),
                              height: MediaQuery.of(context).size.height,
                              child: new ListView(

                                shrinkWrap: true,
                                children: snapshot.data.documents.map<Widget>((DocumentSnapshot item) {
                                  return new Container(
                                    height: 100,
                                    color: Colors.black12,
                                    margin: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 10
                                    ),
                                    child: new Row(
                                      children: <Widget>[
                                        item['image'] != null ? new Image(
                                          image: new NetworkImage(
                                            item['image'],
                                          ),
                                        )
                                        : new SizedBox(
                                          width: 50
                                        ),
                                        new Column(
                                          
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          } else {
                            return new SizedBox(

                            );
                          }
                        },
                      ),
                    ) 
                    : new Positioned(
                      top: 210,
                      left: 0,
                      right: 0,
                      child: new Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10
                        ),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Text(
                              "Profile",
                              style: new TextStyle(
                                fontSize: 17,
                                color: textColor
                              ),
                              textAlign: TextAlign.left,
                            ),
                            new Divider(
                              thickness: .5,
                              color: textColor,
                            ),
                            new Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                      "Logout",
                                      style: new TextStyle(
                                        fontSize: 16,
                                        color: textColor
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    new IconButton(
                                      icon: new Icon(
                                        Icons.exit_to_app
                                      ),
                                      color: textColor,
                                      onPressed: () {
                                        authService.signOut();
                                        authService.isLoggedIn().then(
                                          (result) {
                                            setState(() {
                                              isLoggedIn = result;
                                            });
                                          }
                                        );
                                      },
                                    )
                                  ],
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                      "Dark Theme",
                                      style: new TextStyle(
                                        fontSize: 16,
                                        color: textColor
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    new Checkbox(
                                      checkColor: darkColor,
                                      value: darkTheme,
                                      activeColor: primaryColor,
                                      onChanged: (result) {
                                        appState.setDarkTheme(result);
                                        setState(() {
                                          darkTheme = result;
                                        });
                                      }
                                    )
                                  ],
                                )
                              ],
                            ),
                            new Text(
                              "Application",
                              style: new TextStyle(
                                fontSize: 17,
                                color: textColor
                              ),
                              textAlign: TextAlign.left,
                            ),
                            new Divider(
                              thickness: .5,
                              color: textColor
                            ),
                            
                          ],
                        ),
                      ),
                    )
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
