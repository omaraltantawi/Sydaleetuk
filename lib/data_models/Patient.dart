import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class Patient extends SUser {
  String healthState , address ;
  DateTime birthDate ;
  DateTime gender ;
  GeoPoint addressGeoPoint;
}
