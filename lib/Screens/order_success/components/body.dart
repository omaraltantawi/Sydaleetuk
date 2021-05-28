import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/UserOrders.dart';
import 'package:graduationproject/Screens/home/home_screen.dart';
import 'package:graduationproject/Screens/order_success/components/arguments.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/size_config.dart';

class Body extends StatelessWidget {

  final Arguments args ;

  Body({this.args});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          Image.asset(
            "assets/images/success.png",
            height: SizeConfig.screenHeight * 0.25, //40%
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          Text(
            "Your order sent successfully to",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            "\"${args.pharmacyName}\" Pharmacy.",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.08),
          SizedBox(
            width: SizeConfig.screenWidth * 0.6,
            child: DefaultButton(
              text: "My Orders",
              press: () {
                // Navigator.pu(context, HomeScreen.routeName);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(UserOrders.routeName, ModalRoute.withName(HomeScreen.routeName));
              },
            ),
          ),
          // SizedBox(
          //   width: SizeConfig.screenWidth * 0.6,
          //   child: DefaultButton(
          //     text: "Back to home",
          //     press: () {
          //       // Navigator.pu(context, HomeScreen.routeName);
          //       Navigator.of(context)
          //           .pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);
          //     },
          //   ),
          // ),
          // Spacer(),
        ],
      ),
    );
  }
}
