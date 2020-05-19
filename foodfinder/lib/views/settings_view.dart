import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foodfinder/services/data_service.dart';


class SettingsView extends StatefulWidget {

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<DataService>(context);
    Color backgroundColor = appState.getBackgroundColor();
    Color textColor = appState.getTextColor();
    Color buttonColor = appState.getButtonColor();
    Color selectedColor = appState.getActiveIconColor();
    bool isDarkTheme = appState.darkTheme; 

    return new Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: backgroundColor,
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: 20
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Text(
                "App Settings",
                textAlign: TextAlign.left,
                style: new TextStyle(
                  fontSize: 19,
                  color: textColor
                )
              ),
              new Divider(
                thickness: 0.5,
                color: textColor,
              ),
              new ListTile(
                title: new Text(
                  "Dark Theme",
                  style: new TextStyle(
                    color: textColor
                  )
                ),
                trailing: new Checkbox(
                  value: isDarkTheme,
                  onChanged: (value) {
                    appState.changeTheme(!isDarkTheme);
                  },
                  checkColor: selectedColor,
                  activeColor: buttonColor,
                ),
                onTap: () {
                  appState.changeTheme(!isDarkTheme);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}