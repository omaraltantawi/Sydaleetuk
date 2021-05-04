import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/lets_text.dart';
import 'package:graduationproject/Screens/sign_up/components/ScreenArguments.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/providers/phone_auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class OtpForm extends StatefulWidget {
  final ScreenArguments arguments;
  const OtpForm({
    Key key,this.arguments
  }) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  FocusNode pin5FocusNode;
  FocusNode pin6FocusNode;

  Map<String,String> code ;

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    code ={
      '1':'',
      '2':'',
      '3':'',
      '4':'',
      '5':'',
      '6':'',
    };
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode , int fieldNo) {
    if (value.length == 1) {
      // focusNode.requestFocus();
      code['$fieldNo'] = value;
      print ( code );
      FocusScope.of(context).requestFocus(focusNode);
    }
  }

  @override
  Widget build(BuildContext context) {

    final phoneAuthDataProvider =
    Provider.of<PhoneAuthDataProvider>(context, listen: false);

    phoneAuthDataProvider.setMethods(
      onStarted: onStarted,
      onError: onError,
      onFailed: onFailed,
      onVerified: onVerified,
      onCodeResent: onCodeResent,
      onCodeSent: onCodeSent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeOut,
    );

    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(50),
                child: TextFormField(
                  autofocus: true,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin2FocusNode,1);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(50),
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin3FocusNode,2),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(50),
                child: TextFormField(
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin4FocusNode,3),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(50),
                child: TextFormField(
                  maxLengthEnforced: false,
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin5FocusNode,4),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(50),
                child: TextFormField(
                  focusNode: pin5FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin6FocusNode,5),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(50),
                child: TextFormField(
                  focusNode: pin6FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      // pin6FocusNode.unfocus();
                      nextField(value, FocusNode(),6);
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          DefaultButton(
            text: "Continue",
            press: () {
              if ( code.containsValue('') ){
                //Show error still there are a field empty.
                print ('error');
              }else {
                String _code = '${code['1']}${code['2']}${code['3']}${code['4']}${code['5']}${code['6']}' ;
                print (_code);
                Provider.of<PhoneAuthDataProvider>(context, listen: false).verifyOTPAndLogin(smsCode: _code);
              }
            },
          )
        ],
      ),
    );
  }


  onStarted() {
    print("PhoneAuth started");
  }

  onCodeSent() {
    print("OPT sent");
  }

  onCodeResent() {
    print("OPT resent");
  }

  onVerified( AuthCredential user ) async {
    try {
      print('User get to Verify Method $user');
      // await Provider.of<FireBaseAuth>(context, listen: false).signUpNormalUser(
      //     widget.arguments.email, widget.arguments.password);
      await Provider.of<FireBaseAuth>(context,listen: false).signUpNormalUserWithAllData(widget.arguments.email,widget.arguments.password,
        widget.arguments.fName,widget.arguments.lName,widget.arguments.phoneNo,'',widget.arguments.address,widget.arguments.gender,widget.arguments.birthDate,);
      // await Provider.of<FireBaseAuth>(context,listen: false).addNormalUser(widget.arguments.email,widget.arguments.password,
      //   widget.arguments.fName,widget.arguments.lName,widget.arguments.phoneNo,'',widget.arguments.address,widget.arguments.gender,widget.arguments.birthDate,);
      await Provider.of<FireBaseAuth>(context, listen: false)
          .linkLoggedUserWithCredintal(credential: user);
      print('Logged User After Verify is ${Provider
          .of<FireBaseAuth>(context, listen: false)
          .loggedUser}');
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(context, UserScreen.routeName, (route) => false);
    }catch(e){
      print(e);
    }
  }

  onFailed() {
    print ("PhoneAuth failed ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
  }

  onError() {
    print ("PhoneAuth error ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
  }

  onAutoRetrievalTimeOut() {
    print ("PhoneAuth autoRetrieval timeout ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
  }

}

