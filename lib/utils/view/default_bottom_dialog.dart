import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultBottomDialog extends StatefulWidget {
  final double radius;
  final double height;
  final Widget child;
  final Color color;

  const DefaultBottomDialog(this.child,
      {this.radius = 12.0, this.height = 0.9, this.color = Colors.white});

  @override
  State<StatefulWidget> createState() => DefaultBottomDialogState();
}

class DefaultBottomDialogState extends State<DefaultBottomDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: new BoxDecoration(
        color: widget.color,
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(widget.radius),
          topRight: Radius.circular(widget.radius),
        ),
      ),
      child: widget.child,
    );
  }
}
