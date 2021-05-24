
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:provider/provider.dart';

class AddMedicine extends StatefulWidget {
  static const String routeName = 'AddMedicine';

  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  List<File> image;
  String medicineName;
  String barCode;
  String price;
  String prescription;
  String pills;
  String description;

  User loggedInUser;
  Pharmacist phar;

  @override
  void initState() {
    super.initState();

    getPharmacist();
  }

  Future<void> getPharmacist() async {
    Pharmacist p =
    await Provider.of<FireBaseAuth>(context, listen: false).currentUser;
    setState(() {
      phar = p;
    });
  }


  @override
  Widget build(BuildContext context) {

    loggedInUser = Provider.of<FireBaseAuth>(context, listen: false).loggedUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Medicine',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            ListView(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.green,
                  child: Center(
                    child: Text('Medicine Images'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value){
                    setState(() {
                      medicineName = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Medicine Name',
                    hintText: 'Enter medicine name',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value){
                    setState(() {
                      barCode = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'bar code',
                    hintText: 'bar code',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value){
                    setState(() {
                      price = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: '3.5',
                    suffixText: 'JOD',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(onChanged: (value){
                  setState(() {
                    prescription = value;
                  });
                },
                  decoration: InputDecoration(
                    labelText: 'Need prescription',
                    hintText: 'True Or False',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value){
                    setState(() {
                      pills = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'pills',
                    hintText: 'The Number of pills',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value){
                    setState(() {
                      description = value;
                    });
                  },
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Medicine Description',
                    hintText: 'Description',
                  ),
                ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  },child: Text('Cancel'),),),
                  SizedBox(width: 10,),
                  Expanded(child: ElevatedButton(onPressed: (){

                  },child: Text('Submit'),),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
