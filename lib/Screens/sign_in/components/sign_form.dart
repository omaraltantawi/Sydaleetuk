import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/employee_screen/main_employee_screen.dart';
import 'package:graduationproject/Screens/home/home_screen.dart';
import 'package:graduationproject/Screens/manager_screen/manager_screen.dart';
import 'package:graduationproject/ServiceClasses/SignInMethods.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/custom_surfix_icon.dart';
import 'package:graduationproject/components/form_error.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/data_models/User.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/helper/keyboard.dart';
import 'package:graduationproject/screens/forgot_password/forgot_password_screen.dart';
import 'package:provider/provider.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> with CanShowMessages {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
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
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 159, 157, 2),
                  ),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(15)),
          DefaultButton(
            text: "Sign In",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to success screen
                KeyboardUtil.hideKeyboard(context);
                try {
                  await Provider.of<FireBaseAuth>(context, listen: false)
                      .logInNew(email, password);
                  UserType type =
                      Provider.of<FireBaseAuth>(context, listen: false)
                          .loggedUserType;
                  //use pushNamedAndRemoveUntil to disable back to home screen and user is logged in already.

                  if (type == UserType.NormalUser)
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomeScreen.routeName, (route) => false);
                  else if (type == UserType.PharmacyUser) {
                    // print('Logged Successfully');
                    // print(Provider.of<FireBaseAuth>(context,listen:false).loggedUserType);
                    // Pharmacist phar = await Provider.of<FireBaseAuth>(context,listen:false).currentUser;
                    // print('${phar.userId} ${phar.pharmacy.name} ${phar.pharmacy.pharmacyId}');
                    // Provider.of<FireBaseAuth>(context,listen: false).addEmployeeUser('Emp@Sydaleetuk.com','emp@12345','Employee','1','','Good','JnLHedMrmjqmyso4Zfzc');
                    Navigator.pushNamed(context, ManagerScreen.routeName);
                  } else if (type == UserType.EmployeeUser) {
                    print('Logged Successfully');
                    print(Provider.of<FireBaseAuth>(context, listen: false)
                        .loggedUserType);
                    Pharmacist phar =
                        await Provider.of<FireBaseAuth>(context, listen: false)
                            .currentUser;
                    print(
                        '${phar.userId} ${phar.pharmacy.name} ${phar.pharmacy.pharmacyId}');
                    Navigator.pushNamed(context, MainEmployeeScreen.routeName);
                  }
                } on FirebaseAuthException catch (e) {
                  print(e);
                  var msgTxt = ['Something went wrong.', 'Please try again'];
                  switch (e.code) {
                    case 'wrong-password':
                    case 'invalid-email':
                    case 'user-not-found':
                      msgTxt = ['User name or Password is incorrect.'];
                      break;
                    case 'network-request-failed':
                      msgTxt = ['No Internet Connection.'];
                      break;
                    default:
                      msgTxt = ['Something went wrong.', 'Please try again'];
                      break;
                  }
                  showMessageDialog(
                      context: this.context,
                      msgTitle: 'Warning',
                      msgText: msgTxt,
                      buttonText: 'OK');
                } catch (e) {
                  print(e);
                  print(e.runtimeType);
                  var msgTxt = ['Something went wrong.', 'Please try again'];
                  showMessageDialog(
                      context: this.context,
                      msgTitle: 'Warning',
                      msgText: msgTxt,
                      buttonText: 'OK');
                }
                // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
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
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (isEmailChecker(value)) {
          removeError(error: kInvalidEmailError);
        }
        // else if (emailValidatorRegExp.hasMatch(value)) {
        //   removeError(error: kInvalidEmailError);
        // }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!isEmailChecker(value)) {
          addError(error: kInvalidEmailError);
          return " ";
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
