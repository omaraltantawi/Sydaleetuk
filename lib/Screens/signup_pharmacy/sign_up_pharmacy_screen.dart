import 'package:flutter/material.dart';

import 'components/body.dart';

class SignUpPharmacyScreen extends StatelessWidget {
  static String routeName = "/sign_up_pharmacy";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Account"),
      ),
      body: Body(),
    );
  }
}
