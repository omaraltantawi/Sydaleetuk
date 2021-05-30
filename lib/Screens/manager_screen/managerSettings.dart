import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduationproject/Screens/reminder/helpers/platform_flat_button.dart';
import 'package:graduationproject/Screens/splash/splash_screen.dart';
import 'package:graduationproject/ServiceClasses/SignInMethods.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/custom_surfix_icon.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/components/form_error.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/data_models/Patient.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ManagerSettingsScreen extends StatelessWidget {
  static String routeName = "/manager_settings";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget with CanShowMessages {
  @override
  Widget build(BuildContext context) {
    Patient user = Provider.of<FireBaseAuth>(context, listen: true).patient;
    var loggedUser =
        Provider.of<FireBaseAuth>(context, listen: true).loggedUser;
    var loggedUserType =
        Provider.of<FireBaseAuth>(context, listen: true).loggedUser;
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(25)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                if (!loggedUser.emailVerified)
                  SizedBox(height: getProportionateScreenHeight(20)),
                if (!loggedUser.emailVerified)
                  FloatingActionButton.extended(
                    elevation: 0.0,
                    heroTag: 'verify',
                    shape: StadiumBorder(
                        side: BorderSide(color: Color(0xFF099F9D), width: 1),),
                    onPressed: () async {
                      await Provider.of<FireBaseAuth>(context, listen: false)
                          .verifyEmail();
                      await showMessageDialog(
                          context: context,
                          msgTitle: 'Confirm',
                          msgText: [
                            'The verification email sent to your email.'
                          ],
                          buttonText: 'OK');
                    },
                    label: Padding(
                      padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
                      child: Column(
                        children: [
                          Text('Verify Email',
                              style: TextStyle(color: Color(0xFF099F9D))),
                        ],
                      ),
                    ),
                    tooltip: "Verify Email",
                    backgroundColor: Colors.white,
                  ),
                SizedBox(height: getProportionateScreenHeight(20)),
                FloatingActionButton.extended(
                  elevation: 0.0,
                  heroTag: 'reset',
                  shape: StadiumBorder(
                      side: BorderSide(color: Color(0xFF099F9D), width: 1)),
                  onPressed: () async {
                    // Provider.of<FireBaseAuth>(context, listen: false).resetPasswordEmail(oldPass: 'omar@123456',newPass: 'omar@12345').catchError((e) async {
                    //   var msgTxt = ['Something went wrong.', 'Please try again'];
                    //   if ( e.runtimeType == FirebaseAuthException ){
                    //     switch (e.code) {
                    //       case 'wrong-password':
                    //         msgTxt = ['Password is incorrect.'];
                    //         break;
                    //       case 'network-request-failed':
                    //         msgTxt = ['No Internet Connection.'];
                    //         break;
                    //       default:
                    //         msgTxt = ['Something went wrong.', 'Please try again'];
                    //         break;
                    //     }
                    //   }
                    //   await showMessageDialog(
                    //       context: context,
                    //       msgTitle: 'Warning',
                    //       msgText: msgTxt,
                    //       buttonText: 'OK');
                    // });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ResetPassScreenDialog(),
                          fullscreenDialog: true,
                        ));
                  },
                  label: Padding(
                    padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
                    child: Column(
                      children: [
                        Text('Reset Password',
                            style: TextStyle(color: Color(0xFF099F9D))),
                      ],
                    ),
                  ),
                  tooltip: "Reset Password",
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                FloatingActionButton.extended(
                  elevation: 0.0,
                  heroTag: 'deleteAccount',
                  shape: StadiumBorder(
                      side: BorderSide(color: Color(0xFF099F9D), width: 1)),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DeleteAccountScreenDialog(),
                          fullscreenDialog: true,
                        ));
                  },
                  label: Padding(
                    padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
                    child: Column(
                      children: [
                        Text('Delete Account',
                            style: TextStyle(color: Color(0xFF099F9D))),
                      ],
                    ),
                  ),
                  tooltip: "Delete Account",
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteAccountScreenDialog extends StatefulWidget {
  const DeleteAccountScreenDialog({
    Key key,
  }) : super(key: key);
  @override
  DeleteAccountScreenDialogState createState() => new DeleteAccountScreenDialogState();
}

