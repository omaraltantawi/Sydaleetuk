import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/userCartScreen.dart';
import 'package:graduationproject/data_models/Patient.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:provider/provider.dart';
import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Patient patient = Provider.of<FireBaseAuth>(context, listen: true).patient;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(),
          if ( patient != null )
          StreamBuilder(
            stream:
              FirebaseFirestore.instance
                .collection('PATIENT')
                .doc(patient.patientId)
                .collection('Cart')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return IconBtnWithCounter(
                  numOfitem: snapshot.data.docs.length,
                  svgSrc: "assets/icons/Cart Icon.svg",
                  press: () {
                    Navigator.pushNamed(context, UserCartScreen.routeName);
                  },
                );
              } else {
                return IconBtnWithCounter(
                  svgSrc: "assets/icons/Cart Icon.svg",
                  press: () {
                    Navigator.pushNamed(context, UserCartScreen.routeName);
                  },
                );
              }
            }
          ),
          if ( patient == null )
            IconBtnWithCounter(
              svgSrc: "assets/icons/Cart Icon.svg",
              press: () {
                Navigator.pushNamed(context, UserCartScreen.routeName);
              },
            )
          // IconBtnWithCounter(
          //   svgSrc: "assets/icons/Bell.svg",
          //   numOfitem: 3,
          //   press: () {},
          // ),
        ],
      ),
    );
  }
}
