import 'package:flutter/material.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/size_config.dart';

import 'employee.dart';

class EmployeeScreen extends StatelessWidget {
  static const String routeName = 'EmployeeScreen';
  final Employee _employee = Employee(
    fullName: 'Mohammad AlHrout',
    email: 'hrout55@gmail.com',
    phone: '0789992753',
    profilePic: Image.network(
        'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
  );

  final TextStyle _textStyle1 = TextStyle(
    color: Colors.black,
    fontSize: getProportionateScreenWidth(18),
  );
  final TextStyle _textStyle = TextStyle(
    color: Color(0xFF099F9D),
    fontSize: getProportionateScreenWidth(18),
  );

  @override
  Widget build(BuildContext context) {
    Pharmacist pharmacist =
        ModalRoute.of(context).settings.arguments as Pharmacist;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${pharmacist.fName} ${pharmacist.lName}',
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
      body: SingleChildScrollView(
        padding:
            EdgeInsets.all(getProportionateScreenWidth(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: pharmacist.imageUrl != '' && pharmacist.imageUrl != null
                    ? Image.network(
                        pharmacist.imageUrl,
                        width: SizeConfig.screenWidth * 0.75,
                      )
                    : Image.asset(
                        'assets/images/dimage.jpg',
                        width: SizeConfig.screenWidth * 0.75,
                      ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Row(
              children: [
                Text(
                  'Name: ',
                  style: _textStyle,
                ),
                Expanded(
                    child: Text(
                  '${pharmacist.fName} ${pharmacist.lName}',
                  style: _textStyle1,
                )),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            Row(
              children: [
                Text(
                  'Phone Number: ',
                  style: _textStyle,
                ),
                Expanded(
                    child: Text(
                  '+962 ${pharmacist.phoneNo}',
                  style: _textStyle1,
                )),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            Row(
              children: [
                Text(
                  'Email: ',
                  style: _textStyle,
                ),
                Expanded(
                    child: Text(
                  '${pharmacist.email}',
                  style: _textStyle1,
                )),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Container(
              height: getProportionateScreenHeight(50),
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  'Delete this User',
                  style:
                      TextStyle(fontSize: getProportionateScreenHeight(20)),
                ),
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
