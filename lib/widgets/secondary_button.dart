import 'package:flutter/material.dart';

class SecondaryButton extends StatefulWidget {
  final btnText;
  SecondaryButton({this.btnText});
  @override
  _SecondaryButtonState createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).buttonColor,
            width: 2,
          )),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(
            color: Theme.of(context).buttonColor,
          ),
        ),
      ),
    );
  }
}
