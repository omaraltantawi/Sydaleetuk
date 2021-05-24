import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduationproject/components/MessageDialog.dart';
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

  deleteUser() async {
    loggedUser = null;
    loggedUserType = null;
    pharmacyId = '';
    _patient = null;
    _pharmacist = null;
    key = '1234';
    photoUri = '';
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
      updateCollectionField(
          collectionName: 'USER',
          fieldName: 'fName',
          fieldValue: fNameNew,
          docId: userId);
      updateCollectionField(
          collectionName: 'USER',
          fieldName: 'lName',
          fieldValue: lNameNew,
          docId: userId);
      loggedUser.updateProfile(displayName: '$fNameNew $lNameNew');
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
    } catch (e) {
      print('error Method resetPasswordEmail \n$e');
      // throw e;
    }
  }

  Future<void> verifyEmail() async {
    try {
      print('Start verifyEmail.');
      print('Email verified ${loggedUser.emailVerified}');
      auth.currentUser.sendEmailVerification();
    } catch (e) {
      print('error Method verifyEmail \n$e');
      // throw e;
    }
  }

  Future<int> getOrderNo() async {
    var doc = await _fireStore.collection('Order').get();
    if (doc != null) {
      return doc.docs.length;
    }
    return 0;
  }

  Future<bool> orderProduct(
      {Product product, int quantity, int dosage, File prescription}) async {
    try {
      int ordersNo = await getOrderNo();
      String prescriptionUrl = '';
      if (prescription != null) {
        prescriptionUrl = await uploadFileToFirebase(
            file: prescription,
            filePathInStorage:
                'Orders/${product.pharmacy.pharmacyId}-${product.id}-${patient.userId}-$ordersNo');
        print(prescriptionUrl);
      }
      var ret = await _fireStore.collection('Order').add({
        'productId': product.id,
        'pharmacyId': product.pharmacy.pharmacyId,
        'userId': _patient.userId,
        'quantity': quantity,
        'dosage': dosage,
        'prescriptionUrl': prescriptionUrl,
        'OrderNo': ordersNo,
        'Status': 'Pending',
        'productName': product.name,
        'price': product.price,
        'totalPrice': product.price * quantity,
        'productImageUrl':
            product.imageUrls != null && product.imageUrls.length > 0
                ? product.imageUrls[0]
                : '',
        'pharmacyName': product.pharmacy.name,
        'isNewForUser': false,
        'isNewForPhar': true,
        'isRejectFromPrescription': false,
        'PharNote': '',
      });
    } catch (e) {
      return false;
    }
    return true;
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
          fieldName: 'isNew',
          fieldValue: false,
          docId: orderId);
    } catch (e) {
      print('Error from updateOrderPrescription $e');
    }
  }

  Future<bool> addMedicine({
    List<File> image,
    String medicineName,
    String barCode,
    String price,
    String prescription,
    String pills,
    String description,
  }) async {
    try {

      var ret2 = await _fireStore
          .collection('OFFICIAL_MEDICINE')
          .add({
        'medicine Name': medicineName,
        'bar Code': barCode,
        'price': price,
        'prescription': prescription,
        'pills': pills,
        'description': description,
      });
      var ret = await _fireStore
          .collection('PHARMACY')
          .doc(_pharmacist.pharmacy.pharmacyId)
          .collection('MEDICINE')
          .add({
        'medicine Name': medicineName,
        'bar Code': barCode,
        'price': price,
        'prescription': prescription,
        'pills': pills,
        'description': description,
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
    } catch (e) {
      return false;
    }
    return true;
  }
}
