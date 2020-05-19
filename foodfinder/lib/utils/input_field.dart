import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  TextEditingController controller;
  String hint;
  Color textColor;
  Color focusColor;
  Color backgroundColor;
  bool obscure;
  bool isEleveated;

  InputField(
    {
      this.controller,
      this.hint,
      this.textColor,
      this.focusColor,
      this.backgroundColor,
      this.obscure,
      this.isEleveated
    }
  );

  

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return new AnimatedContainer(
          duration: new Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          height: 90,
          decoration: new BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(
                20
              )
            ),
            boxShadow: [
              isEleveated ? new BoxShadow(
                blurRadius: 5,
                color: Colors.black26
              ) : new BoxShadow(
                blurRadius: 0,
                color: Colors.transparent              
              )
            ]
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10
          ),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Text(
                hint,
                textAlign: TextAlign.start,
                style: new TextStyle(
                  color: textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w700
                )
              ),
              new TextField(
                controller: controller,
                obscureText: obscure,
                style: new TextStyle(
                  color: textColor,
                  fontSize: 17
                ),
                cursorColor: focusColor,
                decoration: new InputDecoration(
                  hintText: hint,
                  focusedBorder: InputBorder.none,
                  hintStyle: new TextStyle(
                    fontSize: 17,
                    color: textColor
                  ),
                  alignLabelWithHint: true,
                  focusColor: focusColor,
                  border: InputBorder.none
                )
              ),
            ],
          )
        );
      }
    );
  }
}