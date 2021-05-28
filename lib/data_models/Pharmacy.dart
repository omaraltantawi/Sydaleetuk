import 'package:cloud_firestore/cloud_firestore.dart';

class Pharmacy {
  String name , phoneNo , pharmacyId ;
  GeoPoint addressGeo;
  double distance;

  Pharmacy clone(){
    Pharmacy pharmacy = Pharmacy ();
    pharmacy.name = name ;
    pharmacy.phoneNo = phoneNo ;
    pharmacy.pharmacyId = pharmacyId ;
    pharmacy.addressGeo = addressGeo ;
    pharmacy.distance = distance ;
    return pharmacy;
  }


}