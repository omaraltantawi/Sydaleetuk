import 'package:flutter/material.dart';
import 'package:graduationproject/data_models/User.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/providers/phone_auth.dart';
import 'package:graduationproject/utils/constants.dart';
import 'package:graduationproject/utils/widgets.dart';
import 'package:provider/provider.dart';

class PhoneAuthVerify extends StatefulWidget {
  /*
   *  cardBackgroundColor & logo values will be passed to the constructor
   *  here we access these params in the _PhoneAuthState using "widget"
   */
  final Color cardBackgroundColor = Color(0xFFFCA967);
  final String logo = Assets.firebase;
  final String appName = "Sydaleetuk";
  final UserType usertype ;
  final Map<String, dynamic> authData;

  PhoneAuthVerify({this.authData,this.usertype});

  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState();
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {
  double _height, _width, _fixedPadding;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  String code = "";

  @override
  void initState() {
    super.initState();
  }

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-verify-phone");

  @override
  Widget build(BuildContext context) {
    //  Fetching height & width parameters from the MediaQuery
    //  _logoPadding will be a constant, scaling it according to device's size
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;

    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);

    phoneAuthDataProvider.setMethods(
      onStarted: onStarted,
      onError: onError,
      onFailed: onFailed,
      // onVerified: onVerified,
      onCodeResent: onCodeResent,
      onCodeSent: onCodeSent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeOut,
    );

    /*
     *  Scaffold: Using a Scaffold widget as parent
     *  SafeArea: As a precaution - wrapping all child descendants in SafeArea, so that even notched phones won't loose data
     *  Center: As we are just having Card widget - making it to stay in Center would really look good
     *  SingleChildScrollView: There can be chances arising where
     */
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _getBody(),
          ),
        ),
      ),
    );
  }

  /*
   *  Widget hierarchy ->
   *    Scaffold -> SafeArea -> Center -> SingleChildScrollView -> Card()
   *    Card -> FutureBuilder -> Column()
   */
  Widget _getBody() => Card(
        color: widget.cardBackgroundColor,
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: SizedBox(
          height: _height * 8 / 10,
          width: _width * 8 / 10,
          child: _getColumnBody(),
        ),
      );

  Widget _getColumnBody() => Column(
        children: <Widget>[
          //  Logo: scaling to occupy 2 parts of 10 in the whole height of device
          Padding(
            padding: EdgeInsets.all(_fixedPadding),
            child: PhoneAuthWidgets.getLogo(
                logoPath: widget.logo, height: _height * 0.2),
          ),

          // AppName:
          Text(widget.appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700)),

          SizedBox(height: 20.0),

          //  Info text
          Row(
            children: <Widget>[
              SizedBox(width: 16.0),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Please enter the ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: 'Verification code',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700)),
                      TextSpan(
                        text: ' that sent to your mobile',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16.0),
            ],
          ),

          SizedBox(height: 16.0),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getPinField(key: "1", focusNode: focusNode1),
              SizedBox(width: 5.0),
              getPinField(key: "2", focusNode: focusNode2),
              SizedBox(width: 5.0),
              getPinField(key: "3", focusNode: focusNode3),
              SizedBox(width: 5.0),
              getPinField(key: "4", focusNode: focusNode4),
              SizedBox(width: 5.0),
              getPinField(key: "5", focusNode: focusNode5),
              SizedBox(width: 5.0),
              getPinField(key: "6", focusNode: focusNode6),
              SizedBox(width: 5.0),
            ],
          ),

          SizedBox(height: 32.0),

          RaisedButton(
            elevation: 16.0,
            onPressed: signIn,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'VERIFY',
                style: TextStyle(
                    color: widget.cardBackgroundColor, fontSize: 18.0),
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          )
        ],
      );

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
      duration: Duration(seconds: 4),
    );
