import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/userSettings.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/size_config.dart';
import 'components/body.dart' as body;

class ShowProfileScreen extends StatelessWidget {
  static String routeName = "/show_profile";
  @override
  Widget build(BuildContext context) {
    // final ScreenArguments args = ModalRoute.of(context).settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        EditProfileScreenDialog(),
                    fullscreenDialog: true,
                  ));
            },
            child: Container(
              alignment: Alignment.centerLeft,
              height: getProportionateScreenHeight(56),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.edit_outlined, size: 30.0,color: kPrimaryColor ,),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
        ],
      ),
      body: body.Body(),
    );
  }
}
