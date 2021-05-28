import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduationproject/Screens/home/home_screen.dart';
import 'package:graduationproject/Screens/profile/profile_screen.dart';
import 'package:graduationproject/Screens/reminder/reminder_screen.dart';


import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, HomeScreen.routeName),
                icon: SvgPicture.asset(
                  "assets/icons/Home Icon.svg",
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),

              ),
              // IconButton(
              //   icon: SvgPicture.asset("assets/icons/Heart Icon.svg"),
              //   onPressed: () {},
              // ),
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, ReminderScreen.routeName),
                icon: SvgPicture.asset("assets/icons/alarm clock.svg"),
                color: MenuState.reminder == selectedMenu
                    ? kPrimaryColor
                    : inActiveIconColor,
              ),
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, ProfileScreen.routeName),
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  color: MenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),

              ),
            ],
          )),
    );
  }
}
