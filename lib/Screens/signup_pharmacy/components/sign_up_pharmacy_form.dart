import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/complete_pharmacy_profile/complete_pharmacy_profile_screen.dart';
import 'package:graduationproject/Screens/sign_up/components/ScreenArguments.dart';
import 'package:graduationproject/ServiceClasses/Location.dart';
import 'package:graduationproject/ServiceClasses/SignInMethods.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/custom_surfix_icon.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/components/form_error.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../size_config.dart';


class SignUpPharmacyForm extends StatefulWidget {
  @override
  _SignUpPharmacyFormState createState() => _SignUpPharmacyFormState();
}

class _SignUpPharmacyFormState extends State<SignUpPharmacyForm> with CanShowMessages {
  final _formKey = GlobalKey<FormState>();
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  String experience;
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildExperienceFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                try {
                  int check = await Provider.of<FireBaseAuth>(context, listen: false).checkPharmacyUserExistence(email: email);
                  if (check == 0) {
                    print('before condition');
                    Location location = Location();
                    bool condition = await location.getCurrentLocation();
                    print('condition $condition , Location ${location.latitude} ${location.longitude} ');
                    if ( condition ) {
                      Navigator.pushNamed(
                        context, CompletePharmacyProfileScreen.routeName,
                        arguments: ScreenArguments(
                            email: email , fName: firstName, lName: lastName, phoneNo: phoneNumber ,experience:experience ,addressGeoPoint: GeoPoint(location.latitude,location.longitude)),);
                    }
                    else {
                      showMessageDialog(
                          context: this.context,
                          msgTitle: 'Warning',
                          msgText: ['Address permission denied.'],
                          buttonText: 'OK');
                    }
                  } else if ( check == 1 ){
                      showMessageDialog(
                          context: this.context,
                          msgTitle: 'Warning',
                          msgText: ['This email address is already in use.'],
                          buttonText: 'OK');
                  }else if ( check == 2  ){
                      showMessageDialog(
                          context: this.context,
                          msgTitle: 'Warning',
                          msgText: ['This email address request is still under study.'],
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
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildExperienceFormField() {
    return TextFormField(
      onSaved: (newValue) => experience = newValue,
      decoration: InputDecoration(
        labelText: "Experience",
        hintText: "Enter your experience",

        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        if ( value.length == 10 ){
          removeError(error: kInvalidPhoneNumberError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }else if ( value.length != 10 ){
          addError(error: kInvalidPhoneNumberError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",

        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",

        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
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
