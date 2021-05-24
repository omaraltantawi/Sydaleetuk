import 'package:flutter/material.dart';

class AddEmployee extends StatefulWidget {
  static const String routeName = 'AddEmployee';

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Employee',
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
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.green,
            child: Center(
              child: Text('Employee Images'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Employee Name',
              hintText: 'Enter employee name',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'phone number',
              hintText: 'Enter the phone Number of the employee',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter the Email of the employee',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: ElevatedButton(onPressed: (){},child: Text('Cancel'),),),
                SizedBox(width: 10,),
                Expanded(child: ElevatedButton(onPressed: (){},child: Text('Submit'),),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
