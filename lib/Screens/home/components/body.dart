import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'home_header.dart';
import 'menu_page.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(30)),
            HomeHeader(),
            SizedBox(height: getProportionateScreenWidth(30)),
            Menu_Page(),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}
