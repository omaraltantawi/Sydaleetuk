import 'package:flutter/material.dart';
import 'package:graduationproject/size_config.dart';
import 'add_employee.dart';
import 'employee_screen.dart';

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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          EmployeeTile(
            number: '1',
            fName: 'Mohammad',
            lName: 'AlHrout',
            phoneNumber: '0789992753',
            image: Image.network(
                'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
          ),
          EmployeeTile(
            number: '1',
            fName: 'Mohammad',
            lName: 'AlHrout',
            phoneNumber: '0789992753',
            image: Image.network(
                'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
          ),
          EmployeeTile(
            number: '1',
            fName: 'Mohammad',
            lName: 'AlHrout',
            phoneNumber: '0789992753',
            image: Image.network(
                'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
          ),
          EmployeeTile(
            number: '1',
            fName: 'Mohammad',
            lName: 'AlHrout',
            phoneNumber: '0789992753',
            image: Image.network(
                'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
          ),
        ],
      ),
    );
  }
}

class EmployeeTile extends StatelessWidget {
  final String number;
  final String fName;
  final String lName;
  final String phoneNumber;
  final Image image;

  EmployeeTile({this.number, this.fName, this.lName, this.phoneNumber, this.image});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '1. ',
              style: TextStyle(fontSize: getProportionateScreenWidth(25)),
            ),
            Container(
              height: getProportionateScreenHeight(100),

              width: getProportionateScreenHeight(100),
              child: image,
            ),
            Expanded(
              child: Text('$fName $lName',
              style: TextStyle(fontSize: getProportionateScreenWidth(25)),),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, EmployeeScreen.routeName);
      },
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
