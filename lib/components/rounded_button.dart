import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;

  final String text;

  final Function onPressFun;

  RoundedButton({this.text, this.color, @required this.onPressFun});

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: this.color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: this.onPressFun,
          minWidth: 200.0,
          height: 50.0,
          child: Text(
            this.text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
