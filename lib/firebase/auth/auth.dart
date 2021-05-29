import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/data_models/OrderClass.dart';
import 'package:graduationproject/data_models/Patient.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/data_models/Pharmacy.dart';
import 'package:graduationproject/data_models/Product.dart';
import 'package:graduationproject/data_models/User.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseAuth with ChangeNotifier, CanShowMessages {
  static FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore get fireStore {
    return _fireStore;
  }

  Pharmacist get pharmacist {
    return _pharmacist;
  }

  // BuildContext context ;
  String key = '123';
  bool isLoading;

  Timer timer;
  UserType loggedUserType;
  String pharmacyId;
  Patient _patient;
  Pharmacist _pharmacist;
  User _loggedUser;
  String userId;
  String photoUri;

  Patient get patient {
    return _patient;
  }

  FireBaseAuth() {
    loggedUser = auth.currentUser;
    isLoading = true;
    if (isAuth) getCurrentUserData();

    // timer = Timer.periodic(Duration(seconds: 5), timerMethod);
    // checkUser();
  }

  Future<void> timerMethod(Timer timer) async {
    // print('Time from timerMethod : ${DateTime.now()}');
    if (isAuth) {
      await auth.currentUser.reload().catchError((e) async {
        print('Error from timerMethod $e');
        print('Error from timerMethod ${e.runtimeType}');
        print('Error from timerMethod ${e.message}');
        reset();
        var msgTxt = ['Something went wrong.', 'Please try again'];
        switch (e.code) {
          case 'user-not-found':
            msgTxt = [
              'Maybe your account is deleted.',
              'Please contact App administrator to get more info.'
            ];
            break;
          case 'network-request-failed':
            msgTxt = ['No Internet Connection.'];
            break;
          case 'user-disabled':
            msgTxt = [
              'Your account is disabled.',
              'Please contact App administrator to get more info.'
            ];
            break;
          default:
            msgTxt = ['Something went wrong.', 'Please try again'];
            break;
        }
        print(msgTxt);
        // await showMessageDialog(
        //     context: this.context,
        //     msgTitle: 'Warning',
        //     msgText: msgTxt,
        //     buttonText: 'OK');
        // Navigator.pushNamedAndRemoveUntil(context, SplashScreen.routeName, (route) => false);
      });
      notifyListeners();
    }
  }

  get currentUser async {
    try {
      if (loggedUser != null) {
        if (loggedUserType == UserType.NormalUser && _patient != null)
          return _patient;
        else if ((loggedUserType == UserType.EmployeeUser ||
                loggedUserType == UserType.PharmacyUser) &&
            _pharmacist != null)
          return _pharmacist;
        else {
          await getCurrentUserData().catchError((e) {
            print(" error from get currentUser from getCurrentUserData => $e");
          });
          if (loggedUserType == UserType.NormalUser)
            return _patient;
          else if (loggedUserType == UserType.EmployeeUser ||
              loggedUserType == UserType.PharmacyUser) return _pharmacist;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  bool get isAuth {
    // print('isAuth = ${loggedUser != null}');
    return loggedUser != null;
  }

  set loggedUser(User value) {
    _loggedUser = value;
  }

  User get loggedUser {
    return auth.currentUser;
  }

  reset() {
    loggedUser = null;
    loggedUserType = null;
    _patient = null;
    _pharmacist = null;
    notifyListeners();
  }

  void checkUser() {
    // auth.userChanges().listen((user) async {
    //   if (user == null ) {
    //     logout();
    //   } else if (user != null && loggedUser != null) {
    //     print('User From Stream $user');
    //     if (loggedUser.uid != user.uid) {
    //       logout();
    //       // loggedUser = user;
    //       // await getCurrentUserData();
    //       notifyListeners();
    //     }else if ( loggedUser.uid == user.uid ){
    //       loggedUser = user;
    //       notifyListeners();
    //     }
    //   }
    // });
    auth.authStateChanges().listen((User user) async {
      if (user == null && loggedUser != null) {
        reset();
      } else if (user != null && isAuth) {
        print('user from CheckUser method $user');
        // if (loggedUser.uid != user.uid) {
        //   loggedUser = user;
        //   await getCurrentUserData();
        //   notifyListeners();
        // }else if ( loggedUser.uid == user.uid ){
        //   loggedUser = user;
        //   notifyListeners();
        // }

      }
    });
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
      print('Response from Create Emp User $resdata');
      if (resdata['error'] != null) {
        print('ERROR in create emp user $resdata');
        String errMsg = getErrorMessage(resdata['error']['message'].toString());
        throw '$errMsg';
      }
    } catch (e) {
      print('Error from Create Emp User $e');
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

  Future<UserType> getCurrentUserData() async {
    try {
      print('Start getCurrentUserData ');
      if (!isAuth) return null;
      var querySnapshot = await _fireStore.collection('USER').get();
      var user = querySnapshot.docs.where((element) =>
          element['email'].toString().toLowerCase() ==
          this.loggedUser.email.toString().toLowerCase());

      print('after');
      if (user != null && user.length > 0) {
        switch (user.first.data()['type']) {
          case 'NormalUser':
            loggedUserType = UserType.NormalUser;
            _patient = Patient();
            _patient.userId = user.first.id;
            userId = user.first.id;
            _patient.email = loggedUser.email;
            photoUri = user.first.data()['photoUri'];
            _patient.fName = user.first.data()['fName'];
            _patient.lName = user.first.data()['lName'];
            _patient.phoneNo = user.first.data()['phoneNo'];

            var querySnapshotData =
                await _fireStore.collection('PATIENT').get();
            var userData = querySnapshotData.docs
                .where((element) => element['id'] == _patient.userId);
            if (userData != null) {
              _patient.patientId = userData.first.id;
              _patient.healthState = userData.first.data()['healthStatus'];
              _patient.address = userData.first.data()['address'];
              _patient.gender = userData.first.data()['gender'];
              _patient.age = userData.first.data()['age'];
              _patient.addressGeoPoint =
                  userData.first.data()['addressGeoPoint'];
              Timestamp stamp = userData.first.data()['birthDate'];
              if (stamp != null) _patient.birthDate = stamp.toDate();
            }

            break;
          case 'PharmacyUser':
            loggedUserType = UserType.PharmacyUser;
            print('after1');
            _pharmacist = Pharmacist();
            _pharmacist.userType = UserType.PharmacyUser;
            _pharmacist.userId = user.first.id;
            userId = user.first.id;
            _pharmacist.email = loggedUser.email;
            _pharmacist.fName = user.first.data()['fName'];
            _pharmacist.lName = user.first.data()['lName'];
            _pharmacist.phoneNo = user.first.data()['phoneNo'];

            pharmacyId = "";
            print('after2');
            var querySnapshotData =
                await _fireStore.collection('PHARMACIST').get();
            var userData = querySnapshotData.docs
                .where((element) => element['id'] == _pharmacist.userId);
            if (userData != null) {
              print('after3');
              _pharmacist.experience = userData.first.data()['experience'];
              _pharmacist.pharmacy = Pharmacy();
              _pharmacist.pharmacy.pharmacyId =
                  userData.first.data()['pharmacyId'];
              pharmacyId = userData.first.data()['pharmacyId'];
              print('after4');
              var querySnapshotPharmacyData =
                  await _fireStore.collection('PHARMACY').get();
              var pharmacyData = querySnapshotPharmacyData.docs
                  .where((element) => element.id == pharmacyId);
              if (pharmacyData != null) {
                print('after5');
                _pharmacist.pharmacy.name =
                    pharmacyData.first.data()['pharmacyName'];
                _pharmacist.pharmacy.phoneNo =
                    pharmacyData.first.data()['phoneNo'];
                _pharmacist.pharmacy.addressGeo =
                    pharmacyData.first.data()['addressGeoPoint'];
                print('after6');
              }
            }

            break;
          case 'EmployeeUser':
            loggedUserType = UserType.EmployeeUser;
            _pharmacist = Pharmacist();
            _pharmacist.userType = UserType.EmployeeUser;
            _pharmacist.userId = user.first.id;
            userId = user.first.id;
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
                _pharmacist.pharmacy.addressGeo =
                    pharmacyData.first.data()['addressGeoPoint'];
              }
            }

            break;
          default:
            loggedUserType = UserType.Guest;
            break;
        }
        print(loggedUserType);
        isLoading = false;
        return loggedUserType;
      } else
        return null;
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
    key = '1234';
    userId = '';
    photoUri = '';
    auth.signOut();
    notifyListeners();
  }

  Future<void> deleteUser() async {
    try {
      loggedUser = null;
      loggedUserType = null;
      pharmacyId = '';
      _patient = null;
      _pharmacist = null;
      key = '1234';
      photoUri = '';
      await auth.currentUser.delete();
      notifyListeners();
    } catch (e) {
      print('error Method resetPasswordEmail \n$e');
      throw e;
    }
  }

  Future<void> deleteUserAccount({@required String oldPass}) async {
    try {
      print('Start deleteUserAccount.');
      print('Old Pass is $oldPass');
      AuthCredential authCredential = EmailAuthProvider.credential(
          email: loggedUser.email, password: oldPass);
      print('AuthCredential in reset func. is $authCredential');
      await auth.currentUser.reauthenticateWithCredential(authCredential);
      if ( auth.currentUser.photoURL != null && auth.currentUser.photoURL != ''  ) {
        Reference firebaseStorageRef = FirebaseStorage.instance.ref();
        await firebaseStorageRef.child('$userId/$userId').delete();
      }
      await _fireStore.collection('PATIENT').doc(_patient.patientId).delete();
      await _fireStore.collection('USER').doc(_patient.userId).delete();
      await deleteUser();
    } catch (e) {
      print('error Method deleteUserAccount \n$e');
      throw e;
    }
  }

  Future<void> signUpNormalUserWithAllData(
      String email,
      String pass,
      String fName,
      String lName,
      String phoneNo,
      String healthStatus,
      String address,
      String gender,
      DateTime birthDate,
      GeoPoint addressGeoPoint) async {
    try {
      await _signUpNew(email, pass);
      int age = calculateAge(birthDate);
      var ret = await _fireStore.collection('USER').add({
        'fName': fName,
        'lName': lName,
        'email': email,
        'phoneNo': phoneNo,
        'password': pass,
        'type': 'NormalUser'
      });
      var ret2 = await _fireStore.collection('PATIENT').add({
        'id': ret.id,
        'healthStatus': healthStatus,
        'gender': gender,
        'address': address,
        'birthDate': birthDate,
        'age': age,
        'addressGeoPoint': addressGeoPoint
      });

      loggedUser.updateProfile(displayName: '$fName $lName');
    } catch (error) {
      throw error;
    }
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Future<void> linkLoggedUserWithCredintal({AuthCredential credential}) async {
    try {
      print('credential from linkLoggedUserWithCredintal is $credential');
      UserCredential user =
          await FireBaseAuth.auth.currentUser.linkWithCredential(credential);
      this.loggedUser = user.user;
      print('loggedUser from linkLoggedUserWithCredintal $loggedUser');
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateLoggedUserPhoneNo({AuthCredential credential}) async {
    try {
      print('credential from linkLoggedUserWithCredintal is $credential');
      // UserCredential user =
      //     await FireBaseAuth.auth.currentUser.update
      // this.loggedUser = user.user;
      print('loggedUser from linkLoggedUserWithCredintal $loggedUser');
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUpNormalUser(String email, String pass) async {
    try {
      await _signUpNew(email, pass);
      print('loggedUser from signUpNormalUser $loggedUser');
    } catch (error) {
      throw error;
    }
  }

  Future<String> addNormalUser(
      String email,
      String pass,
      String fName,
      String lName,
      String phoneNo,
      String healthStatus,
      String address,
      String gender,
      DateTime birthDate) async {
    try {
      print('loggedUser from addNormalUser Method $loggedUser');
      // print ('loggedUser Data From Add Method\n \'fName\':$fName,\'lName\':$lName,\'email\':$email,\'phoneNo\':$phoneNo,\'type\':NormalUser,\'healthStatus\':$healthStatus,\'address\':$address,\'birthDate\':${birthDate.toString()}');
      var ret = await _fireStore.collection('USER').add({
        'fName': fName,
        'lName': lName,
        'email': email,
        'phoneNo': phoneNo,
        'password': pass,
        'type': 'NormalUser'
      });
      var ret2 = await _fireStore.collection('PATIENT').add({
        'id': ret.id,
        'healthStatus': healthStatus,
        'gender': gender,
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
      {String pharmacyName,
      String pharmacyPhoneNo,
      GeoPoint addressGeoPoint,
      List<File> files}) async {
    try {
      await auth.signInAnonymously();
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
        'pharmacistId': ret.id,
        'NoOfPharmacyDoc': files.length,
        'addressGeoPoint': addressGeoPoint
      });
      var ret3 = await _fireStore
          .collection('TempPHARMACIST')
          .add({'id': ret.id, 'experience': experience, 'pharmacyId': ret2.id});

      for (int i = 0; i < files.length; i++) {
        await uploadFileToFirebase(
            file: files[i], filePathInStorage: '${ret2.id}/$i');
      }
      await auth.currentUser.delete();
      // await auth.signOut();
    } catch (e) {
      // print(e);
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
      print('Emp User Created Successfully');
      var ret = await _fireStore.collection('USER').add({
        'fName': fName,
        'lName': lName,
        'email': email,
        'phoneNo': phoneNo,
        'password': pass,
        'type': 'EmployeeUser'
      });
      var ret2 = await _fireStore.collection('PHARMACIST').add(
          {'id': ret.id, 'experience': experience, 'pharmacyId': pharmacyId});
    } catch (error) {
      print('Error from addEmployeeUser $error');
      throw error;
    }
  }

  Future<String> uploadFileToFirebase(
      {@required File file, @required String filePathInStorage}) async {
    String fileURL = '';
    try {
      print('Start uploadFileToFirebase');
      Reference firebaseStorageRef = FirebaseStorage.instance.ref();
      await firebaseStorageRef.child(filePathInStorage).putFile(file);
      //     .then((TaskSnapshot taskSnapshot) {
      //   taskSnapshot.ref.getDownloadURL().then((value) {
      //     print("Done: $value");
      //     fileURL = value;
      //   });
      // });
      fileURL =
          await firebaseStorageRef.child(filePathInStorage).getDownloadURL();
    } catch (e) {
      // print('error From uploadFileToFirebase\n$e');
    }
    return fileURL;
  }

  Future<String> changeUserProfileImage({@required File file}) async {
    try {
      print('Start upload Profile Image To Firebase');
      String userId = '';
      if (loggedUserType == UserType.NormalUser)
        userId = _patient.userId;
      else
        userId = _pharmacist.userId;
      // Reference firebaseStorageRef = FirebaseStorage.instance.ref();
      // firebaseStorageRef
      //     .child('$userId/$userId')
      //     .putFile(file)
      //     .then((TaskSnapshot taskSnapshot) {
      //   taskSnapshot.ref.getDownloadURL().then((value) async {
      //     print("Done: $value");
      //     fileURL = value;
      //     await auth.currentUser.updateProfile(photoURL: fileURL);
      //     print(auth.currentUser.photoURL);
      //     loggedUser = auth.currentUser;
      //     auth.currentUser.reload();
      //     print(loggedUser.photoURL);
      //     updateCollectionField(collectionName: 'USER', fieldName: 'photoUri', fieldValue: value, docId: userId);
      //   });
      // });
      String fileURL = await uploadFileToFirebase(
          file: file, filePathInStorage: '$userId/$userId');
      await auth.currentUser.updateProfile(photoURL: fileURL);
      loggedUser = auth.currentUser;
      updateCollectionField(
          collectionName: 'USER',
          fieldName: 'photoUri',
          fieldValue: fileURL,
          docId: userId);
      auth.currentUser.reload();
      photoUri = fileURL;
      notifyListeners();
      return fileURL;
    } catch (e) {
      print('error From change User profile Image\n$e');
      return null;
    }
  }

  Future<void> changeUserName(
      {@required String fNameNew, @required String lNameNew}) async {
    String fileURL = '';
    try {
      print('Start changeUserName');
      String userId = '';
      if (loggedUserType == UserType.NormalUser)
        userId = _patient.userId;
      else
        userId = _pharmacist.userId;
      await updateCollectionField(
          collectionName: 'USER',
          fieldName: 'fName',
          fieldValue: fNameNew,
          docId: userId);
      await updateCollectionField(
          collectionName: 'USER',
          fieldName: 'lName',
          fieldValue: lNameNew,
          docId: userId);
      await loggedUser.updateProfile(displayName: '$fNameNew $lNameNew');
    } catch (e) {
      print('error From changeUserName Method\n$e');
    }
  }

  Future<List<Pharmacist>> getPharmacyEmployees() async {
    List<Pharmacist> employees = [];
    try {
      print('Start get Pharmacy employees from firebase.');
      var querySnapshot = await _fireStore.collection('USER').get();
      if (loggedUserType == UserType.PharmacyUser) {
        var querySnapshotData = await _fireStore.collection('PHARMACIST').get();
        var userData = querySnapshotData.docs
            .where((element) => element['pharmacyId'] == pharmacyId);
        userData.forEach((element) {
          if (_pharmacist.userId != element['id']) {
            Pharmacist pharmacist = Pharmacist();
            var user =
                querySnapshot.docs.where((ele) => ele.id == element['id']);
            pharmacist.userType = UserType.EmployeeUser;
            pharmacist.userId = user.first.id;
            pharmacist.email = user.first.data()['email'];
            pharmacist.fName = user.first.data()['fName'];
            pharmacist.lName = user.first.data()['lName'];
            pharmacist.phoneNo = user.first.data()['phoneNo'];
            pharmacist.pharmacy = Pharmacy();
            pharmacist.pharmacy.name = _pharmacist.pharmacy.name;
            pharmacist.pharmacy.phoneNo = _pharmacist.pharmacy.phoneNo;
            pharmacist.pharmacy.pharmacyId = pharmacyId;
            employees.add(pharmacist);
          }
        });
      } else
        throw new Exception(
            'Logged User does not have permission for this functionality.');
      return employees;
    } catch (e) {
      print('error From get Pharmacy employees from firebas\n$e');
      throw e;
    }
  }

  Future<void> updateCollectionField(
      {@required String collectionName,
      @required String fieldName,
      @required dynamic fieldValue,
      @required String docId}) async {
    try {
      print('Start updateCollectionField.');
      // if (loggedUserType == UserType.EmployeeUser ||
      //     loggedUserType == UserType.PharmacyUser)
      //   _fireStore
      //       .collection(collectionName)
      //       .doc(docId)
      //       .update({fieldName: fieldValue});
      // else if (loggedUserType == UserType.NormalUser)
      //   _fireStore
      //       .collection(collectionName)
      //       .doc(_patient.userId)
      //       .update({fieldName: fieldValue});

      _fireStore
          .collection(collectionName)
          .doc(docId)
          .update({fieldName: fieldValue});
    } catch (e) {
      print('error Method updateCollectionField \n$e');
      throw e;
    }
  }

  Future<void> updateHealthState({
    @required String value,
  }) async {
    try {
      print('Start updateHealthState.');
      await _fireStore
          .collection('PATIENT')
          .doc(patient.patientId)
          .update({'healthStatus': value});
      patient.healthState = value;
      notifyListeners();
    } catch (e) {
      print('error Method updateHealthState \n$e');
      throw e;
    }
  }

  Future<void> updateUserProfileData({
    @required String fName,
    @required String lName,
    @required String address,
    @required String gender,
    @required DateTime birthDate,
  }) async {
    try {
      print('Start updateUserProfileData.');
      if (fName != null && lName != null) {
        print('Change FName and LName');
        await changeUserName(fNameNew: fName, lNameNew: lName);
      } else if (fName != null) {
        print('Change FName');
        await changeUserName(fNameNew: fName, lNameNew: _patient.lName);
      } else if (lName != null) {
        print('Change LName');
        await changeUserName(fNameNew: _patient.fName, lNameNew: lName);
      }

      Map<String, dynamic> values = {};
      if (address != null) {
        values.addAll({'address': address});
        patient.address = address;
      }
      if (gender != null) {
        values.addAll({'gender': gender});
        patient.gender = gender;
      }
      if (birthDate != null) {
        int age = calculateAge(birthDate);
        values.addAll({'birthDate': birthDate, 'age': age});
        patient.birthDate = birthDate;
        patient.age = age;
      }
      print(values);
      if (values.length > 0)
        await _fireStore
            .collection('PATIENT')
            .doc(patient.patientId)
            .update(values);
      patient.healthState = '';
      notifyListeners();
    } catch (e) {
      print('error Method updateUserProfileData \n$e');
      throw e;
    }
  }

  Future<bool> checkUserExistence({@required String email}) async {
    try {
      print('Start checkUserExistence ');
      var querySnapshot = await _fireStore.collection('USER').get();
      var user = querySnapshot.docs.where((element) =>
          element['email'].toString().toLowerCase() == email.toLowerCase());
      if (user != null && user.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error from checkUserExistence Method $e');
      // return false ;
      throw e;
    }
  }

  Future<int> checkPharmacyUserExistence({@required String email}) async {
    try {
      print('Start checkPharmacyUserExistence ');
      var querySnapshot = await _fireStore.collection('USER').get();
      var user = querySnapshot.docs.where((element) =>
          element['email'].toString().toLowerCase() == email.toLowerCase());

      var querySnapshotTemp = await _fireStore.collection('TempUSER').get();
      var userTemp = querySnapshotTemp.docs.where((element) =>
          element['email'].toString().toLowerCase() == email.toLowerCase());
      if (user != null && user.length > 0) {
        return 1;
      }
      if (userTemp != null && userTemp.length > 0) {
        return 2;
      }
      return 0;
    } catch (e) {
      print('Error from checkPharmacyUserExistence Method $e');
      // return false ;
      throw e;
    }
  }

  ///If user account exist, this method will send forget email
  Future<bool> forgetPasswordEmail({String email}) async {
    try {
      print('Start forgetPasswordEmail.');
      if (await checkUserExistence(email: email)) {
        await auth.sendPasswordResetEmail(email: email);
        return true;
      }
      return false;
    } catch (e) {
      print('error Method forgetPasswordEmail \n$e');
      return false;
    }
  }

  Future<void> resetPasswordEmail({String oldPass, String newPass}) async {
    try {
      print('Start resetPasswordEmail.');
      print('Old Pass is $oldPass');
      print('New Pass is $newPass');
      AuthCredential authCredential = EmailAuthProvider.credential(
          email: loggedUser.email, password: oldPass);
      print('AuthCredential in reset func. is $authCredential');
      await auth.currentUser.reauthenticateWithCredential(authCredential);
      await loggedUser.updatePassword(newPass);
      await loggedUser.reload();
    } catch (e) {
      print('error Method resetPasswordEmail \n$e');
      throw e;
    }
  }

  Future<void> verifyEmail() async {
    try {
      print('Start verifyEmail.');
      print('Email verified ${loggedUser.emailVerified}');
      if (!loggedUser.emailVerified)
        auth.currentUser.sendEmailVerification();
      else
        auth.currentUser.reload();
    } catch (e) {
      print('error Method verifyEmail \n$e');
      // throw e;
    }
  }

  Future<int> getOrderNo() async {
    try {
      var doc = await _fireStore.collection('Order').get();
      if (doc != null) {
        return doc.docs.length;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getUserCartProductsNo() async {
    try {
      var doc = await _fireStore
          .collection('PATIENT')
          .doc(_patient.patientId)
          .collection('Cart')
          .orderBy('OrderNo',descending: true ).get();
      if (doc != null) {
        return doc.docs.first.data()['OrderNo'];
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> orderProducts({
    Order orders,
  }) async {
    try {
      int ordersNo = await getOrderNo();
      // double distance = await Location.getDistance(startLatitude: _patient.addressGeoPoint.latitude, startLongitude: _patient.addressGeoPoint.longitude, endLatitude: orders.pharmacy.addressGeo.latitude, endLongitude: orders.pharmacy.addressGeo.longitude);
      var ret = await _fireStore.collection('Order').add({
        'pharmacyId': orders.pharmacy.pharmacyId,
        'pharmacyName': orders.pharmacy.name,
        'pharmacyAddress': orders.pharmacy.addressGeo,
        'pharmacyPhoneNo': orders.pharmacy.phoneNo,
        'distance': orders.pharmacy.distance,
        'userId': _patient.userId,
        'userName': '${_patient.fName} ${_patient.lName}',
        'userHealthState': _patient.healthState,
        'userAge': _patient.age,
        'orderTime': orders.orderTime,
        'OrderNo': ordersNo,
        'Status': 'Pending',
        'isNewForUser': false,
        'isNewForPhar': true,
        'isRejectFromPrescription': false,
        'PharNote': '',
        'NoOfProducts': orders.products.length,
      });
      double totalPrice = 0;
      for (int i = 0; i < orders.products.length; i++) {
        String prescriptionUrl = '';
        if (orders.products[i].prescription != null) {
          prescriptionUrl = await uploadFileToFirebase(
              file: orders.products[i].prescription,
              filePathInStorage:
                  'Orders/${orders.pharmacy.pharmacyId}-${patient.userId}-$ordersNo/$i');
          print(prescriptionUrl);
        }
        totalPrice += (orders.products[i].price * orders.products[i].quantity);
        var retProd = await _fireStore
            .collection('Order')
            .doc(ret.id)
            .collection('Products')
            .doc(i.toString())
            .set({
          'productNo': i,
          'productId': orders.products[i].id,
          'productName': orders.products[i].name,
          'dosageUnit': orders.products[i].dosageUnit,
          'pillsUnit': orders.products[i].pillsUnit,
          'description': orders.products[i].description,
          'quantity': orders.products[i].quantity,
          'price': orders.products[i].price,
          'prescriptionUrl': prescriptionUrl,
          'productImageUrl': orders.products[i].imageUrls != null &&
                  orders.products[i].imageUrls.length > 0
              ? orders.products[i].imageUrls[0]
              : '',
          'isRejectFromPrescription': false,
          'PharNote': '',
          'pills': orders.products[i].selectedPills,
          'dosage': orders.products[i].selectedDosage,
        });
      }
      await updateCollectionField(
          collectionName: 'Order',
          fieldName: 'totalPrice',
          fieldValue: totalPrice,
          docId: ret.id);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> orderProductsFromCart({
    Order orders,
  }) async {
    try {
      int ordersNo = await getOrderNo();

      // double distance = await Location.getDistance(startLatitude: _patient.addressGeoPoint.latitude, startLongitude: _patient.addressGeoPoint.longitude, endLatitude: orders.pharmacy.addressGeo.latitude, endLongitude: orders.pharmacy.addressGeo.longitude);

      var ret = await _fireStore.collection('Order').add({
        'pharmacyId': orders.pharmacy.pharmacyId,
        'pharmacyName': orders.pharmacy.name,
        'pharmacyAddress': orders.pharmacy.addressGeo,
        'pharmacyPhoneNo': orders.pharmacy.phoneNo,
        'distance': orders.pharmacy.distance,
        'userId': _patient.userId,
        'userName': '${_patient.fName} ${_patient.lName}',
        'userHealthState': _patient.healthState,
        'userAge': _patient.age,
        'orderTime': orders.orderTime,
        'OrderNo': ordersNo,
        'Status': 'Pending',
        'isNewForUser': false,
        'isNewForPhar': true,
        'isRejectFromPrescription': false,
        'PharNote': '',
        'NoOfProducts': orders.products.length,
      });
      double totalPrice = 0;
      for (int i = 0; i < orders.products.length; i++) {
        String prescriptionUrl = '';
        if (orders.products[i].prescriptionRequired ) {
          Reference firebaseStorageRef = FirebaseStorage.instance.ref();
          Uint8List data = await firebaseStorageRef.child('${patient.userId}/${orders.products[i].pharmacy.pharmacyId}-${patient.userId}-${orders.products[i].productNo}').getData();
          await firebaseStorageRef.child('Orders/${orders.pharmacy.pharmacyId}-${patient.userId}-$ordersNo/$i').putData(data);
          prescriptionUrl = await firebaseStorageRef.child('Orders/${orders.pharmacy.pharmacyId}-${patient.userId}-$ordersNo/$i').getDownloadURL();
          await firebaseStorageRef.child('${patient.userId}/${orders.products[i].pharmacy.pharmacyId}-${patient.userId}-${orders.products[i].productNo}').delete();
          print(prescriptionUrl);
        }
        totalPrice += (orders.products[i].price * orders.products[i].quantity);
        var retProd = await _fireStore
            .collection('Order')
            .doc(ret.id)
            .collection('Products')
            .doc(i.toString())
            .set({
          'productNo': i,
          'productId': orders.products[i].id,
          'productName': orders.products[i].name,
          'dosageUnit': orders.products[i].dosageUnit,
          'pillsUnit': orders.products[i].pillsUnit,
          'quantity': orders.products[i].quantity,
          'price': orders.products[i].price,
          'description': orders.products[i].description,
          'prescriptionUrl': prescriptionUrl,
          'productImageUrl': orders.products[i].imageUrls != null &&
                  orders.products[i].imageUrls.length > 0
              ? orders.products[i].imageUrls[0]
              : '',
          'isRejectFromPrescription': false,
          'PharNote': '',
          'pills': orders.products[i].selectedPills,
          'dosage': orders.products[i].selectedDosage,
        });
      }
      await updateCollectionField(
          collectionName: 'Order',
          fieldName: 'totalPrice',
          fieldValue: totalPrice,
          docId: ret.id);
      var ref = await _fireStore.collection('PATIENT').doc(_patient.patientId).collection('Cart').where('pharmacyId',isEqualTo: orders.pharmacy.pharmacyId).get();
      if ( ref != null ){
        ref.docs.forEach((element) {element.reference.delete();});
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> addToCart(
      {Product product,
      int quantity,
      int dosage,
      int pills,
      double distance,
      String dosageUnit,
      String pillsUnit,
      File prescription}) async {
    try {
      int ordersNo = await getUserCartProductsNo();
      ordersNo ++ ;
      String prescriptionUrl = '';
      if (prescription != null) {
        prescriptionUrl = await uploadFileToFirebase(
            file: prescription,
            filePathInStorage:
                '${patient.userId}/${product.pharmacy.pharmacyId}-${patient.userId}-$ordersNo');
        print(prescriptionUrl);
        var ret = await _fireStore.collection('PATIENT')
            .doc(_patient.patientId)
            .collection('Cart')
            .doc(ordersNo.toString()).set({
          'productId': product.id,
          'pharmacyId': product.pharmacy.pharmacyId,
          'pharmacyAddress': product.pharmacy.addressGeo,
          'pharmacyPhoneNo': product.pharmacy.phoneNo,
          'quantity': quantity,
          'dosage': dosage,
          'description': product.description,
          'prescriptionUrl': prescriptionUrl,
          'OrderNo': ordersNo,
          'productName': product.name,
          'price': product.price,
          'totalPrice': product.price * quantity,
          'productImageUrl':
          product.imageUrls != null && product.imageUrls.length > 0
              ? product.imageUrls[0]
              : '',
          'pharmacyName': product.pharmacy.name,
          'pills': pills,
          'dosageUnit': dosageUnit,
          'pillsUnit': pillsUnit,
          'distance': distance,
        });
      }else {
        var ref = await _fireStore.collection('PATIENT')
            .doc(_patient.patientId)
            .collection('Cart').where('productId',isEqualTo: product.id).get();
        print(product.id);
        if ( ref != null && ref.docs.length > 0 ){
          var refDoc = await ref.docs[0].reference.get();
          int _quantity = refDoc.data()['quantity'];
          _quantity += quantity;
          await refDoc.reference.update({'quantity':_quantity});
        }else {
          var ret = await _fireStore.collection('PATIENT')
              .doc(_patient.patientId)
              .collection('Cart')
              .doc(ordersNo.toString()).set({
            'productId': product.id,
            'pharmacyId': product.pharmacy.pharmacyId,
            'quantity': quantity,
            'dosage': dosage,
            'prescriptionUrl': prescriptionUrl,
            'OrderNo': ordersNo,
            'productName': product.name,
            'price': product.price,
            'pharmacyAddress': product.pharmacy.addressGeo,
            'pharmacyPhoneNo': product.pharmacy.phoneNo,
            'totalPrice': product.price * quantity,
            'productImageUrl':
            product.imageUrls != null && product.imageUrls.length > 0
                ? product.imageUrls[0]
                : '',
            'pharmacyName': product.pharmacy.name,
            'pills': pills,
            'dosageUnit': dosageUnit,
            'pillsUnit': pillsUnit,
            'distance': distance,
          });
        }
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> checkCartFromSamePharmacy({String pharmacyId}) async {
    try {
      var docs = await _fireStore.collection('PATIENT')
          .doc(_patient.patientId)
          .collection('Cart')
          .where('pharmacyId',isNotEqualTo: pharmacyId).get();
      if ( docs!= null && docs.docs.length > 0 )
        return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProductFromCart(
      {int productNo , String pharmacyId , bool hasPrescription}) async {
    try {
      if ( hasPrescription ) {
        Reference firebaseStorageRef = FirebaseStorage.instance.ref();
        await firebaseStorageRef.child(
            '${patient.userId}/$pharmacyId-${patient.userId}-$productNo')
            .delete();
      }
      await _fireStore.collection('PATIENT')
          .doc(_patient.patientId)
          .collection('Cart')
          .doc(productNo.toString()).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAllProductsFromCart() async {
    try {
      var ref = await _fireStore.collection('PATIENT').doc(_patient.patientId).collection('Cart').get();
      if ( ref != null ){
        for ( var doc in ref.docs ){
          if ( doc.data()['prescriptionUrl'] != null && doc.data()['prescriptionUrl'] != '' ){
            Reference firebaseStorageRef = FirebaseStorage.instance.ref();
            await firebaseStorageRef.child(
                '${patient.userId}/${doc.data()['pharmacyId']}-${patient.userId}-${doc.id}')
                .delete();
          }
          doc.reference.delete();
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProductQuantityFromCart(
      {int productNo , int quantity}) async {
    try {
      await _fireStore.collection('PATIENT')
          .doc(_patient.patientId)
          .collection('Cart')
          .doc(productNo.toString()).update({'quantity':quantity});
      return true;
    } catch (e) {
      return false;
    }
  }

  void setOrderStatus(String orderId, String newStatus) async {
    try {
      print('Start Method setOrderStatus');
      await updateCollectionField(
          collectionName: 'Order',
          fieldName: 'Status',
          fieldValue: newStatus,
          docId: orderId);
    } catch (e) {
      print('Error from setOrderStatus $e');
    }
  }

  void updateOrderPrescription(String orderId, String pharmacyId,
      String productId, int orderNo, File prescription) async {
    try {
      print('Start Method updateOrderPrescription');
      String prescriptionUrl = '';
      if (prescription != null) {
        prescriptionUrl = await uploadFileToFirebase(
            file: prescription,
            filePathInStorage:
                'Orders/$pharmacyId-$productId-${patient.userId}-$orderNo');
        print(prescriptionUrl);
      }
      setOrderStatus(orderId, 'Pending');
      await updateCollectionField(
          collectionName: 'Order',
          fieldName: 'isNewForUser',
          fieldValue: false,
          docId: orderId);
      await updateCollectionField(
          collectionName: 'Order',
          fieldName: 'isNewForPhar',
          fieldValue: true,
          docId: orderId);
    } catch (e) {
      print('Error from updateOrderPrescription $e');
    }
  }

  Future<bool> checkMedicineExistence({@required String medicineName}) async {
    try {
      print('Start checkPharmacyUserExistence ');
      var querySnapshot =
          await _fireStore.collection('OFFICIAL_MEDICINE').get();
      var medicine = querySnapshot.docs.where((element) =>
          element['name'].toString().toLowerCase() ==
          medicineName.toLowerCase());

      if (medicine != null && medicine.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error from checkPharmacyUserExistence Method $e');
      throw e;
    }
  }

  Future<bool> checkPharmacyMedicineExistence(
      {@required String medicineName}) async {
    try {
      print('Start checkPharmacyUserExistence ');
      var querySnapshot = await _fireStore.collection('MEDICINE').get();
      var medicine = querySnapshot.docs.where((element) =>
      element['name'].toString().toLowerCase() ==
          medicineName.toLowerCase());

      if (medicine != null && medicine.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error from checkPharmacyUserExistence Method $e');
      throw e;
    }
  }
  ///////////////////////////////////////////////////delete comment down ////////////////////////////////////////////////

  // Future<List> getPharmacyMedicineExistence() async {
  //   List<Medicine> medicines = [];
  //   try {
  //     print('Start getPharmacyMedicinesExistence ');
  //     var querySnapshot = await _fireStore.collection('MEDICINE').get();
  //     print(querySnapshot.docs.first);
  //     var medicineData = querySnapshot.docs.toList();
  //
  //     print(medicineData);
  //     if (medicineData != null && medicineData.length > 0) {
  //       return medicineData.toList();
  //     }
  //     return [];
  //   } catch (e) {
  //     print('Error from checkPharmacyUserExistence Method $e');
  //     throw e;
  //   }


///////////////////////////////////////////////////delete comment up ////////////////////////////////////////////////
  Future<bool> checkMedicineExistenceByBarcode(
      {@required String barcode}) async {
    try {
      print('Start checkPharmacyUserExistence ');
      var querySnapshot =
          await _fireStore.collection('OFFICIAL_MEDICINE').get();
      var medicine = querySnapshot.docs.where((element) =>
          element['barCode'].toString().toLowerCase() == barcode.toLowerCase());

      if (medicine != null && medicine.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error from checkPharmacyUserExistence Method $e');
      throw e;
    }
  }

  Future<bool> checkPharmacyMedicineExistenceByBarcode(
      {@required String barcode}) async {
    try {
      print('Start checkPharmacyUserExistence ');
      var querySnapshot = await _fireStore.collection('MEDICINE').get();
      var medicine = querySnapshot.docs.where((element) =>
          element['barCode'].toString().toLowerCase() == barcode.toLowerCase());

      if (medicine != null && medicine.length > 0) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error from checkPharmacyUserExistence Method $e');
      throw e;
    }
  }

  Future<bool> addMedicineToPharmacyAndOfficial({
    List<File> image,
    String medicineName,
    String barCode,
    double price,
    bool prescription,
    Map<String, int> dosagePills,
    String description,
    String dosageUnit,
    String pillsUnit,
  }) async {
    try {
      print('Start Method addMedicineToPharmacyAndOfficial');
      var ret2 = await _fireStore.collection('OFFICIAL_MEDICINE').add({
        'name': medicineName,
        'barCode': barCode,
        'price': price,
        'PrescriptionRequired': prescription,
        'DosagePills': dosagePills,
        'description': description,
        'dosageUnit': dosageUnit,
        'pillsUnit': pillsUnit,
      });
      print('Added to official');
      var ret = await _fireStore
          .collection('PHARMACY')
          .doc(_pharmacist.pharmacy.pharmacyId)
          .collection('MEDICINE')
          .add({
        'name': medicineName,
        'barCode': barCode,
        'price': price,
        'PrescriptionRequired': prescription,
        'DosagePills': dosagePills,
        'description': description,
        'dosageUnit': dosageUnit,
        'pillsUnit': pillsUnit,
        'OFFICIAL_MEDICINE_Id': ret2.id,
      });
      print('Added to pharmacy ${_pharmacist.pharmacy.pharmacyId} MEDICINE');
      List<String> imageUrls = [];
      for (int i = 0; i < image.length; i++) {
        String fileUrl = await uploadFileToFirebase(
            file: image[i], filePathInStorage: '${ret.id}/$i');
        print('upload file $i to fire Storage');
        imageUrls.add(fileUrl);
      }
      _fireStore
          .collection('PHARMACY')
          .doc(_pharmacist.pharmacy.pharmacyId)
          .collection('MEDICINE')
          .doc(ret.id)
          .update({'imageURLs': imageUrls});
    } catch (e) {
      print('Error from Method addMedicineToPharmacyAndOfficial $e');
      return false;
    }
    return true;
  }

  Future<bool> addMedicineToPharmacy({
    List<File> image,
    String medicineName,
    String barCode,
    double price,
    bool prescription,
    Map<String, int> dosagePills,
    String description,
    String dosageUnit,
    String pillsUnit,
  }) async {
    try {
      var querySnapshot =
          await _fireStore.collection('OFFICIAL_MEDICINE').get();
      var medicine = querySnapshot.docs.where((element) =>
          element['name'].toString().toLowerCase() ==
          medicineName.toLowerCase());

      if (medicine != null && medicine.length > 0) {
        var ret = await _fireStore
            .collection('PHARMACY')
            .doc(_pharmacist.pharmacy.pharmacyId)
            .collection('MEDICINE')
            .add({
          'name': medicineName,
          'barCode': barCode,
          'price': price,
          'PrescriptionRequired': prescription,
          'DosagePills': dosagePills,
          'dosageUnit': dosageUnit,
          'pillsUnit': pillsUnit,
          'OFFICIAL_MEDICINE_Id': medicine.first.id,
        });
        List<String> imageUrls = [];
        for (int i = 0; i < image.length; i++) {
          String fileUrl = await uploadFileToFirebase(
              file: image[i], filePathInStorage: '${ret.id}/$i');
          imageUrls.add(fileUrl);
        }
        _fireStore
            .collection('PHARMACY')
            .doc(_pharmacist.pharmacy.pharmacyId)
            .collection('MEDICINE')
            .doc(ret.id)
            .update({'imageURLs': imageUrls});
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> addMedicineToPharmacyFromOfficial({
    String medicineName,
  }) async {
    try {
      var querySnapshot =
          await _fireStore.collection('OFFICIAL_MEDICINE').get();
      var medicine = querySnapshot.docs.where((element) =>
          element['name'].toString().toLowerCase() ==
          medicineName.toLowerCase());

      if (medicine != null && medicine.length > 0) {
        String medicineName = medicine.first.data()['name'];
        String barCode = medicine.first.data()['barCode'];
        var _price = medicine.first.data()['price'];
        double price;
        if (_price.runtimeType == int) {
          price = double.parse(_price.toString());
        } else
          price = _price;
        bool prescription = medicine.first.data()['PrescriptionRequired'];

        Map<int, int> _dosagePills = {};
        Map<String, dynamic> dosagePills = medicine.first.data()['DosagePills'];
        dosagePills.forEach((key, value) {
          var d = int.parse(key);
          _dosagePills.addAll({d: value});
        });
        String description = medicine.first.data()['description'];
        List<String> image = medicine.first.data()['ImageUrls'];
        String dosageUnit= medicine.first.data()['dosageUnit'];
        String pillsUnit= medicine.first.data()['pillsUnit'];
        var ret = await _fireStore
            .collection('PHARMACY')
            .doc(_pharmacist.pharmacy.pharmacyId)
            .collection('MEDICINE')
            .add({
          'name': medicineName,
          'ImageUrls': image,
          'barCode': barCode,
          'price': price,
          'PrescriptionRequired': prescription,
          'DosagePills': _dosagePills,
          'description': description,
          'dosageUnit': dosageUnit,
          'pillsUnit': pillsUnit,
          'OFFICIAL_MEDICINE_Id': medicine.first.id,
        });
      }
    } catch (e) {
      return false;
    }
    return true;
  }

}
