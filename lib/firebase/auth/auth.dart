import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduationproject/data_models/Patient.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/data_models/Pharmacy.dart';
import 'package:graduationproject/data_models/User.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseAuth with ChangeNotifier {

  FireBaseAuth() {
    loggedUser = auth.currentUser;
    checkUser();
  }

  final _fireStore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  User _loggedUser ;

  set loggedUser(User value){
    _loggedUser = value;
  }

  User get loggedUser{
    return auth.currentUser;
  }

  UserType loggedUserType;

  String pharmacyId;

  bool get isAuth {
    print('isAuth = ${loggedUser != null}');
    return loggedUser != null;
  }

  Patient _patient;
  Pharmacist _pharmacist;

  reset() {
    loggedUser = null;
    loggedUserType = null;
    _patient = null;
    _pharmacist = null;
    notifyListeners();
  }

  void checkUser() {
    auth.authStateChanges().listen((User user) async {
      if (user == null && loggedUser != null) {
        reset();
      } else if (user != null && loggedUser != null) {
        print(user);
        if (loggedUser.uid != user.uid) {
          loggedUser = user;
          await getCurrentUserData();
          notifyListeners();
        }else if ( loggedUser.uid == user.uid ){
          loggedUser = user;
          notifyListeners();
        }
      }
    });
  }

  get currentUser async {
    if (loggedUser != null) {
      if (loggedUserType == UserType.NormalUser && _patient != null)
        return _patient;
      else if ((loggedUserType == UserType.EmployeeUser ||
              loggedUserType == UserType.PharmacyUser) &&
          _pharmacist != null)
        return _pharmacist;
      else {
        await getCurrentUserData();
        if (loggedUserType == UserType.NormalUser)
          return _patient;
        else if (loggedUserType == UserType.EmployeeUser ||
            loggedUserType == UserType.PharmacyUser)
          return _pharmacist;
      }
    }
    return null;
  }

  Future<void> _signUpNew(String email, String pass) async {
    try {
      final newUser = await auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      if (newUser != null) {
        this.loggedUser = newUser.user;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> _createUser(String email, String pass) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC5CamIvBMxL2AM7Pmz4159ZI0PSXUtJHc";
    try {
      print('Start Create Emp User');
      final res = await http.post(url,
          body: json.encode(
              {'email': email, 'password': pass, 'returnSecureToken': true}));
      final resdata = json.decode(res.body);
      print(resdata);
      if (resdata['error'] != null) {
        print('ERROR in create emp user $resdata');
        String errMsg = getErrorMessage(resdata['error']['message'].toString());
        throw '$errMsg';
      }
    } catch (e) {
      throw e;
    }
  }

  String getErrorMessage(String error) {
    String errMsg = 'Authentication Error';
    if (error.contains('EMAIL_EXISTS'))
      errMsg = 'This email address is already in use.';
    else if (error.contains('INVALID_EMAIL'))
      errMsg = 'This is not a valid email address.';
    else if (error.contains('WEAK_PASSWORD'))
      errMsg = 'This password is too weak.';
    else if (error.contains('EMAIL_NOT_FOUND'))
      errMsg = 'Could not find a user with this email .';
    else if (error.contains('INVALID_PASSWORD')) errMsg = 'Invalid Password.';
    return errMsg;
  }

  Future<void> logInNew(String email, String pass) async {
    try {
      final newUser = await auth.signInWithEmailAndPassword(
          email: email.trim(), password: pass);
      if (newUser != null) {
        this.loggedUser = newUser.user;
        print(this.loggedUser);
        await getCurrentUserData();
        print('From LogIn Method $loggedUser');
        print('From LogIn Method $loggedUserType');
      }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void setNormalUserData(
      String uId,
      String email,
      String fName,
      String lName,
      String phoneNo,
      String healthStatus,
      String address,
      DateTime birthDate) async {
    try {
      loggedUserType = UserType.NormalUser;
      _patient = Patient();
      _patient.userId = uId;
      _patient.email = email;
      _patient.fName = fName;
      _patient.lName = lName;
      _patient.phoneNo = phoneNo;
      _patient.healthState = healthStatus;
      _patient.address = address;
      _patient.birthDate = birthDate;
    } catch (e) {
      throw e;
    }
  }

  Future<void> getCurrentUserData() async {
    try {
      var querySnapshot = await _fireStore.collection('USER').get();
      var user = querySnapshot.docs
          .where((element) => element['email'] == this.loggedUser.email);
      if (user != null) {
        switch (user.first.data()['type']) {
          case 'NormalUser':
            loggedUserType = UserType.NormalUser;
            _patient = Patient();
            _patient.userId = user.first.id;
            _patient.email = loggedUser.email;
            _patient.fName = user.first.data()['fName'];
            _patient.lName = user.first.data()['lName'];
            _patient.phoneNo = user.first.data()['phoneNo'];

            var querySnapshotData =
                await _fireStore.collection('PATIENT').get();
            var userData = querySnapshotData.docs
                .where((element) => element['id'] == _patient.userId);
            if (userData != null) {
              _patient.healthState = userData.first.data()['healthStatus'];
              _patient.address = userData.first.data()['address'];
              Timestamp stamp = userData.first.data()['birthDate'];
              _patient.birthDate = stamp.toDate();
            }

            break;
          case 'PharmacyUser':
            loggedUserType = UserType.PharmacyUser;
            _pharmacist = Pharmacist();
            _pharmacist.userType = UserType.PharmacyUser;
            _pharmacist.userId = user.first.id;
            _pharmacist.email = loggedUser.email;
            _pharmacist.fName = user.first.data()['fName'];
            _pharmacist.lName = user.first.data()['lName'];
            _pharmacist.phoneNo = user.first.data()['phoneNo'];

            pharmacyId = "";

            var querySnapshotData =
                await _fireStore.collection('PHARMACIST').get();
            var userData = querySnapshotData.docs
                .where((element) => element['id'] == _pharmacist.userId);
            if (userData != null) {
              _pharmacist.experience = userData.first.data()['experience'];
              _pharmacist.pharmacy = Pharmacy();
              _pharmacist.pharmacy.pharmacyId =
                  userData.first.data()['pharmacyId'];
              pharmacyId = userData.first.data()['pharmacyId'];

              var querySnapshotPharmacyData =
                  await _fireStore.collection('PHARMACY').get();
              var pharmacyData = querySnapshotPharmacyData.docs
                  .where((element) => element.id == pharmacyId);
              if (pharmacyData != null) {
                _pharmacist.pharmacy.name =
                    pharmacyData.first.data()['pharmacyName'];
                _pharmacist.pharmacy.phoneNo =
                    pharmacyData.first.data()['phoneNo'];
              }
            }

            break;
          case 'EmployeeUser':
            loggedUserType = UserType.EmployeeUser;
            _pharmacist = Pharmacist();
            _pharmacist.userType = UserType.EmployeeUser;
            _pharmacist.userId = user.first.id;
            _pharmacist.email = loggedUser.email;
            _pharmacist.fName = user.first.data()['fName'];
            _pharmacist.lName = user.first.data()['lName'];
            _pharmacist.phoneNo = user.first.data()['phoneNo'];

            pharmacyId = "";

            var querySnapshotData =
                await _fireStore.collection('PHARMACIST').get();
            var userData = querySnapshotData.docs
                .where((element) => element['id'] == _pharmacist.userId);
            if (userData != null) {
              _pharmacist.experience = userData.first.data()['experience'];
              _pharmacist.pharmacy = Pharmacy();
              _pharmacist.pharmacy.pharmacyId =
                  userData.first.data()['pharmacyId'];
              pharmacyId = userData.first.data()['pharmacyId'];

              var querySnapshotPharmacyData =
                  await _fireStore.collection('PHARMACY').get();
              var pharmacyData = querySnapshotPharmacyData.docs
                  .where((element) => element.id == pharmacyId);
              if (pharmacyData != null) {
                _pharmacist.pharmacy.name =
                    pharmacyData.first.data()['pharmacyName'];
                _pharmacist.pharmacy.phoneNo =
                    pharmacyData.first.data()['phoneNo'];
              }
            }

            break;
          default:
            loggedUserType = UserType.Guest;
            break;
        }
        print(loggedUserType);
      }
    } catch (e) {
      print('Error from Get Method $e');
      throw e;
    }
  }

  Future<void> signUpWithPhone(String phone, String pass) async {
    try {
      var res = await auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!
          // Sign the user in (or link) with the auto-generated credential
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException error) {
          print('FirebaseAuthException ====>>>> $error');
          // if (error.code == 'invalid-phone-number') {
          //   print('The provided phone number is not valid.');
          // }
          //
          // print("Error message: " + error.message);
          String status = '';
          if (error.message.contains('not authorized'))
            status = 'Something has gone wrong, please try later';
          else if (error.message.contains('Network'))
            status = 'Please check your internet connection and try again';
          else
            status = 'Something has gone wrong, please try later';
          print(' status ------------ $status');
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          print('verificationId ====>>>> $verificationId');
        },
        codeSent: (String verificationId, int forceResendingToken) async {
          print(
              'verificationId === >>>>> $verificationId *** forceResendingToken === >>>>>  $forceResendingToken');
          // Update the UI - wait for the user to enter the SMS code
          String smsCode = '123456';

          // Create a PhoneAuthCredential with the code
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: smsCode);

          UserCredential cred =
              await auth.signInWithCredential(phoneAuthCredential);
          print('Current User ${auth.currentUser} ');
          print('UserCredential $cred ');
        },
      );
      print('Finish');
      return res;
    } catch (e) {
      print(e);
    }
  }

  logout() {
    loggedUser = null;
    loggedUserType = null;
    _patient = null;
    _pharmacist = null;
    auth.signOut();
    notifyListeners();
  }

  deleteUser() async {
    loggedUser = null;
    loggedUserType = null;
    pharmacyId = '';
    _patient = null;
    _pharmacist = null;
    await auth.currentUser.delete();
    notifyListeners();
  }

  Future<void> signUpNormalUserWithAllData(
      String email,
      String pass,
      String fName,
      String lName,
      String phoneNo,
      String healthStatus,
      String address,
      DateTime birthDate) async {
    try {
      await _signUpNew(email, pass);
      var ret = await _fireStore.collection('USER').add({
        'fName': fName,
        'lName': lName,
        'email': email,
        'phoneNo': phoneNo,
        'type': 'NormalUser'
      });
      var ret2 = await _fireStore.collection('PATIENT').add({
        'id': ret.id,
        'healthStatus': healthStatus,
        'address': address,
        'birthDate': birthDate
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUpNormalUser(String email, String pass) async {
    try {
      await _signUpNew(email, pass);
      print(loggedUser);
    } catch (error) {
      throw error;
    }
  }

  Future<String> addNormalUser(
      String email,
      String fName,
      String lName,
      String phoneNo,
      String healthStatus,
      String address,
      DateTime birthDate) async {
    try {
      print(loggedUser);
      // print ('loggedUser Data From Add Method\n \'fName\':$fName,\'lName\':$lName,\'email\':$email,\'phoneNo\':$phoneNo,\'type\':NormalUser,\'healthStatus\':$healthStatus,\'address\':$address,\'birthDate\':${birthDate.toString()}');
      var ret = await _fireStore.collection('USER').add({
        'fName': fName,
        'lName': lName,
        'email': email,
        'phoneNo': phoneNo,
        'type': 'NormalUser'
      });
      var ret2 = await _fireStore.collection('PATIENT').add({
        'id': ret.id,
        'healthStatus': healthStatus,
        'address': address,
        'birthDate': birthDate
      });
      loggedUser.updateProfile(displayName: '$fName $lName');
      return ret.id;
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUpPharmacyWithUser(String email, String fName, String lName,
      String phoneNo, String experience,
      {String pharmacyName, String pharmacyPhoneNo, List<File> files}) async {
    try {
      var ret = await _fireStore.collection('TempUSER').add({
        'fName': fName,
        'lName': lName,
        'email': email,
        'phoneNo': phoneNo,
        'type': 'PharmacyUser'
      });
      var ret2 = await _fireStore.collection('TempPHARMACY').add({
        'pharmacyName': pharmacyName,
        'phoneNo': pharmacyPhoneNo,
        'pharmacistId': ret.id
      });
      var ret3 = await _fireStore
          .collection('TempPHARMACIST')
          .add({'id': ret.id, 'experience': experience, 'pharmacyId': ret2.id});

      for (int i = 0; i < files.length; i++) {
        uploadImageToFirebase(
            file: files[i], filePathInStorage: '${ret2.id}/$i');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addEmployeeUser(
      String email,
      String pass,
      String fName,
      String lName,
      String phoneNo,
      String experience,
      String pharmacyId) async {
    try {
      await _createUser(email, pass);
      var ret = await _fireStore.collection('USER').add({
        'fName': fName,
        'lName': lName,
        'email': email,
        'phoneNo': phoneNo,
        'type': 'EmployeeUser'
      });
      var ret2 = await _fireStore.collection('PHARMACIST').add(
          {'id': ret.id, 'experience': experience, 'pharmacyId': pharmacyId});
    } catch (error) {
      throw error;
    }
  }

  Future<String> uploadImageToFirebase(
      {@required File file, @required String filePathInStorage}) async {
    String fileURL = '';
    try {
      print('Start upload File To Firebase');
      Reference firebaseStorageRef = FirebaseStorage.instance.ref();
      firebaseStorageRef
          .child(filePathInStorage)
          .putFile(file)
          .then((TaskSnapshot taskSnapshot) {
        taskSnapshot.ref.getDownloadURL().then((value) {
          print("Done: $value");
          fileURL = value;
        });
      });
    } catch (e) {
      print('error From uploadImageToFirebase\n$e');
    }
    return fileURL;
  }

  Future<void> changeUserProfileImage({@required File file}) async {
    String fileURL = '';
    try {
      print('Start upload Profile Image To Firebase');
      String userId = '';
      if (loggedUserType == UserType.NormalUser)
        userId = _patient.userId;
      else
        userId = _pharmacist.userId;
      Reference firebaseStorageRef = FirebaseStorage.instance.ref();
      firebaseStorageRef
          .child('$userId/$userId')
          .putFile(file)
          .then((TaskSnapshot taskSnapshot) {
        taskSnapshot.ref.getDownloadURL().then((value) async {
          print("Done: $value");
          fileURL = value;
          await auth.currentUser.updateProfile(photoURL: fileURL);
          print(auth.currentUser.photoURL);
          loggedUser = auth.currentUser;
          print(loggedUser.photoURL);
        });
      });

    } catch (e) {
      print('error From change User profile Image\n$e');
    }
  }

}
