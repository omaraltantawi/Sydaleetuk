import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduationproject/Screens/home/home_screen.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:graduationproject/ServiceClasses/SignInMethods.dart';
import 'package:graduationproject/data_models/User.dart';
import 'package:graduationproject/firebase/auth/phone_auth/get_phone.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'lets_text.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  final bool isEmployee;

  AuthScreen({this.isEmployee = false});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'Sydaleetuk',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1, // deviceSize.width > 600 ? 2 : 1,
                    child: isEmployee ? AuthCardEmployee() : AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with CanShowMessages {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, dynamic> _authData = {
    'email': '',
    'password': '',
    'fName': '',
    'lName': '',
    'phoneNo': '',
    'healthStatus': '',
    'experience': '',
    'address': '',
    'birthDate': null,
    'pharmacyName': '',
    'pharmacyPhoneNo': '',
  };

  UserType currentUserType = UserType.NormalUser;
  var _isLoading = false;
  var _isChanging = false;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _dateTimeController = TextEditingController();

  AutovalidateMode _passwordValidateMode = AutovalidateMode.disabled;
  AutovalidateMode _emailValidateMode = AutovalidateMode.disabled;
  AutovalidateMode _fNameValidateMode = AutovalidateMode.disabled;
  AutovalidateMode _lNameValidateMode = AutovalidateMode.disabled;

  DateTime selectedDate;

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    // try{
    if (_authMode == AuthMode.Login) {
      try {
        await Provider.of<FireBaseAuth>(context, listen: false)
            .logInNew(_authData['email'], _authData['password']);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } catch (e) {
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
      }
    } else {
      // Sign User Up
      try {
        if (currentUserType == UserType.NormalUser) {
          await Provider.of<FireBaseAuth>(context, listen: false)
              .signUpNormalUser(_authData['email'], _authData['password']);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PhoneAuthGetPhone(
                  authData: _authData,
                  userType: currentUserType,
                ),
              ));
        } else if (currentUserType == UserType.PharmacyUser) {
          await Provider.of<FireBaseAuth>(context, listen: false)
              .signUpPharmacyWithUser(
                  _authData['email'],
                  _authData['fName'],
                  _authData['lName'],
                  _authData['phoneNo'],
                  _authData['experience'],
                  pharmacyName: _authData['pharmacyName'],
                  pharmacyPhoneNo: _authData['pharmacyPhoneNo'],
                  files: await getImageFilesFromAssets(images));
          showMessageDialog(
              context: this.context,
              msgTitle: 'Confirm',
              msgText: [
                'Your request sent Successfully.',
                'Please Wait until app admin approve your request.'
              ],
              buttonText: 'OK');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => AuthScreen(),
              ));
        }
      } catch (e) {
        var msgTxt = ['Something went wrong.', 'Please try again'];
        switch (e.code) {
          case 'invalid-email':
            msgTxt = ['This is not a valid email address.'];
            break;
          case 'email-already-in-use':
            msgTxt = ['This email address is already in use.'];
            break;
          case 'weak-password':
            msgTxt = ['This password is too weak.'];
            break;
        }
        showMessageDialog(
            context: this.context,
            msgTitle: 'Warning',
            msgText: msgTxt,
            buttonText: 'OK');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() async {
    if (_authMode == AuthMode.Login) {
      UserType pickedUser = await showUserPickerDialog(context: context);
      setState(() {
        if (pickedUser != null) {
          _authMode = AuthMode.SignUp;
          currentUserType = pickedUser;
          _isChanging = true;
          selectedDate = null;
          _fNameController.text = '';
          _lNameController.text = '';
          _emailController.text = '';
          _passwordController.text = '';
          _passwordValidateMode = AutovalidateMode.disabled;
          _emailValidateMode = AutovalidateMode.disabled;
          _fNameValidateMode = AutovalidateMode.disabled;
          _lNameValidateMode = AutovalidateMode.disabled;
          _formKey.currentState.validate();
          _isChanging = false;
        }
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        _isChanging = true;
        selectedDate = null;
        _fNameController.text = '';
        _lNameController.text = '';
        _emailController.text = '';
        _passwordController.text = '';
        _passwordValidateMode = AutovalidateMode.disabled;
        _emailValidateMode = AutovalidateMode.disabled;
        _fNameValidateMode = AutovalidateMode.disabled;
        _lNameValidateMode = AutovalidateMode.disabled;
        _formKey.currentState.validate();
        _isChanging = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime picked = await showDatePickerDialog(context: context);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateTimeController.text =
            '${picked.year}/${picked.month}/${picked.day}';
        _authData['birthDate'] = picked;
      });
  }

  List<Asset> images = List<Asset>();
  Future<void> pickImage() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: false,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "FlutterCorner.com",
        ),
      );
      images = resultList;
    } catch (e) {
      print(e);
      showMessageDialog(
          context: this.context,
          msgTitle: 'Warning',
          msgText: ['Something went wrong.', 'Please try again'],
          buttonText: 'OK');
    }
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();
    final tempDirectory = Directory.systemTemp;
    print(tempDirectory.path);
    final tempFile = File('${tempDirectory.path}/${asset.name}');
    print(tempFile.path);
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    return file;
  }

  Future<List<File>> getImageFilesFromAssets(List<Asset> assets) async {
    List<File> files = [];
    for (var value in assets) {
      files.add(await getImageFileFromAssets(value));
    }
    return files;
  }

  //
  // Future uploadImageToFirebase(List <File> files) async {
  //   try {
  //     print('Start upload File To Firebase');
  //     int counter =0;
  //     for (var file in files) {
  //       Reference firebaseStorageRef =
  //       FirebaseStorage.instance.ref();
  //       firebaseStorageRef.child('Java/ch1').putFile(file).then((
  //           TaskSnapshot taskSnapshot) {
  //         taskSnapshot.ref.getDownloadURL().then(
  //               (value) => print("Done: $value"),
  //         );
  //
  //       });
  //       var ref = FirebaseStorage.instance.ref().child('Java/ch1').getDownloadURL();
  //       print("");
  //
  //       counter ++;
  //     }
  //   }catch(e) {
  //     print('error From uploadImageToFirebase\n$e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.SignUp ? 420.0 : 280,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.SignUp ? 420 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (_authMode == AuthMode.SignUp) //First Name
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp,
                    controller: _fNameController,
                    decoration: InputDecoration(labelText: 'First Name'),
                    autovalidateMode: _fNameValidateMode,
                    onSaved: (value) {
                      _authData['fName'] = value;
                    },
                    validator: (value) {
                      if (_isChanging) return null;
                      if (value == '' || value == null) {
                        _fNameValidateMode = AutovalidateMode.always;
                        return 'Invalid First Name!';
                      }
                      return null;
                    },
                  ),
                if (_authMode == AuthMode.SignUp) // Last Name
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp,
                    controller: _lNameController,
                    decoration: InputDecoration(labelText: 'Last Name'),
                    autovalidateMode: _lNameValidateMode,
                    onSaved: (value) {
                      _authData['lName'] = value;
                    },
                    validator: (value) {
                      if (_isChanging) return null;
                      if (value == '' || value == null) {
                        _lNameValidateMode = AutovalidateMode.always;
                        return 'Invalid Last Name!';
                      }
                      return null;
                    },
                  ),
                //Email
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  autovalidateMode: _emailValidateMode,
                  validator: (value) {
                    print(value);
                    if (_isChanging) return null;
                    if (!isEmailChecker(value)) {
                      _emailValidateMode = AutovalidateMode.always;
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    print(value);
                    _authData['email'] = value;
                  },
                ),
                //Password
                if (_authMode == AuthMode.Login ||
                    (_authMode == AuthMode.SignUp &&
                        currentUserType == UserType.NormalUser))
                  TextFormField(
                    enabled: (_authMode == AuthMode.Login ||
                        (_authMode == AuthMode.SignUp &&
                            currentUserType == UserType.NormalUser)),
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    autovalidateMode: _passwordValidateMode,
                    validator: (value) {
                      if (_isChanging) return null;
                      if (!checkPasswordStrength(value) &&
                          _authMode == AuthMode.SignUp) {
                        _passwordValidateMode = AutovalidateMode.always;
                        print('Password = $value');
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                if (_authMode == AuthMode.SignUp &&
                    currentUserType == UserType.NormalUser) // Confirm Password
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp &&
                        currentUserType == UserType.NormalUser,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.SignUp
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                if (_authMode == AuthMode.SignUp &&
                    currentUserType == UserType.NormalUser) // Health Status
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp &&
                        currentUserType == UserType.NormalUser,
                    decoration: InputDecoration(labelText: 'Health Status'),
                    onSaved: (value) {
                      _authData['healthStatus'] = value;
                    },
                  ),
                if (_authMode == AuthMode.SignUp &&
                    currentUserType == UserType.NormalUser) // Birth Date
                  FocusScope(
                    node: FocusScopeNode(),
                    child: TextFormField(
                      controller: _dateTimeController,
                      decoration: InputDecoration(
                        labelText: 'Birth Date',
                      ),
                      onTap: () async {
                        await _selectDate(context);
                        print('picked Date ${_authData['birthDate']}');
                      },
                    ),
                  ),
                if (_authMode == AuthMode.SignUp &&
                    currentUserType == UserType.NormalUser) // Address
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp &&
                        currentUserType == UserType.NormalUser,
                    decoration: InputDecoration(labelText: 'Address'),
                    onSaved: (value) {
                      _authData['address'] = value;
                    },
                  ),
                if (_authMode == AuthMode.SignUp &&
                    currentUserType == UserType.PharmacyUser) //Experience
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp &&
                        currentUserType == UserType.PharmacyUser,
                    decoration: InputDecoration(labelText: 'Experience'),
                    onSaved: (value) {
                      _authData['experience'] = value;
                    },
                  ),
                if (_authMode == AuthMode.SignUp &&
                    currentUserType == UserType.PharmacyUser) //phoneNo
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp &&
                        currentUserType == UserType.PharmacyUser,
                    decoration: InputDecoration(labelText: 'Phone No'),
                    onSaved: (value) {
                      _authData['phoneNo'] = value;
                    },
                  ),
                if (_authMode == AuthMode.SignUp &&
                    currentUserType == UserType.PharmacyUser) //pharmacy name
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp &&
                        currentUserType == UserType.PharmacyUser,
                    decoration: InputDecoration(labelText: 'Pharmacy Name'),
                    onSaved: (value) {
                      _authData['pharmacyName'] = value;
                    },
                  ),
                if (_authMode == AuthMode.SignUp &&
                    currentUserType == UserType.PharmacyUser) //pharmacy phoneNo
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp &&
                        currentUserType == UserType.PharmacyUser,
                    decoration: InputDecoration(labelText: 'Pharmacy Phone No'),
                    onSaved: (value) {
                      _authData['pharmacyPhoneNo'] = value;
                    },
                  ),
                SizedBox(
                  height: 4,
                ),
                if (_authMode == AuthMode.SignUp &&
                    currentUserType == UserType.PharmacyUser)
                  ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: Icon(Icons.add_a_photo,
                        color: Colors.white, size: 20.0),
                    label: Text('Upload Pharmacy Document'),
                  ),
                SizedBox(
                  height: 8,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(_authMode == AuthMode.Login
                        ? 'LOGIN'
                        : (currentUserType == UserType.NormalUser
                            ? 'SIGN UP'
                            : 'Request User')),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGN UP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthCardEmployee extends StatefulWidget {
  const AuthCardEmployee({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardEmployeeState createState() => _AuthCardEmployeeState();
}

class _AuthCardEmployeeState extends State<AuthCardEmployee>
    with CanShowMessages {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> _authData = {
    'email': '',
    'password': '',
    'fName': '',
    'lName': '',
    'phoneNo': '',
    'experience': ''
  };

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();

  AutovalidateMode _passwordValidateMode = AutovalidateMode.disabled;
  AutovalidateMode _emailValidateMode = AutovalidateMode.disabled;
  AutovalidateMode _fNameValidateMode = AutovalidateMode.disabled;
  AutovalidateMode _lNameValidateMode = AutovalidateMode.disabled;
  var _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<FireBaseAuth>(context, listen: false).addEmployeeUser(
          _authData['email'],
          _authData['password'],
          _authData['fName'],
          _authData['lName'],
          _authData['phoneNo'],
          _authData['experience'],
          Provider.of<FireBaseAuth>(context, listen: false).pharmacyId);
      showMessageDialog(
          context: this.context,
          msgTitle: 'Confirm',
          msgText: [
            'Your Employee User created Successfully.',
          ],
          buttonText: 'OK');

      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } catch (e) {
      showMessageDialog(
          context: this.context,
          msgTitle: 'Warning',
          msgText: ['$e', 'Please try again'],
          buttonText: 'OK');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: 320,
        constraints: BoxConstraints(minHeight: 270),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //First Name
                TextFormField(
                  controller: _fNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                  autovalidateMode: _fNameValidateMode,
                  onSaved: (value) {
                    _authData['fName'] = value;
                  },
                  validator: (value) {
                    if (value == '' || value == null) {
                      _fNameValidateMode = AutovalidateMode.always;
                      return 'Invalid First Name!';
                    }
                    return null;
                  },
                ),
                // Last Name
                TextFormField(
                  controller: _lNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  autovalidateMode: _lNameValidateMode,
                  onSaved: (value) {
                    _authData['lName'] = value;
                  },
                  validator: (value) {
                    if (value == '' || value == null) {
                      _lNameValidateMode = AutovalidateMode.always;
                      return 'Invalid Last Name!';
                    }
                    return null;
                  },
                ),
                //Email
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  autovalidateMode: _emailValidateMode,
                  validator: (value) {
                    print(value);
                    if (!isEmailChecker(value)) {
                      _emailValidateMode = AutovalidateMode.always;
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    print(value);
                    _authData['email'] = value;
                  },
                ),
                //Password
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  autovalidateMode: _passwordValidateMode,
                  validator: (value) {
                    if (!checkPasswordStrength(value)) {
                      _passwordValidateMode = AutovalidateMode.always;
                      print('Password = $value');
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                //Confirm Password
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match!';
                    }
                    return null;
                  },
                ),
                //Experience
                TextFormField(
                  decoration: InputDecoration(labelText: 'Experience'),
                  onSaved: (value) {
                    _authData['experience'] = value;
                  },
                ),
                //phoneNo
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone No'),
                  onSaved: (value) {
                    _authData['phoneNo'] = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text('Create User'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
 