import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/manager_screen/employee/employee_screen.dart';
import 'package:graduationproject/size_config.dart';
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
    for(int i = 0 ; i<employeeData.length;i++){
      employeeLists.add(GestureDetector(
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
                child: employeeData[i].profilePic,
              ),
              SizedBox(
                width: getProportionateScreenWidth(15),
              ),
              Expanded(
                  child: Text(employeeData[i].fullName,
                    style:
                    TextStyle(fontSize: getProportionateScreenWidth(25)),
                  )),
            ],
          ),
        ),
      ));
      employeeLists.add(SizedBox(
        height: getProportionateScreenHeight(15),
      ));
    }
    return Container(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(20),
        right: getProportionateScreenWidth(20),
        top: getProportionateScreenHeight(20),
        bottom: getProportionateScreenHeight(50),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: employeeLists,
        ),
      ),
    );
  }
}

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
