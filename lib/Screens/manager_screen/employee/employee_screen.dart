
import 'package:flutter/material.dart';

import 'employee.dart';

class EmployeeScreen extends StatelessWidget {
  static const String routeName = 'EmployeeScreen';
  Employee _employee = Employee(
    fName: 'Mohammad',
    lName: 'AlHrout',
    email: 'hrout55@gmail.com',
    phone: '0789992753',
    profilePic: Image.network(
        'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
  );
  TextStyle _textStyle1 = TextStyle(
    color: Colors.black,
    fontSize: 25,
  );
  TextStyle _textStyle = TextStyle(
    color: Color(0xFF099F9D),
    fontSize: 25,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_employee.fName} ${_employee.lName}',
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
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SingleChildScrollView(
          padding:EdgeInsets.only(top: 2.0, left: 10.0, right: 10.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _employee.profilePic,
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Name: ',style: _textStyle,),
                  Expanded(child: Text('${_employee.fName} ${_employee.lName}',style: _textStyle1,)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Phone Number: ',style: _textStyle,),
                  Expanded(child: Text(_employee.phone,style: _textStyle1,)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Email: ',style: _textStyle,),
                  Expanded(child: Text('${_employee.email}',style: _textStyle1,)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                child: ElevatedButton(
                  child: Text('Delete this User'),
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
