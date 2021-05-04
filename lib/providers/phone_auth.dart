import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier, VoidCallback;
import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:graduationproject/firebase/auth/auth.dart';

enum PhoneAuthState {
  Started,
  CodeSent,
  CodeResent,
  Verified,
  Failed,
  Error,
  AutoRetrievalTimeOut
}

class PhoneAuthDataProvider with ChangeNotifier {
  VoidCallback onStarted,
      onCodeSent,
      onCodeResent,
      onFailed,
      onError,
      onAutoRetrievalTimeout;

  Function(AuthCredential)  onVerified;

  bool _loading = false;

  final TextEditingController _phoneNumberController = TextEditingController();

  PhoneAuthState _status;
  var _authCredential;
  String _actualCode;
  String _phone, _message;

  setMethods(
      {VoidCallback onStarted,
      VoidCallback onCodeSent,
      VoidCallback onCodeResent,
      Function(AuthCredential) onVerified,
      VoidCallback onFailed,
      VoidCallback onError,
      VoidCallback onAutoRetrievalTimeout}) {
    this.onStarted = onStarted;
    this.onCodeSent = onCodeSent;
    this.onCodeResent = onCodeResent;
    this.onVerified = onVerified;
    this.onFailed = onFailed;
    this.onError = onError;
    this.onAutoRetrievalTimeout = onAutoRetrievalTimeout;
  }

  Future<bool> instantiate(
      {String dialCode,
      VoidCallback onStarted,
      VoidCallback onCodeSent,
      VoidCallback onCodeResent,
      Function(AuthCredential) onVerified,
      VoidCallback onFailed,
      VoidCallback onError,
      VoidCallback onAutoRetrievalTimeout}) async {
    this.onStarted = onStarted;
    this.onCodeSent = onCodeSent;
    this.onCodeResent = onCodeResent;
    this.onVerified = onVerified;
    this.onFailed = onFailed;
    this.onError = onError;
    this.onAutoRetrievalTimeout = onAutoRetrievalTimeout;

    if (phoneNumberController.text.length < 9) {
      return false;
    }
    phone = dialCode + phoneNumberController.text;
    print(phone);
    startAuth();
    return true;
  }

  Future<bool> instantiateNew(
      {String phoneNo,
      VoidCallback onStarted,
      VoidCallback onCodeSent,
      VoidCallback onCodeResent,
      Function(AuthCredential) onVerified,
      VoidCallback onFailed,
      VoidCallback onError,
      VoidCallback onAutoRetrievalTimeout}) async {
    this.onStarted = onStarted;
    this.onCodeSent = onCodeSent;
    this.onCodeResent = onCodeResent;
    this.onVerified = onVerified;
    this.onFailed = onFailed;
    this.onError = onError;
    this.onAutoRetrievalTimeout = onAutoRetrievalTimeout;

    phone = phoneNo;
    print(phone);
    startAuth();
    return true;
  }

  startAuth() {
    print('_startAuth invoked');
    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
          print('_startAuth PhoneCodeSent');
      actualCode = verificationId;
      _addStatusMessage("\nEnter the code sent to " + phone);
      _addStatus(PhoneAuthState.CodeSent);
      if (onCodeSent != null) onCodeSent();
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {

          print('_startAuth PhoneCodeAutoRetrievalTimeout');
      actualCode = verificationId;
      _addStatusMessage("\nAuto retrieval time out");
      _addStatus(PhoneAuthState.AutoRetrievalTimeOut);
      if (onAutoRetrievalTimeout != null) onAutoRetrievalTimeout();
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
          print('_startAuth PhoneVerificationFailed');
          print('_startAuth PhoneVerificationFailed $authException');
      _addStatusMessage('${authException.message}');
      _addStatus(PhoneAuthState.Failed);
      if (onFailed != null) onFailed();
      if (authException.message.contains('not authorized'))
        _addStatusMessage('App not authroized');
      else if (authException.message.contains('Network'))
        _addStatusMessage(
            'Please check your internet connection and try again');
      else
        _addStatusMessage('Something has gone wrong, please try later ' +
            authException.message);
    };

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
          print('_startAuth Auto retrieving verification code');
          _addStatusMessage('Auto retrieving verification code');

          if (onVerified != null) onVerified(auth);

      //   FireBaseAuth.auth.currentUser.linkWithCredential(auth).then((UserCredential value) {
      //   print('Auto retrieving verification code Credential $value');
      //   if (value.user != null) {
      //     print('Auto retrieving verification code -- Authentication successful');
      //     _addStatusMessage('Authentication successful');
      //     _addStatus(PhoneAuthState.Verified);
      //     if (onVerified != null) onVerified(value);
      //   } else {
      //     if (onFailed != null) onFailed();
      //     _addStatus(PhoneAuthState.Failed);
      //     _addStatusMessage('Invalid code/invalid authentication');
      //   }
      // }).catchError((error) {
      //   if (onError != null) onError();
      //   print('Auto retrieving verification code -- Something has gone wrong, please try later $error');
      //   _addStatus(PhoneAuthState.Error);
      //   _addStatusMessage('Something has gone wrong, please try later $error');
      // });
    };

    // FireBaseAuth.auth.
    _addStatusMessage('Phone auth started');
    FireBaseAuth.auth
        .verifyPhoneNumber(
            phoneNumber: phone.toString(),
            timeout: Duration(seconds: 60),
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
        .then((value) {
      // if (onCodeSent != null) onCodeSent();
      // _addStatus(PhoneAuthState.CodeSent);
      // _addStatusMessage('Code sent');
    }).catchError((error) {
      if (onError != null) onError();
      _addStatus(PhoneAuthState.Error);
      _addStatusMessage(error.toString());
    });
  }

  void verifyOTPAndLogin({String smsCode}) async {
    AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: actualCode, smsCode: smsCode);

    if (onVerified != null) onVerified(authCredential);

    // UserCredential user = await FireBaseAuth.auth
    //     .signInWithCredential(_authCredential)


    // UserCredential user = await FireBaseAuth.auth
    //     .currentUser.linkWithCredential(authCredential)
    //     .then((UserCredential result) async {
    //   _addStatusMessage('Authentication successful');
    //   _addStatus(PhoneAuthState.Verified);
    //   if (onVerified != null) onVerified(result);
    // }).catchError((error) {
    //   if (onError != null) onError();
    //   _addStatus(PhoneAuthState.Error);
    //   _addStatusMessage(
    //       'Something has gone wrong, please try later $error');
    // });
  }

  _addStatus(PhoneAuthState state) {
    status = state;
  }

  void _addStatusMessage(String s) {
    message = s;
  }

  get authCredential => _authCredential;

  set authCredential(value) {
    _authCredential = value;
    notifyListeners();
  }

  get actualCode => _actualCode;

  set actualCode(String value) {
    _actualCode = value;
    notifyListeners();
  }

  get phone => _phone;

  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  get message => _message;

  set message(String value) {
    _message = value;
    notifyListeners();
  }

  PhoneAuthState get status => _status;

  set status(PhoneAuthState value) {
    _status = value;
    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  TextEditingController get phoneNumberController => _phoneNumberController;
}
