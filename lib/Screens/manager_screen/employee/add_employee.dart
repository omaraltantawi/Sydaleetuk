import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/ServiceClasses/SignInMethods.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/custom_surfix_icon.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'employee.dart';

class AddEmployee extends StatefulWidget with CanShowMessages{
  static const String routeName = 'AddEmployee';

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

Color mainColor = Color(0xFF099F9D);

sendEmail () {
  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'smith@example.com',
      queryParameters: {
        'subject': 'Example Subject & Symbols are allowed!'
      }
  );

  launch(_emailLaunchUri.toString());
}

Future<void> sendSms (String no) async{
  // Android
  String uri = 'sms:$no?body=You%20Are%20there';
  if (await canLaunch(uri)) {
    await launch(uri);
  }
}

Employee employee = Employee();
class _AddEmployeeState extends State<AddEmployee> with CanShowMessages {
  final _formKey = GlobalKey<FormState>();
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.account_circle,
                    color: mainColor,
                    size: getProportionateScreenWidth(150),
                  ),
                  onTap: null,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Container(
                  child: TextFormField(
                    onSaved: (newValue) => employee.fName = newValue,
                    onChanged: (value) {
                      employee.fName = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return kNamelNullError;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "First Name",
                      hintText: "Enter your first name",

                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Container(
                  child: TextFormField(
                    onSaved: (newValue) => employee.lName = newValue,
                    onChanged: (value) {
                      employee.lName = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return kNamelNullError;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      hintText: "Enter your last name",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Container(
                  child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (newValue) => employee.email = newValue,
                      onChanged: (value) {
                        employee.email = value;
                        return null;
                      },
                      validator: (value) {
                        if (value.isEmpty || !isEmailChecker(value)) {
                          return kInvalidEmailError;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter your email",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                      ),
                    )
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Container(
                  child: TextFormField(
                    obscureText: true,
                    onSaved: (newValue) => employee.pass = newValue,
                    onChanged: (value) {
                      employee.pass = value;
                    },
                    validator: (value) {
                      if (value.isEmpty || !checkPasswordStrength(value)) {
                        return kShortPassError;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                    ),
                  )
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Container(
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    onSaved: (newValue) => employee.phone = newValue,
                    onChanged: (value) {
                      employee.phone = value;
                      return null;
                    },
                    validator: (value) {
                      if (value.isEmpty || value.length != 9 ){
                        return kInvalidPhoneNumberError;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      hintText: "Enter your phone number",
                      prefixText: '+962 ',
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
                    ),
                  )
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
                          press: (){
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: DefaultButton(
                          text: 'Submit',
                          press: () async {
                            FocusScope.of(context).unfocus();
                            if ( _formKey.currentState.validate() ){
                              _formKey.currentState.save();
                              var phar = Provider.of<FireBaseAuth>(context,listen: false).pharmacist;
                              await Provider.of<FireBaseAuth>(context,listen: false).addEmployeeUser(employee.email, employee.pass,employee.fName, employee.lName, employee.phone,'',phar.pharmacy.pharmacyId);
                              await showMessageDialog(context: context, msgTitle: 'Add Employee', msgText: ['Employee added successfully'], buttonText: '');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
