import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String hinttext ;
  final Color color ;
  final Function onChangedFun ;

  RoundedTextField({this.color,this.hinttext,@required this.onChangedFun});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: this.onChangedFun ,
      decoration: InputDecoration(
        hintText: this.hinttext,
        contentPadding:
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: this.color, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: this.color, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}