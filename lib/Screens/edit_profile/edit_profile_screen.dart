import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/sign_up/components/ScreenArguments.dart';

import 'components/body.dart';

class EditProfileScreen extends StatelessWidget {
  static String routeName = "/edit_profile";
  @override
  Widget build(BuildContext context) {
    // final ScreenArguments args = ModalRoute.of(context).settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      body: Body(),
    );
  }
}
