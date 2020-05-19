import 'package:flutter/material.dart';
import 'package:foodfinderzero/services/data.dart';
import 'package:foodfinderzero/utils/custom_button.dart';
import 'package:foodfinderzero/utils/input_field.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreferencesView extends StatefulWidget {

  final String uid;
  final String label;
  final String fieldName;
  final Color textColor;
  final Color textColorOnPrimary;
  final Color primaryColor;
  final Color elevatedBackgroundColor;
  final Color backgroundColor;

  PreferencesView(
    {
      Key key,
      this.uid,
      this.fieldName,
      this.label,
      this.textColor, 
      this.textColorOnPrimary,
      this.primaryColor,
      this.elevatedBackgroundColor,
      this.backgroundColor
    }
  ) : super(key: key);

  @override
  PreferencesViewState createState() => PreferencesViewState();
}

class PreferencesViewState extends State<PreferencesView> {

  @override
  void initState() {
    super.initState();
  }

  final preferenceController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        elevation: 4,
        backgroundColor: widget.primaryColor,
        title: new Text(
          widget.label + " Preferences",
          style: new TextStyle(
            color: widget.textColorOnPrimary
          )
        ),
        leading: new IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: widget.textColorOnPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: new Container(
        color: widget.backgroundColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new StreamBuilder(
          stream: Firestore.instance.collection('users').document(widget.uid).collection(widget.fieldName).snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return new Center(
                child: new CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return new ListView(
                shrinkWrap: true,
                children: snapshot.data.documents.map<Widget>((DocumentSnapshot item) {
                  return new ListTile(
                    
                    leading: new Material(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40)
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: new IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 30,
                          color: widget.textColor,
                        ), 
                        onPressed: () {
                          
                        }
                      ),
                    ),
                    title: new Text(
                      item['pref'],
                      style: new TextStyle(
                        color: widget.textColor
                      ),
                    ),
                    trailing: new Material(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40)
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: new IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 30,
                          color: widget.elevatedBackgroundColor,
                        ),
                        onPressed: () {

                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        )
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: widget.primaryColor,
        child: new Icon(
          Icons.add
        ),
        onPressed: () {
          showModalBottomSheet(
            elevation: 0,
            isDismissible: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => new Container(
              margin: EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).size.height * .4
              ),
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10
              ),
              height: 200,
              decoration: new BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20
                  )
                )
              ),
              child: new Column(
                children: <Widget>[
                  new InputField(
                    height: 40,
                    backgroundColor: widget.elevatedBackgroundColor,
                    hint: "New Preference",
                    focusColor: widget.primaryColor,
                    textColor: widget.textColor,
                    controller: preferenceController,
                    obscure: false,
                    keyboard: TextInputType.text,
                  ),
                  new SizedBox(
                    height: 15
                  ),
                  new CustomButton(
                    externalPadding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10
                    ),
                    buttonColor: widget.primaryColor,
                    shadowColor: Colors.black12,
                    blurRadius: 6,
                    buttonWidth: 250,
                    internalPadding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10
                    ),
                    label: "Add Preference",
                    labelColor: widget.textColorOnPrimary,
                    labelSize: 20,
                    onTap: () {
                      dataService.addPreference(
                        widget.fieldName, 
                        preferenceController.text
                      );
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )
          );
        },
      ),
    );
  }
}