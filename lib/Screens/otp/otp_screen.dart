import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/sign_up/components/ScreenArguments.dart';
import 'package:graduationproject/size_config.dart';
import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";
  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments as ScreenArguments;

    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Verification"),
      ),
      body: Body(args),
    );
  }
}
