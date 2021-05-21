import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/order_success/components/arguments.dart';

import 'components/body.dart';

class OrderSuccessScreen extends StatelessWidget {
  static String routeName = "/order_success";

  @override
  Widget build(BuildContext context) {
    final Arguments args = ModalRoute.of(context).settings.arguments as Arguments;
    return Scaffold(
      appBar: AppBar(
        // leading: SizedBox(),
      ),
      body: Body(args: args,),
    );
  }
}
