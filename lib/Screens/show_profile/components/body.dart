import 'package:flutter/material.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/data_models/Patient.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:graduationproject/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget with CanShowMessages{
  @override
  Widget build(BuildContext context) {
    Patient user = Provider.of<FireBaseAuth>(context, listen: true).patient;
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(25)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Profile", style: headingStyle),
                      // FloatingActionButton.extended(
                      //   elevation: 0.0,
                      //   shape: StadiumBorder(
                      //       side: BorderSide(color: Color(0xFF099F9D), width: 1)),
                      //   onPressed: () {/* Navigator.pushNamed(context, ),*/},
                      //   label: Padding(
                      //     padding: const EdgeInsets.only(top: 50.0,bottom: 50.0),
                      //     child: Column(
                      //       children: [
                      //         Text('Add Health State',
                      //             style: TextStyle(color: Color(0xFF099F9D))),
                      //         Text('(if Any)',
                      //             style: TextStyle(color: Color(0xFF099F9D))),
                      //       ],
                      //     ),
                      //   ),
                      //   tooltip:
                      //   "Add Health State",
                      //   backgroundColor: Colors.white,
                      // ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        elevation: 0.0,
                        shape: StadiumBorder(
                            side: BorderSide(color: Color(0xFF099F9D), width: 1)),
                        onPressed: () async {
                          // Navigator.push(context, new MaterialPageRoute(
                          //   builder: (BuildContext context) => _myDialog,
                          //   fullscreenDialog: true,
                          // ));
                          String text = await showInputDialog(context: context,title: 'Health State',defaultValue: user.healthState , textFieldLabelText: 'Health State' , textFieldHintText: 'Enter your health state' );
                          if ( text != null )
                            Provider.of<FireBaseAuth>(context,listen: false).updateHealthState(value: text);
                          print ( text );
                        },
                        label: Padding(
                          padding: const EdgeInsets.only(top: 50.0,bottom: 50.0),
                          child: Column(
                            children: [
                              Text('Add Health State',
                                  style: TextStyle(color: Color(0xFF099F9D))),
                              Text('(if Any)',
                                  style: TextStyle(color: Color(0xFF099F9D))),
                            ],
                          ),
                        ),
                        tooltip:
                        "Add Health State",
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                  // Text("Profile", style: headingStyle),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Text(
                    "Name",
                    style: textHeadStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Text(
                    '${user.fName} ${user.lName}',
                    style: textBodyStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Text(
                    "Address",
                    style: textHeadStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Text(
                    '${user.address}',
                    style: textBodyStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Text(
                    "Date of Birth",
                    style: textHeadStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Text(
                    '${DateFormat("dd/MM/yyyy").format(user.birthDate)}',
                    style: textBodyStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Text(
                    "Gender",
                    style: textHeadStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Text(
                    '${user.gender}',
                    style: textBodyStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Text(
                    "Email",
                    style: textHeadStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Text(
                    '${user.email}',
                    style: textBodyStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Text(
                    "Phone Number",
                    style: textHeadStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Text(
                    '${user.phoneNo}',
                    style: textBodyStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
