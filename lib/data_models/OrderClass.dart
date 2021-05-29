import 'dart:io';
import 'package:graduationproject/data_models/Pharmacy.dart';
import 'package:graduationproject/data_models/Product.dart';

class Order {
  Pharmacy pharmacy;
  List<Product> products =[] ;
  DateTime orderTime ;
  bool isFromCart =false;
  String orderId , status , pharNote , userName , userHealthState ;
  bool isRejectFromPrescription ;
  int orderNo , noOfProducts , userAge;
  double totalPrice;
}