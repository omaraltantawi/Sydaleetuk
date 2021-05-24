import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/sign_up/components/ScreenArguments.dart';

import 'components/body.dart';

class CompletePharmacyProfileScreen extends StatelessWidget {
  static String routeName = "/complete_pharmacy_profile";
  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Request'),
      ),
      body: Body(args),
    );
  }
}
