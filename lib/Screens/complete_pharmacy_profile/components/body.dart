import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/sign_up/components/ScreenArguments.dart';
import 'package:graduationproject/size_config.dart';
import 'package:graduationproject/constants.dart';

import 'complete_pharmacy_profile_form.dart';
class Body extends StatelessWidget {
  final ScreenArguments arguments;
  Body(this.arguments);

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
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text("Complete Profile", style: headingStyle),
                Text(
                  "Complete pharmacy details to continue",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                CompletePharmacyProfileForm(arguments),
                SizedBox(height: getProportionateScreenHeight(40)),
                Text(
                  "By submit your confirm that you agree \nwith our Term and Condition",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
