import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodfinderzero/ui/preferences_ui.dart';

class PreferencesItem extends StatelessWidget {

  String label;
  String fieldName;
  String uid;
  Color backgroundColor;
  Color backgroundTextColor;
  Color textColor;
  Color buttonColor;
  Color buttonTextColor;
  VoidCallback onTap;

  PreferencesItem(
    {
      this.label,
      this.fieldName,
      this.uid,
      this.backgroundColor,
      this.backgroundTextColor,
      this.textColor,
      this.buttonColor,
      this.buttonTextColor,
      this.onTap
    }
  );

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 120,
      color: Colors.transparent,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10
                ),
                child: new Text(
                  label,
                  style: new TextStyle(
                    fontSize: 17,
                    color: backgroundTextColor
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 10
                ),
                child: new GestureDetector(
                  child: new Text(
                    "Change",
                    style: new TextStyle(
                      fontSize: 15,
                      color: buttonColor
                    )
                  ),
                  onTap: onTap,
                ),
              )
            ],
          ),
          new SizedBox(
            height: 5,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                width: MediaQuery.of(context).size.width,
                height: 75,
                color: Colors.transparent,
                child: new StreamBuilder(
                  stream: Firestore.instance.collection('users').document(uid).collection(fieldName).snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return new Center(
                        child: new CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData) {
                      return new Center(
                        child: new Text(
                          "No preferences exists, click add to create preferences"
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return new ListView(
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 5
                        ),
                        children: snapshot.data.documents.map<Widget>((DocumentSnapshot item) {
                          return new Container(
                            // width: 75,
                            margin: EdgeInsets.symmetric(
                              horizontal: 5
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 12
                            ),
                            decoration: new BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20)
                              ),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5
                                )
                              ]
                            ),
                            child: new Center(
                              child: new Text(
                                item['pref'],
                                style: new TextStyle(
                                  fontSize: 15,
                                  color: textColor
                                )
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                )
              ),
            ],
          )
        ],
      ),
    );
  } 
}