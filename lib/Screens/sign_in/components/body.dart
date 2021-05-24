import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/reminder/reminder_screen.dart';
import 'package:graduationproject/components/no_account_text.dart';
import 'package:graduationproject/components/no_pharmacy_account_text.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

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
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
            Image.asset(
              "assets/images/splash_1.png",
              height: SizeConfig.screenHeight * 0.2, //40%
            ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                SignForm(),

                NoAccountText(),
                NoPharmacyAccountText(),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                FloatingActionButton.extended(
                  elevation: 0.0,
                  shape: StadiumBorder(
                      side: BorderSide(color: Color(0xFF099F9D), width: 1)),
                  onPressed: () =>
                      Navigator.pushNamed(context, ReminderScreen.routeName),
                  label: const Text('Meds Reminder!',
                      style: TextStyle(color: Color(0xFF099F9D))),
                  icon:
                  const Icon(Icons.access_alarm, color: Color(0xFF099F9D)),
                  tooltip:
                  "To open the reminder without Sign in\nclick here !",
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
