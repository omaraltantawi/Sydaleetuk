import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduationproject/Screens/manager_screen/employee/employee_screen.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';
import 'add_employee.dart';
import 'employee.dart';

class EmployeeList extends StatelessWidget {
  static const String routeName = 'EmployeeList';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF099F9D),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AddEmployee.routeName);
        },
      ),
      appBar: AppBar(
        title: Text(
          'Employees',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF099F9D),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            employeeLists.clear();
          }
        ),
      ),
      body: HaveEmployees(),
    );
  }
}

List<Employee> employeeData = [
  Employee(
    fullName: 'Mohammad AlHrout',
    email: 'hrout55@gmail.com',
    phone: '+962789456784',
    profilePic: Image.network(
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      height: getProportionateScreenHeight(100),
    ),
  ),
  Employee(
    fullName: 'Ahmad AlHrout',
    email: 'hrout55@gmail.com',
    phone: '+962789456784',
    profilePic: Image.network(
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      height: getProportionateScreenHeight(100),
    ),
  ),
  Employee(
    fullName: 'Noor AlHrout',
    email: 'hrout55@gmail.com',
    phone: '+962789456784',
    profilePic: Image.network(
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      height: getProportionateScreenHeight(100),
    ),
  ),
  Employee(
    fullName: 'Muna AlHrout',
    email: 'hrout55@gmail.com',
    phone: '+962789456784',
    profilePic: Image.network(
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      height: getProportionateScreenHeight(100),
    ),
  ),
];

List<Widget> employeeLists = [];

class HaveEmployees extends StatefulWidget {
  @override
  State<HaveEmployees> createState() => _HaveEmployeesState();
}

class _HaveEmployeesState extends State<HaveEmployees> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<FireBaseAuth>(context,listen: true);
    return FutureBuilder(
        future: auth.getPharmacyEmployees(),
        builder: (BuildContext ctxt, AsyncSnapshot<List<Pharmacist>> snapshot) {
          List<Widget> widgets = [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            widgets.add(
              Center(
                child: Text(
                  'Please wait...',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(20),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
            widgets.add(
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                height: SizeConfig.screenHeight * 0.025,
              ),
            );
            widgets.add(
              SpinKitDoubleBounce(
                color: kPrimaryColor,
                size: SizeConfig.screenWidth * 0.15,
              ),
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widgets,
            );
          }
          final List<Pharmacist> users = snapshot.data;
          for (var user in users) {
            String name = user.fName + user.lName ;
            widgets.add(
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, EmployeeScreen.routeName);
                  },
                  child: Container(
                    width: getProportionateScreenWidth(double.infinity),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF099F9D), width: 2),
                      borderRadius: BorderRadius.circular(
                        getProportionateScreenWidth(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child:user.imageUrl != '' && user.imageUrl != null ? Image.network(user.imageUrl) :
                          Image.asset('assets/images/dimage.jpg'),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(15),
                        ),
                        Expanded(
                            child: Text(name,
                              style:
                              TextStyle(fontSize: getProportionateScreenWidth(15)),
                            )),
                      ],
                    ),
                  ),
                )
            );
            widgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Divider(
                  color: Colors.black.withOpacity(0.25),
                  thickness: 1,
                ),
              ),
            );
          }

          if (widgets.length == 0) {
            widgets.add(
              Icon(
                Icons.hourglass_empty,
                color: kPrimaryColor,
                size: SizeConfig.screenWidth * 0.4,
              ),
            );
            widgets.add(
              Center(
                child: Text(
                  'You don\'t add employee yet',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(20),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
            widgets.add(
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                height: SizeConfig.screenHeight * 0.025,
              ),
            );
            widgets.add(
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                height: SizeConfig.screenHeight * 0.05,
                child: DefaultButton(
                  text: "Add Employee Now",
                  press: () async{
                  },
                ),
              ),
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widgets,
            );
          }

          return ListView(
            padding: EdgeInsets.all(8.0),
            children: widgets,
          );
        }
      );
  }
}
//
// class HaveEmployees extends StatefulWidget {
//   @override
//   State<HaveEmployees> createState() => _HaveEmployeesState();
// }
//
// class _HaveEmployeesState extends State<HaveEmployees> {
//   @override
//   Widget build(BuildContext context) {
//     for(int i = 0 ; i<employeeData.length;i++){
//       employeeLists.add(GestureDetector(
//         onTap: () {
//           Navigator.pushNamed(context, EmployeeScreen.routeName);
//         },
//         child: Container(
//           width: getProportionateScreenWidth(double.infinity),
//           decoration: BoxDecoration(
//             border: Border.all(color: Color(0xFF099F9D), width: 2),
//             borderRadius: BorderRadius.circular(
//               getProportionateScreenWidth(10),
//             ),
//           ),
//           child: Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(100),
//                 child: employeeData[i].profilePic,
//               ),
//               SizedBox(
//                 width: getProportionateScreenWidth(15),
//               ),
//               Expanded(
//                   child: Text(employeeData[i].fullName,
//                     style:
//                     TextStyle(fontSize: getProportionateScreenWidth(25)),
//                   )),
//             ],
//           ),
//         ),
//       ));
//       employeeLists.add(SizedBox(
//         height: getProportionateScreenHeight(15),
//       ));
//     }
//     return Container(
//       padding: EdgeInsets.only(
//         left: getProportionateScreenWidth(20),
//         right: getProportionateScreenWidth(20),
//         top: getProportionateScreenHeight(20),
//         bottom: getProportionateScreenHeight(50),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           children: employeeLists,
//         ),
//       ),
//     );
//   }
// }

class NoEmployees extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Your pharmacy have not employees',
          style: TextStyle(
            fontSize: 30.0,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'Press on + to add an employee',
          style: TextStyle(
            fontSize: 30.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
