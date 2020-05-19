import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  EdgeInsets externalPadding;
  EdgeInsets internalPadding;
  Color backgroundColor;
  Color borderColor;
  VoidCallback onTap;
  double fontSize;
  Color textColor;
  String label;
  double blurRadius;

  CustomButton(
    {
      this.externalPadding,
      this.internalPadding,
      this.backgroundColor,
      this.borderColor,
      this.onTap,
      this.fontSize,
      this.textColor,
      this.label,
      this.blurRadius
    }
  );


  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: externalPadding,
      child: new Container(
        decoration: new BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10
            )
          ),
          border: Border.all(
            width: borderColor == backgroundColor ? 0 : 2,
            color: borderColor
          ),
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              blurRadius: blurRadius
            )
          ]
        ),
        child: new Material(
          borderRadius: BorderRadius.all(
            Radius.circular(
              10
            )
          ),
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: new InkWell(
            onTap: onTap,
            child: new Container(
              padding: internalPadding,
              child: new Center(
                child: new Text(
                  label,
                  style: new TextStyle(
                    fontSize: fontSize,
                    color: textColor
                  )
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}