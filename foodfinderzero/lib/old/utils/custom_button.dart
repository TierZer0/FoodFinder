import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  EdgeInsetsGeometry externalPadding;
  Color buttonColor;
  Color shadowColor;
  double blurRadius;
  VoidCallback onTap;
  double buttonWidth;
  EdgeInsetsGeometry internalPadding;
  String label;
  double labelSize;
  Color labelColor;

  CustomButton(
    {
      this.externalPadding,
      this.buttonColor,
      this.shadowColor,
      this.blurRadius,
      this.onTap,
      this.buttonWidth,
      this.internalPadding,
      this.label,
      this.labelSize,
      this.labelColor
    }
  );

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: externalPadding,
      child: new Container(
        decoration: new BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10
            )
          ),
          boxShadow: [
            new BoxShadow(
              color: shadowColor,
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
              width: buttonWidth,
              child: new Padding(
                padding: internalPadding,
                child: new Text(
                  label,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: labelSize,
                    color: labelColor
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}