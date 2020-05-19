import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {

  String label;
  double fontSize;
  double opacity;
  Color color;
  VoidCallback onTap;
  double width;

  NavigationItem(
    {
      this.label,
      this.fontSize,
      this.opacity,
      this.color,
      this.width,
      this.onTap
    }
  );

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 50,
      width: width,
      child: new Material(
        child: new InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: new Center(
            child: new AnimatedOpacity(
              duration: new Duration(milliseconds: 200),
              opacity: opacity,
              child: new Text(
                label,
                style: new TextStyle(
                  fontSize: fontSize,
                  color: color
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}