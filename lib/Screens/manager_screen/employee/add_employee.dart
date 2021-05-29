import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/size_config.dart';

import 'employee.dart';

class AddEmployee extends StatefulWidget {
  static const String routeName = 'AddEmployee';

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

Color mainColor = Color(0xFF099F9D);


Employee employee = Employee();
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
        backgroundColor: mainColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                child: Icon(
                  Icons.account_circle,
                  color: mainColor,
                  size: getProportionateScreenWidth(150),
                ),
                onTap: (){},
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    labelText: 'Name',
                  ),
                  onChanged: (value){
                    setState(() {
                      employee.fullName = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'email@email.com',
                    labelText: 'Email',
                  ),
                  onChanged: (value){
                    setState(() {
                      employee.email = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'phone number',
                    labelText: 'phone',
                    prefixText: '+962 ',
                  ),
                  onChanged: (value){
                    setState(() {
                      employee.phone = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Container(
                width: getProportionateScreenWidth(double.infinity),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: DefaultButton(
                        text: 'Cancel',
                        press: (){},
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: DefaultButton(
                        text: 'Submit',
                        press: (){},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
