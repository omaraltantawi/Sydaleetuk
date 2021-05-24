import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class Patient extends SUser {
  String healthState , address ;
  DateTime birthDate ;
  String gender ;
  int age ;
  GeoPoint addressGeoPoint;
}
