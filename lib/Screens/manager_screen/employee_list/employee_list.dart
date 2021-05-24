import 'package:flutter/material.dart';

List employee=[];

class EmployeeList extends StatelessWidget {
  static const String routeName = 'EmployeeList';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF099F9D),
        child: Icon(Icons.add),
        onPressed: () {},
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
          ListTile(
            title: Text('1. Employee Name 1'),
          ),
          ListTile(
            title: Text('2. Employee Name 2'),
          ),
          ListTile(
            title: Text('3. Employee Name 3'),
          ),
        ],
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
        ),Text(
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
