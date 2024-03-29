import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/manager_screen/employee/add_employee.dart';
import 'package:graduationproject/Screens/manager_screen/managerSettings.dart';
import 'package:graduationproject/Screens/manager_screen/pharmacy/pharmacy_screen.dart';
import 'package:graduationproject/Screens/manager_screen/order/order_list.dart';
import 'package:graduationproject/Screens/manager_screen/requests_medicines/request_screen.dart';
import 'package:graduationproject/Screens/splash/splash_screen.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';
import 'employee/employee_list.dart';
import 'medicines/medicine_list.dart';
import 'profile/profile_screen_pharmacist.dart';

class ManagerScreen extends StatefulWidget {
  static const String routeName = "/ManagerScreen";

  @override
  _ManagerScreenState createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {

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
                      GestureDetector(
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.white,
                          size: getProportionateScreenWidth(100),
                        ),
                        onTap: null,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            phar.fName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),

                          Text(
                            phar.lName,
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
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: (){
                Navigator.pushNamed(context, ProfileScreenPharmacist.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: (){
                Navigator.pushNamed(context, ManagerSettingsScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('LogOut'),
              onTap: () {
                Provider.of<FireBaseAuth>(context, listen: false).logout();
                Navigator.pushNamedAndRemoveUntil(context, SplashScreen.routeName, (route) => false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
        phar.pharmacy.name,
          style: TextStyle(color: Colors.white, fontSize: getProportionateScreenWidth(25)),
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
                        fontSize: getProportionateScreenWidth(15),
                      ),
                    ),
                  ),
                  color: Color(0xFF099F9D),
                  width: double.infinity,
                  height: getProportionateScreenHeight(50),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                MainButtons(
                  title: 'Medicine List',
                  page: MedicineList.routeName,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                MainButtons(
                  title: 'Order List',
                  page: OrderList.routeName,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                MainButtons(
                  title: 'Employee List',
                  page: EmployeeList.routeName,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                MainButtons(
                  title: 'Requests Medicines',
                  page: RequestScreen.routeName,
                ),
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
      height: getProportionateScreenHeight(75),
      width: getProportionateScreenWidth(300),
      child: TextButton(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: getProportionateScreenWidth(23),
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
                      color: Colors.blueGrey,
                      width: 2,
                    )))),
      ),
    );
  }
}
