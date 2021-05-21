import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType {
  NormalUser,
  PharmacyUser,
  EmployeeUser,
  Guest
}

class SUser {
  String userId , fName , lName , email , phoneNo ;
  GeoPoint addressGeo;
  UserType userType ;
}
