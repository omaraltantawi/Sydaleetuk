import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/signup_pharmacy/sign_up_pharmacy_screen.dart';
import '../constants.dart';
import '../size_config.dart';

class NoPharmacyAccountText extends StatelessWidget {
  const NoPharmacyAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Are you Pharmacy Manager? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpPharmacyScreen.routeName),
          child: Text(
            "Request",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
