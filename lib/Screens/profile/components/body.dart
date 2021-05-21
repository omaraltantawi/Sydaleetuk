import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/sign_in/sign_in_screen.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:provider/provider.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Medicines Reminder",
            icon: "assets/icons/alarm clock 1.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () { Provider.of<FireBaseAuth>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false);},
          ),
        ],
      ),
    );
  }
}
