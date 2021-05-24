import 'package:flutter/material.dart';
import 'package:graduationproject/size_config.dart';
import 'components/body.dart';

class LoadAppScreen extends StatelessWidget {
  static String routeName = "/load_app";

  LoadAppScreen();

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
