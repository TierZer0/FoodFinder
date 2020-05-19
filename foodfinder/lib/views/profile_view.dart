import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:foodfinder/services/data_service.dart';

import 'package:foodfinder/utils/custom_button.dart';
import 'package:foodfinder/utils/input_field.dart';

class ProfileView extends StatefulWidget {

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {

  @override
  void initState() {
    super.initState();
  }



  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<DataService>(context);
    bool isLoggedIn = appState.getIsLoggedIn();
    Color backgroundColor = appState.getBackgroundColor();
    Color elevatedBackgroundColor = appState.getBackgroundColorElevated();
    Color textColor = appState.getTextColor();
    Color secondaryColor = appState.getSecondaryColor();
    Color tertiaryColor = appState.getTertiaryColor(); 


    String username = appState.getUsername();

    return new Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: !isLoggedIn ? new NotLoggedIn(
        backgroundColor: backgroundColor,
        elevatedBackgroundColor: elevatedBackgroundColor,
        tertiaryColor: tertiaryColor,
        textColor: textColor,
        secondaryColor: secondaryColor,
        emailController: emailController,
        passwordController: passwordController,
        signIn: () {
          appState.signIn(
            emailController.text, 
            passwordController.text
          );
        },
        signUp: () {
          appState.createAccount(
            emailController.text, 
            passwordController.text
          );
        },
        googleSignIn: () {
          appState.googleSignIn();
        },
      )
      : new Container(
        color: backgroundColor,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 40,
                left: 20,
                bottom: 20
              ),
              child: new Text(
                username,
                style: new TextStyle(
                  color: tertiaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w500
                )
              ),
            )
          ],
        )
      )
    );
  }
}

class NotLoggedIn extends StatelessWidget {

  final Color backgroundColor;
  final Color elevatedBackgroundColor;
  final Color textColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback signIn;
  final VoidCallback signUp;
  final VoidCallback googleSignIn;

  NotLoggedIn(
    {
      this.backgroundColor,
      this.elevatedBackgroundColor,
      this.textColor,
      this.secondaryColor,
      this.tertiaryColor,
      this.emailController,
      this.passwordController,
      this.signIn,
      this.signUp,
      this.googleSignIn
    }
  );

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: backgroundColor,
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .12,
          horizontal: 20
        ),
        child: new Column(
          children: <Widget>[
            new Text(
              "FoodFinder",
              style: new TextStyle(
                color: tertiaryColor,
                fontSize: 50,
                fontWeight: FontWeight.w300
              )
            ),
            new Text(
              "By TierZero",
              style: new TextStyle(
                color: secondaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w500
              )
            ),
            new SizedBox(
              height: 30,
            ),
            new InputField(
              controller: emailController,
              hint: "Email",
              textColor: textColor,
              focusColor: secondaryColor,
              backgroundColor: elevatedBackgroundColor,
              obscure: false,
              isEleveated: true,
            ),
            new SizedBox(
              height: 20
            ),
            new InputField(
              controller: passwordController,
              hint: "Password",
              textColor: textColor,
              focusColor: secondaryColor,
              backgroundColor: elevatedBackgroundColor,
              obscure: true,
              isEleveated: true,
            ),
            new SizedBox(
              height: 20,
            ),
            new CustomButton(
              externalPadding: EdgeInsets.symmetric(
                horizontal: 45,
                vertical: 10
              ),
              internalPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10
              ),
              backgroundColor: secondaryColor,
              borderColor: secondaryColor,
              fontSize: 18,
              textColor: tertiaryColor,
              label: "Login",
              blurRadius: 5,
              onTap: signIn,
            ),
            new SizedBox(
              height: 5,
            ),
            new CustomButton(
              externalPadding: EdgeInsets.symmetric(
                horizontal: 65,
                vertical: 10
              ),
              internalPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10
              ),
              backgroundColor: backgroundColor,
              borderColor: secondaryColor,
              fontSize: 16,
              textColor: textColor,
              label: "Create Account",
              blurRadius: 0,
              onTap: signUp,
            ),
            new SizedBox(
              height: 40,
              child: new Center(
                child: new Text(
                  "- or -",
                  style: new TextStyle(
                    fontSize: 15,
                    color: textColor
                  )
                )
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Material(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      20
                    )
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: new IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.google,
                      size: 30,
                      color: textColor,
                    ),
                    onPressed: googleSignIn,
                  ),
                )
              ],
            )
          ],
        ),
      );
  }
}