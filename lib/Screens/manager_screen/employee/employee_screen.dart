import 'package:flutter/material.dart';

class EmployeeScreen extends StatelessWidget {
  static const String routeName = 'EmployeeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Employee Name',
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.green,
                child: Text('Profile Pic'),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                child: Text('Employee Name'),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                child: Text('Phone Number'),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                child: Text('Email'),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                child: ElevatedButton(
                  child: Text('Delete this User'),
                  onPressed: (){},
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