//    if (mounted) Scaffold.of(context).showSnackBar(snackBar);
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  signIn() {
    if (code.length != 6) {
      _showSnackBar("Invalid OTP");
    }
    Provider.of<PhoneAuthDataProvider>(context, listen: false)
        .verifyOTPAndLogin(smsCode: code);
  }

  // This will return pin field - it accepts only single char
  Widget getPinField({String key, FocusNode focusNode}) => SizedBox(
        height: 40.0,
        width: 35.0,
        child: TextField(
          key: Key(key),
          expands: false,
//          autofocus: key.contains("1") ? true : false,
          autofocus: false,
          focusNode: focusNode,
          onChanged: (String value) {
            if (value.length == 1) {
              code += value;
              switch (code.length) {
                case 1:
                  FocusScope.of(context).requestFocus(focusNode2);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(focusNode3);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(focusNode4);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(focusNode5);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(focusNode6);
                  break;
                default:
                  FocusScope.of(context).requestFocus(FocusNode());
                  break;
              }
            }
          },
          maxLengthEnforced: false,
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
//          decoration: InputDecoration(
//              contentPadding: const EdgeInsets.only(
//                  bottom: 10.0, top: 10.0, left: 4.0, right: 4.0),
//              focusedBorder: OutlineInputBorder(
//                  borderRadius: BorderRadius.circular(5.0),
//                  borderSide:
//                      BorderSide(color: Colors.blueAccent, width: 2.25)),
//              border: OutlineInputBorder(
//                  borderRadius: BorderRadius.circular(5.0),
//                  borderSide: BorderSide(color: Colors.white))),
        ),
      );

  onStarted() {
    _showSnackBar("PhoneAuth started");
  }

  onCodeSent() {
    _showSnackBar("OPT sent");
  }

  onCodeResent() {
    _showSnackBar("OPT resent");
  }

  // onVerified( AuthCredential user ) async {
  //   print ('User get to Verify Method $user');
  //
  //   if ( widget.usertype == UserType.NormalUser ) {
  //     Provider
  //         .of<FireBaseAuth>(context, listen: false)
  //         .loggedUser = user.user;
  //     String userId = await Provider.of<FireBaseAuth>(context, listen: false)
  //         .addNormalUser(
  //         user.user.email,
  //         widget.authData['fName'].toString(),
  //         widget.authData['lName'].toString(),
  //         user.user.phoneNumber,
  //         widget.authData['healthStatus'].toString(),
  //         widget.authData['address'].toString(),
  //         widget.authData['birthDate']);
  //     Provider.of<FireBaseAuth>(context, listen: false).setNormalUserData(
  //         userId,
  //         user.user.email,
  //         widget.authData['fName'].toString(),
  //         widget.authData['lName'].toString(),
  //         user.user.phoneNumber,
  //         widget.authData['healthStatus'].toString(),
  //         widget.authData['address'].toString(),
  //         widget.authData['birthDate']);
  //     print('Is Auth from Verify Method = ${Provider
  //         .of<FireBaseAuth>(context, listen: false)
  //         .isAuth}');
  //     print('User from Verify Method = ${Provider
  //         .of<FireBaseAuth>(context, listen: false)
  //         .loggedUserType}');
  //     print('User from Verify Method = ${Provider
  //         .of<FireBaseAuth>(context, listen: false)
  //         .currentUser}');
  //   }
  //   _showSnackBar("${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
  //   await Future.delayed(Duration(seconds: 1));
  //   Navigator.of(context)
  //       .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => UserScreen()));
  // }
  //
  // onVerified( UserCredential user ) async {
  //   print ('User get to Verify Method $user');
  //
  //   if ( widget.usertype == UserType.NormalUser ) {
  //     Provider
  //         .of<FireBaseAuth>(context, listen: false)
  //         .loggedUser = user.user;
  //     String userId = await Provider.of<FireBaseAuth>(context, listen: false)
  //         .addNormalUser(
  //         user.user.email,
  //         widget.authData['fName'].toString(),
  //         widget.authData['lName'].toString(),
  //         user.user.phoneNumber,
  //         widget.authData['healthStatus'].toString(),
  //         widget.authData['address'].toString(),
  //         widget.authData['birthDate']);
  //     Provider.of<FireBaseAuth>(context, listen: false).setNormalUserData(
  //         userId,
  //         user.user.email,
  //         widget.authData['fName'].toString(),
  //         widget.authData['lName'].toString(),
  //         user.user.phoneNumber,
  //         widget.authData['healthStatus'].toString(),
  //         widget.authData['address'].toString(),
  //         widget.authData['birthDate']);
  //     print('Is Auth from Verify Method = ${Provider
  //         .of<FireBaseAuth>(context, listen: false)
  //         .isAuth}');
  //     print('User from Verify Method = ${Provider
  //         .of<FireBaseAuth>(context, listen: false)
  //         .loggedUserType}');
  //     print('User from Verify Method = ${Provider
  //         .of<FireBaseAuth>(context, listen: false)
  //         .currentUser}');
  //   }
  //   _showSnackBar("${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
  //   await Future.delayed(Duration(seconds: 1));
  //   Navigator.of(context)
  //       .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => UserScreen()));
  // }

  onFailed() {
    print ("PhoneAuth failed ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
    if ( widget.usertype == UserType.NormalUser ) {
      Provider.of<FireBaseAuth>(context, listen: false).deleteUser();
    }
    _showSnackBar("PhoneAuth failed ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}}");
  }

  onError() {
    print ("PhoneAuth error ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
    if ( widget.usertype == UserType.NormalUser ) {
      Provider.of<FireBaseAuth>(context, listen: false).deleteUser();
    }
    _showSnackBar(
        "PhoneAuth error ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
  }

  onAutoRetrievalTimeOut() {
    print ("PhoneAuth autoretrieval timeout ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
    // Provider.of<FireBaseAuth>(context, listen: false).deleteUser();
    _showSnackBar("PhoneAuth autoretrieval timeout ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
//    _showSnackBar(phoneAuthDataProvider.message);
  }
}
