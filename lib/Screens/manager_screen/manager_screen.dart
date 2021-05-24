import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/manager_screen/employee_list/employee_list.dart';
import '/data_models/Pharmacist.dart';
import '/firebase/auth/auth.dart';
import 'package:provider/provider.dart';

import 'medicines/medicine_list.dart';

User loggedInUser;
Pharmacist phar;

class ManagerScreen extends StatefulWidget {
  static const String routeName = "/ManagerScreen";

  @override
  _ManagerScreenState createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;

        getPharmacist().then((value) => null);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPharmacist() async {
    phar = await Provider.of<FireBaseAuth>(context, listen: false).currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF099F9D),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 100.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            'phar.fName',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            'phar.lName',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Pharmacy'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'phar.pharmacy.name',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF42adac),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu_rounded),
            color: Colors.white,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          TextButton(
            child: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Container(
                child: Center(
                  child: Text(
                    'Welcome FirstName to your pharmacy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                color: Color(0xFF099F9D),
                width: double.infinity,
                height: 50,
              ),
              SizedBox(
                height: 30,
              ),
              MainButtons(
                title: 'The Medicine List',
                page: MedicineList.routeName,
              ),
              SizedBox(
                height: 30,
              ),
              MainButtons(
                title: 'The Order List',
                page: 'null',
              ),
              SizedBox(
                height: 30,
              ),
              MainButtons(
                title: 'The Employee List',
                page: EmployeeList.routeName,
              ),
              SizedBox(
                height: 30,
              ),
              MainButtons(
                title: 'The Requests Medicines',
                page: 'null',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainButtons extends StatelessWidget {
  final String title;
  final String page;

  MainButtons({this.title, this.page});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 325,
      child: TextButton(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, page);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFF099F9D)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(
                      color: Colors.white,
                      width: 2,
                    )))),
      ),
    );
  }
}
