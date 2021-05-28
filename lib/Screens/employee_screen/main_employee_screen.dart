import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/Screens/manager_screen/pharmacy/pharmacy_screen.dart';
import '/Screens/manager_screen/profile/profile_screen_pharmacist.dart';
import 'package:graduationproject/Screens/manager_screen/order/order_list.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:provider/provider.dart';
import 'medicine/medicine_list.dart';


class MainEmployeeScreen extends StatefulWidget {
  static const String routeName = "/MainEmployeeScreen";

  @override
  _MainEmployeeScreenState createState() => _MainEmployeeScreenState();
}

class _MainEmployeeScreenState extends State<MainEmployeeScreen> {

  User loggedInUser;
  Pharmacist phar;

  @override
  void initState()  {
    setState(() {

      phar = Provider.of<FireBaseAuth>(context, listen: false).pharmacist;
    });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    loggedInUser = Provider.of<FireBaseAuth>(context, listen: false).loggedUser;
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
              onTap: (){
                Navigator.pushNamed(context, PharmacyScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: (){
                Navigator.pushNamed(context, ProfileScreenPharmacist.routeName);
                },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('LogOut'),
              onTap: () {
                Provider.of<FireBaseAuth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
        phar.pharmacy.name,
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
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                Container(
                  child: Center(
                    child: Text(
                      'Welcome ${phar.fName} to your pharmacy',
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
                  title: 'Medicine List',
                  page: EmployeeMedicineList.routeName,
                ),
                SizedBox(
                  height: 30,
                ),
                MainButtons(
                  title: 'Order List',
                  page: OrderList.routeName,
                ),
                SizedBox(
                  height: 30,
                ),
                // MainButtons(
                //   title: 'Employee List',
                //   // page: EmployeeList.routeName,
                // ),
                SizedBox(
                  height: 30,
                ),
                // MainButtons(
                //   title: 'Requests Medicines',
                //   // page: RequestScreen.routeName,
                // ),
              ],
            ),
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
