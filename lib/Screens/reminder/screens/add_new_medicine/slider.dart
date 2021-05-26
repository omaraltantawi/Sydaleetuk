
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/reminder/helpers/platform_slider.dart';


class UserSlider extends StatelessWidget {
  final Function handler;
  final int howManyWeeks;
  UserSlider(this.handler,this.howManyWeeks);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: PlatformSlider(
              divisions: 30,
              min: 1,
              // max = 30 (or whatever you want if you make it to days
              max: 30,
              value: howManyWeeks,
              color: Theme.of(context).primaryColor,
              handler:  this.handler,)),
      ],
    );
  }
}
