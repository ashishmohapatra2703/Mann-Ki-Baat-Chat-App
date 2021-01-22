import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color buttoncolour;
  final String buttontitle;
  final Function onPressedAct;

  RoundedButton(
      {this.buttoncolour, this.buttontitle, @required this.onPressedAct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttoncolour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressedAct,
          height: 65.0,
          child: Text(buttontitle, textScaleFactor: 1.2),
        ),
      ),
    );
  }
}