class DeleteAccountScreenDialogState extends State<DeleteAccountScreenDialog>
    with CanShowMessages {
  final _formKey = GlobalKey<FormState>();
  String oldPassword, oldPasswordConfirm;
  TextEditingController _oldPassController = TextEditingController();
  TextEditingController _oldPassConfirmController = TextEditingController();

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
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Delete Account"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: getProportionateScreenHeight(50)),
                  TextFormField(
                    obscureText: true,
                    controller: _oldPassController,
                    onSaved: (newValue) {
                      setState(() {
                        oldPassword = newValue;
                      });
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        removeError(error: kPassNullError);
                      }
                      setState(() {
                        oldPassword = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        addError(error: kPassNullError);
                        return "";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon:
                      CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  TextFormField(
                    obscureText: true,
                    controller: _oldPassConfirmController,
                    onSaved: (newValue) => oldPasswordConfirm = newValue,
                    onChanged: (value) {
                      if (value.isNotEmpty && oldPassword == value) {
                        removeError(error: kMatchPassError);
                      }
                      oldPasswordConfirm = value;
                    },
                    validator: (value) {
                      if (value.isNotEmpty && oldPassword != value) {
                        addError(error: kMatchPassError);
                        return "";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      hintText: "Re-enter your password",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon:
                      CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  FormError(errors: errors),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  if ( !isLoading )
                    DefaultButton(
                      key: Key('Delete'),
                      text: 'Delete Account',
                      press: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          FocusScope.of(context).unfocus();
                          setState(() {
                            isLoading = true;
                          });
                          // QuestionMessage answer = await showQuestionDialog(
                          //     context: context,
                          //     msgTitle: 'Warning',
                          //     msgText: [
                          //       'Are you sure you want to delete your account?'
                          //     ],
                          //     buttonText: 'Yes');
                          // if (answer == QuestionMessage.YES) {
                          //   Provider.of<FireBaseAuth>(context, listen: false)
                          //       .deleteUser(oldPass: '');
                          //   Navigator.pushNamedAndRemoveUntil(
                          //       context, SplashScreen.routeName, (route) => false);
                          // }
                          try {
                            await Provider.of<FireBaseAuth>(context,
                                listen: false)
                                .deletePharmacyAccount(oldPass: oldPassword);
                            Navigator.pushNamedAndRemoveUntil(context,
                                SplashScreen.routeName, (route) => false);
                          } on FirebaseAuthException catch (e) {
                            var msgTxt = [
                              'Something went wrong.',
                              'Please try again'
                            ];
                            switch (e.code) {
                              case 'wrong-password':
                                msgTxt = ['Password is incorrect.'];
                                break;
                              case 'network-request-failed':
                                msgTxt = ['No Internet Connection.'];
                                break;
                              default:
                                msgTxt = [
                                  'Something went wrong.',
                                  'Please try again'
                                ];
                                break;
                            }
                            await showMessageDialog(
                                context: context,
                                msgTitle: 'Warning',
                                msgText: msgTxt,
                                buttonText: 'OK');
                          } catch (e) {
                            var msgTxt = [
                              'Something went wrong.',
                              'Please try again'
                            ];
                            await showMessageDialog(
                                context: context,
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
            ),
          ),
        ));
  }
}

class ResetPassScreenDialog extends StatefulWidget {
  const ResetPassScreenDialog({
    Key key,
  }) : super(key: key);
  @override
  ResetPassScreenDialogState createState() => new ResetPassScreenDialogState();
}

class ResetPassScreenDialogState extends State<ResetPassScreenDialog>
    with CanShowMessages {
  final _formKey = GlobalKey<FormState>();
  String oldPassword, password, confirm_password;

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
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: getProportionateScreenHeight(20)),
                TextFormField(
                  obscureText: true,
                  onSaved: (newValue) {
                    setState(() {
                      oldPassword = newValue;
                    });
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: 'Please Enter your current password');
                    }
                    setState(() {
                      oldPassword = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      addError(error: 'Please Enter your current password');
                      return "";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Current Password",
                    hintText: "Enter your current password",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                    CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                TextFormField(
                  obscureText: true,
                  onSaved: (newValue) => password = newValue,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: 'Please Enter your new password');
                    }
                    if (checkPasswordStrength(value)) {
                      removeError(error: 'New password is too short');
                    }
                    setState(() {
                      password = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      addError(error: 'Please Enter your new password');
                      return "";
                    } else if (!checkPasswordStrength(value)) {
                      addError(error: 'New password is too short');
                      return "";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "New Password",
                    hintText: "Enter your new password",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                    CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                TextFormField(
                  obscureText: true,
                  onSaved: (newValue) => confirm_password = newValue,
                  onChanged: (value) {
                    print('$password $value');
                    if (value.isNotEmpty && password == value) {
                      removeError(error: kMatchPassError);
                    }
                    setState(() {
                      confirm_password = value;
                    });
                  },
                  validator: (value) {
                    if (value.isNotEmpty && password != value) {
                      addError(error: kMatchPassError);
                      return "";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Confirm New Password",
                    hintText: "Re-enter your new password",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                    CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                FormError(errors: errors),
                SizedBox(height: getProportionateScreenHeight(20)),
                if ( !isLoading )
                  DefaultButton(
                    key: Key('reset'),
                    text: 'Reset Password',
                    press: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        FocusScope.of(context).unfocus();
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          // Keyboard
                          await Provider.of<FireBaseAuth>(context, listen: false)
                              .resetPasswordEmail(
                              oldPass: oldPassword, newPass: password);
                          await showMessageDialog(
                              context: context,
                              msgTitle: 'Reset Password',
                              msgText: ['Your password reset done successfully.'],
                              buttonText: 'OK');
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e) {
                          var msgTxt = [
                            'Something went wrong.',
                            'Please try again'
                          ];
                          switch (e.code) {
                            case 'wrong-password':
                              msgTxt = ['Password is incorrect.'];
                              break;
                            case 'network-request-failed':
                              msgTxt = ['No Internet Connection.'];
                              break;
                            default:
                              msgTxt = [
                                'Something went wrong.',
                                'Please try again'
                              ];
                              break;
                          }
                          await showMessageDialog(
                              context: context,
                              msgTitle: 'Warning',
                              msgText: msgTxt,
                              buttonText: 'OK');
                        } catch (e) {
                          var msgTxt = [
                            'Something went wrong.',
                            'Please try again'
                          ];
                          await showMessageDialog(
                              context: context,
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

                SizedBox(height: getProportionateScreenHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
