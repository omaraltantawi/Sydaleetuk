import 'package:cloud_firestore/cloud_firestore.dart';

class ScreenArguments {
  String email;
  String password;
  String fName;
  String lName;
  String phoneNo;
  String address;
  DateTime birthDate;
  String gender ;
  GeoPoint addressGeoPoint;
  ScreenArguments({this.email, this.password,this.fName,this.lName,this.phoneNo,this.address,this.birthDate,this.gender,this.addressGeoPoint});
}