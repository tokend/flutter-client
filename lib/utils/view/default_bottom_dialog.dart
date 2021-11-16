import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultBottomDialog extends StatelessWidget {
  final double radius;
  final double height;
  final Widget child;
  final Color color;

  const DefaultBottomDialog(this.child,
      {this.radius = 12.0, this.height = 0.9, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: new BoxDecoration(
        color: color,
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      child: child,
    );
  }
}