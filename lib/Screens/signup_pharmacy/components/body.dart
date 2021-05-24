import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/signup_pharmacy/components/sign_up_pharmacy_form.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text("Request Account", style: headingStyle),
                Text(
                  "Complete your details to request pharmacy account",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignUpPharmacyForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  'By Continue your confirm that you agree \nwith our Term and Condition',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
