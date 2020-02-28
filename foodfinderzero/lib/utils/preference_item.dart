import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          new SizedBox(
            height: 5,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                width: MediaQuery.of(context).size.width * .85,
                height: 75,
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
              new Container(
                width: 60,
                height: 50,
                decoration: new BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)
                  ),
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset.zero
                    )
                  ]
                ),
                child: new Material(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)
                  ),
                  color: Colors.transparent,
                  child: new InkWell(
                    splashColor: Colors.white54,
                    child: new Center(
                      child: new Icon(
                        Icons.add,
                        size: 40,
                        color: buttonTextColor
                      ),
                    ),
                    onTap: onTap
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  } 
}