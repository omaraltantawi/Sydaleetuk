import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduationproject/data_models/Pharmacy.dart';
import 'package:graduationproject/data_models/Product.dart';

class Order {
  Pharmacy pharmacy;
  List<Product> products =[] ;
  GeoPoint userLocation;
  DateTime orderTime ;
  bool isFromCart =false;
  String orderId , status , pharNote , userName , userHealthState , UserPhoneNo;
  bool isRejectFromPrescription ;
  int orderNo , noOfProducts , userAge;
  double totalPrice;
}