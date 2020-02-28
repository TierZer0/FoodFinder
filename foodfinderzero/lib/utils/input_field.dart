import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  double height;
  Color backgroundColor;
  String hint;
  Color focusColor;
  TextEditingController controller;
  Color textColor;
  bool obscure;
  TextInputType keyboard;

  InputField(
    {
      this.height,
      this.backgroundColor,
      this.hint,
      this.focusColor,
      this.textColor,
      this.controller,
      this.obscure,
      this.keyboard
    }
  );

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: height,
      decoration: new BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          new BoxShadow(
            color: Colors.black26,
            blurRadius: 4
          )
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(
            10
          )
        )
      ),
      child: new Padding(
        padding: EdgeInsets.only(
          top: 18,
          left: 15,
          right: 15,
          bottom: 5
        ),
        child: new TextField(
          keyboardType: keyboard,
          style: new TextStyle(
            fontSize: 16,
            color: textColor
          ),
          controller: controller,
          obscureText: obscure,
          decoration: new InputDecoration(
            hintText: hint,
            focusedBorder: InputBorder.none,
            hintStyle: new TextStyle(
              fontSize: 16,
              color: textColor
            ),
            alignLabelWithHint: true,
            focusColor: focusColor,
            border: InputBorder.none
          ),
        ),
      ),
    );
  }
}