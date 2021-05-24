import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/sign_up/components/ScreenArguments.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/providers/phone_auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';
import 'otp_form.dart';

class Body extends StatelessWidget {
  final ScreenArguments arguments;
  Body(this.arguments);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                "Verification Code",
                style: headingStyle,
              ),
              Text("We sent your code to ${arguments.phoneNo}"),
              buildTimer(),
              OtpForm(arguments: arguments,),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              GestureDetector(
                onTap: () {
                  // OTP code resend
                  Provider.of<PhoneAuthDataProvider>(context, listen: false).startAuth();
                },
                child: Text(
                  "Resend Verification Code",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 60.0, end: 0.0),
          duration: Duration(seconds: 60),
          builder: (_, value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }

}
