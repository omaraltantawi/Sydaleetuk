import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart' as loca;
import 'package:graduationproject/Screens/sign_up/components/ScreenArguments.dart';
import 'package:graduationproject/ServiceClasses/Location.dart';
import 'package:graduationproject/ServiceClasses/SignInMethods.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/custom_surfix_icon.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/components/form_error.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/screens/complete_profile/complete_profile_screen.dart';
import 'package:nominatim_location_picker/nominatim_location_picker.dart';

import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../size_config.dart';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> with CanShowMessages {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String conform_password;
  bool remember = false;
  final List<String> errors = [];
  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }
  bool isLoading = false ;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          if ( !isLoading )
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                setState(() {
                  isLoading = true;
                });
                // if all are valid then go to success screen
                // Provider.of<FireBaseAuth>(context,listen: false).signUpNormalUser(email, password).then((value) {
                //   Navigator.pushNamed(context, CompleteProfileScreen.routeName,arguments: ScreenArguments(email: email,password: password),);
                // }).catchError((e){
                //   var msgTxt = ['Something went wrong.', 'Please try again'];
                //   switch (e.code) {
                //     case 'invalid-email':
                //       msgTxt = ['This is not a valid email address.'];
                //       break;
                //     case 'email-already-in-use':
                //       msgTxt = ['This email address is already in use.'];
                //       break;
                //     case 'weak-password':
                //       msgTxt = ['This password is too weak.'];
                //       break;
                //   }
                //   showMessageDialog(
                //       context: this.context,
                //       msgTitle: 'Warning',
                //       msgText: msgTxt,
                //       buttonText: 'OK');
                // });
                try {

                  // print ('result');
                  // Map result = await showDialog(
                  //     context: context,
                  //     builder: (BuildContext ctx) {
                  //       return NominatimLocationPicker(
                  //         searchHint: 'Pick your Location',
                  //         awaitingForLocation: "Procurando por sua localização",
                  //       );
                  //     });
                  // if (result != null) {
                  //   print (result);
                  // } else {
                  //   return;
                  // }

                    if (!(await Provider.of<FireBaseAuth>(context, listen: false)
                        .checkUserExistence(email: email))) {
                      print('before condition');
                      Location location = Location();
                      bool condition = await location.getCurrentLocation();
                      print('condition $condition , Location ${location.latitude} ${location.longitude} ');
                      // await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PlacePicker(
                      //       apiKey: 'AIzaSyAa0rx1kO9JJNQR9W_3Ivcre9Uy-AMDCgI',   // Put YOUR OWN KEY here.
                      //       onPlacePicked: (result) {
                      //         print('${result.geometry.location.lat} ${result.geometry.location.lng}');
                      //         Navigator.of(context).pop();
                      //       },
                      //       desiredLocationAccuracy: LocationAccuracy.high,
                      //       useCurrentLocation: true, initialPosition: loca.LatLng(location.latitude,location.longitude),
                      //     ),
                      //   ),
                      // );
                      // condition = false;
                      if ( condition ) {
                        Navigator.pushNamed(
                          context, CompleteProfileScreen.routeName,
                          arguments: ScreenArguments(
                              email: email, password: password,addressGeoPoint: GeoPoint(location.latitude,location.longitude)),);
                      }
                      else {
                        showMessageDialog(
                            context: this.context,
                            msgTitle: 'Warning',
                            msgText: ['Address permission denied.'],
                            buttonText: 'OK');
                      }
                    } else {
                      showMessageDialog(
                          context: this.context,
                          msgTitle: 'Warning',
                          msgText: ['This email address is already in use.'],
                          buttonText: 'OK');
                    }


                } catch (e) {
                  var msgTxt = ['Something went wrong.', 'Please try again'];
                  showMessageDialog(
                      context: this.context,
                      msgTitle: 'Warning',
                      msgText: msgTxt,
                      buttonText: 'OK');
                }
              }
              setState(() {
                isLoading = false;
              });
            },
          ),
          if ( isLoading )
          SpinKitDoubleBounce(
            color: kPrimaryColor,
            size: SizeConfig.screenWidth * 0.15,
          ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        // if (value.isNotEmpty) {
        //   removeError(error: kPassNullError);
        // } else
        if (value.isNotEmpty && password == conform_password) {
          removeError(error: kMatchPassError);
        }
        conform_password = value;
      },
      validator: (value) {
        // if (value.isEmpty) {
        //   addError(error: kPassNullError);
        //   return "";
        // } else
        if (value.isNotEmpty && password != value) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",

        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        // if (value.isNotEmpty) {
        //   removeError(error: kPassNullError);
        // } elseif (value.length >= 8) {
        //   removeError(error: kShortPassError);
        // }
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else
        if (checkPasswordStrength(value)) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }else if (!checkPasswordStrength(value)) {
          addError(error: kShortPassError);
          return "";
        }
        // else if (value.length < 8) {
        //   addError(error: kShortPassError);
        //   return "";
        // }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",

        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        // if (value.isNotEmpty) {
        //   removeError(error: kEmailNullError);
        // } else if (emailValidatorRegExp.hasMatch(value)) {
        //   removeError(error: kInvalidEmailError);
        // }
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        }
        if ( isEmailChecker(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!isEmailChecker(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        // else if (!emailValidatorRegExp.hasMatch(value)) {
        //   addError(error: kInvalidEmailError);
        //   return "";
        // }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
