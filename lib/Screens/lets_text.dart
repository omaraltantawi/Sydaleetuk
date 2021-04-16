import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduationproject/Screens/auth_screen.dart';
import 'package:graduationproject/data_models/Patient.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/data_models/User.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/utils/StyleConstants.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  static const routeName = '/userScreen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LetsChat(),
    );
  }
}

class LetsChat extends StatefulWidget {
  @override
  _LetsChatState createState() => _LetsChatState();
}

class _LetsChatState extends State<LetsChat> with CanShowMessages {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> data = [];

  String userName = '';

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserData() async {
    List<Widget> widgets = [];
    var user =
        await Provider.of<FireBaseAuth>(context, listen: false).currentUser;
    UserType type =
        Provider.of<FireBaseAuth>(context, listen: false).loggedUserType;
    var userCredential =
        Provider.of<FireBaseAuth>(context, listen: false).loggedUser;
    print('User Type from User Screen is $type');
    if (type == UserType.PharmacyUser || type == UserType.EmployeeUser) {
      Pharmacist userData = user;

      widgets.add(SizedBox(
        height: 10.0,
        width: 10.0,
      ));

      String fileUrl = userCredential.photoURL;
      print(fileUrl);
      if (fileUrl != null && fileUrl != '') {
        widgets.add(Container(
          child: Image.network(fileUrl),
          height: 100.0,
          width: 100.0,
          alignment: Alignment.center,
        ));
      } else {
        widgets.add(Container(
          child: Icon(
            Icons.person,
            size: 100.0,
          ),
          height: 100.0,
          width: 100.0,
          alignment: Alignment.center,
        ));
      }

      widgets.add(SizedBox(
        height: 10.0,
        width: 10.0,
      ));

      widgets.add(Text(
        '${type == UserType.PharmacyUser ? 'Pharmacy User' : 'Employee User'} Data',
        style: titleTextStyle,
      ));

      widgets.add(SizedBox(
        height: 10.0,
        width: 10.0,
      ));

      widgets.add(Text(
        'User ID : ${userData.userId}',
        style: normalTextStyle,
      ));
      widgets.add(Text(
        'First Name: ${userData.fName}',
        style: normalTextStyle,
      ));
      widgets.add(Text(
        'Last Name: ${userData.lName}',
        style: normalTextStyle,
      ));

      setState(() {
        userName = '${userData.fName} ${userData.lName}';
      });

      widgets.add(Text(
        'Email : ${userData.email}',
        style: normalTextStyle,
      ));
      widgets.add(Text(
        'Phone No. : ${userData.phoneNo}',
        style: normalTextStyle,
      ));

      widgets.add(Text(
        'Experience : ${userData.experience}',
        style: normalTextStyle,
      ));
      widgets.add(SizedBox(
        height: 20.0,
        width: 20.0,
      ));
      widgets.add(Text(
        'Pharmacy Data',
        style: titleTextStyle,
      ));
      widgets.add(SizedBox(
        height: 10.0,
        width: 10.0,
      ));
      widgets.add(Text(
        'Pharmacy ID : ${userData.pharmacy.pharmacyId}',
        style: normalTextStyle,
      ));
      widgets.add(Text(
        'Pharmacy Name : ${userData.pharmacy.name}',
        style: normalTextStyle,
      ));
      widgets.add(Text(
        'Pharmacy Phone No. : ${userData.pharmacy.phoneNo}',
        style: normalTextStyle,
      ));
    } else if (type == UserType.NormalUser) {
      Patient userData = user;

      widgets.add(SizedBox(
        height: 10.0,
        width: 10.0,
      ));

      String fileUrl = userCredential.photoURL;
      print(fileUrl);
      if (fileUrl != null && fileUrl != '') {
        widgets.add(Container(
          child: Image.network(fileUrl),
          height: 100.0,
          width: 100.0,
          alignment: Alignment.center,
        ));
      } else {
        widgets.add(Container(
          child: Icon(
            Icons.person,
            size: 100.0,
          ),
          height: 100.0,
          width: 100.0,
          alignment: Alignment.center,
        ));
      }

      widgets.add(SizedBox(
        height: 10.0,
        width: 10.0,
      ));

      widgets.add(Text(
        'Normal User Data',
        style: titleTextStyle,
      ));

      widgets.add(SizedBox(
        height: 10.0,
        width: 10.0,
      ));

      widgets.add(Text(
        'User ID : ${userData.userId}',
        style: normalTextStyle,
      ));
      widgets.add(Text(
        'First Name: ${userData.fName}',
        style: normalTextStyle,
      ));
      widgets.add(Text(
        'Last Name: ${userData.lName}',
        style: normalTextStyle,
      ));

      setState(() {
        userName = '${userData.fName} ${userData.lName}';
      });

      widgets.add(Text(
        'Email : ${userData.email}',
        style: normalTextStyle,
      ));
      widgets.add(Text(
        'Phone No. : ${userData.phoneNo}',
        style: normalTextStyle,
      ));

      widgets.add(Text(
        'Birth Date : ${userData.birthDate}',
        style: normalTextStyle,
      ));
      widgets.add(Text(
        'Health State : ${userData.healthState}',
        style: normalTextStyle,
      ));
      widgets.add(Text(
        'Address : ${userData.address}',
        style: normalTextStyle,
      ));
    }
    setState(() {
      data = widgets;
    });
  }

  Future<void> changeUserImage() async {
    try {
      List<Asset> image = await pickImage();
      print(image);
      if (image != null && image.length > 0) {
        File file = await getImageFileFromAssets(image[0]);
        await Provider.of<FireBaseAuth>(context, listen: false)
            .changeUserProfileImage(file: file);
      }
    } catch (e) {
      print(e);
      showMessageDialog(
          context: this.context,
          msgTitle: 'Warning',
          msgText: ['Something went wrong.', 'Please try again'],
          buttonText: 'OK');
    }
  }

  Future<List<Asset>> pickImage() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: [],
        materialOptions: MaterialOptions(
          actionBarTitle: "FlutterCorner.com",
        ),
      );
      return resultList;
    } catch (e) {
      print('From Pick Image $e');
      return [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('User Screen'),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: data,
        ),
      ),
      floatingActionButton: Container(
        width: 180,
        height: 130,
        margin: EdgeInsets.only(bottom: 10.0),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(20.0),
        //   color: Theme.of(context).primaryColor,
        // ),
        child: Column(
          children: [
            FlatButton.icon(
              padding: EdgeInsets.all(10.0),
              color: Colors.lightBlue,
              label: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Get User Current \n         Data",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              icon: Icon(Icons.data_usage),
              onPressed: getUserData,
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton.icon(
              padding: EdgeInsets.all(10.0),
              color: Colors.lightBlue,
              label: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Change User \n     Image",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              icon: Icon(Icons.image),
              onPressed: changeUserImage,
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Scaffold(
          appBar: AppBar(
            title: Text(userName),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (Provider.of<FireBaseAuth>(context, listen: false)
                        .loggedUserType ==
                    UserType.PharmacyUser)
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AuthScreen(isEmployee: true)))
                    },
                    child: Text('Add Employee'),
                  ),
                ElevatedButton(
                  onPressed: () => {
                    Provider.of<FireBaseAuth>(context, listen: false).logout(),
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => AuthScreen()))
                  },
                  child: Text('Log Out'),
                ),
              ],
            ),
          ),
        ),
      ),
      // Disable opening the end drawer with a swipe gesture.
      endDrawerEnableOpenDragGesture: false,
    );
  }
}

