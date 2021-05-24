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
  String experience ;
  GeoPoint addressGeoPoint;
  ScreenArguments({this.experience,this.email, this.password,this.fName,this.lName,this.phoneNo,this.address,this.birthDate,this.gender,this.addressGeoPoint});
}