import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/manager_screen/employee/add_employee.dart';
import 'package:graduationproject/data_models/User.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';

class ProfileScreenPharmacist extends StatefulWidget {
  static const String routeName = 'ProfileScreen';

  @override
  State<ProfileScreenPharmacist> createState() => _ProfileScreenPharmacistState();
}

class _ProfileScreenPharmacistState extends State<ProfileScreenPharmacist> {
  String name;

  String email;

  String phoneNumber;

  String password;

  Color background = Color(0xFF099F9D);

  @override
  Widget build(BuildContext context) {
  var phar = Provider.of<FireBaseAuth>(context,listen: true).pharmacist;
  var loggedType = Provider.of<FireBaseAuth>(context,listen: true).loggedUserType;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit your information',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: background,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                child: Icon(
                  Icons.account_circle,
                  color: mainColor,
                  size: getProportionateScreenWidth(150),
                ),
                onTap: null,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      'First Name: ${phar.fName}',
                      overflow: TextOverflow.fade,
                    ),
                    width: MediaQuery.of(context).size.width - 100,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                      TextEditingController(text: '${phar.fName}');
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Change first name'),
                            actions: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter new first name',
                                  labelText: 'New first name',
                                ),
                                controller: _controller,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text('Submit'),
                                      onPressed: () async{
                                        setState(() {
                                          phar.fName = _controller.text;
                                        });
                                        await Provider.of<FireBaseAuth>(context,listen: false).updateCollectionField(collectionName: 'USER', fieldName: 'fName', fieldValue: phar.fName, docId: phar.userId);
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(background),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(background),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ));
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      'Last Name: ${phar.lName}',
                      overflow: TextOverflow.fade,
                    ),
                    width: MediaQuery.of(context).size.width - 100,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                      TextEditingController(text: '${phar.lName}');
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Change last name'),
                            actions: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter new last name',
                                  labelText: 'New last name',
                                ),
                                controller: _controller,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text('Submit'),
                                      onPressed: () async{
                                        setState(() {
                                          phar.lName = _controller.text;
                                        });
                                        await Provider.of<FireBaseAuth>(context,listen: false).updateCollectionField(collectionName: 'USER', fieldName: 'lName', fieldValue: phar.lName, docId: phar.userId);
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(background),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(background),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ));
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      'Experience: ${phar.experience}',
                      overflow: TextOverflow.fade,
                    ),
                    width: MediaQuery.of(context).size.width - 100,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                      TextEditingController(text: '${phar.experience}');
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Change experience'),
                            actions: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter your experience',
                                  labelText: 'New experience',
                                ),
                                controller: _controller,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text('Submit'),
                                      onPressed: () async{
                                        setState(() {
                                          phar.experience = _controller.text;
                                        });
                                        print(phar.pharmacistId);
                                        await Provider.of<FireBaseAuth>(context,listen: false).updateCollectionField(collectionName: 'PHARMACIST', fieldName: 'experience', fieldValue: phar.experience, docId: phar.pharmacistId);
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(background),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(background),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ));
                    },
                  ),
                ],
              ),
            ),
            if ( loggedType != UserType.EmployeeUser )
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      'Pharmacy Name: ${phar.pharmacy.name}',
                      overflow: TextOverflow.fade,
                    ),
                    width: MediaQuery.of(context).size.width - 100,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                      TextEditingController(text: '${phar.pharmacy.name}');
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Change pharmacy name'),
                            actions: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter new pharmacy name',
                                  labelText: 'New pharmacy name',
                                ),
                                controller: _controller,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text('Submit'),
                                      onPressed: () async{
                                        setState(() {
                                          phar.pharmacy.name = _controller.text;
                                        });
                                        await Provider.of<FireBaseAuth>(context,listen: false).updateCollectionField(collectionName: 'PHARMACY', fieldName: 'pharmacyName', fieldValue: phar.pharmacy.name, docId: phar.pharmacy.pharmacyId);
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(background),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(background),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
