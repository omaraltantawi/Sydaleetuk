import 'User.dart';
import 'Pharmacy.dart';

class Pharmacist extends SUser {
  String experience ;
  String pharmacistId ;
  Pharmacy pharmacy ;
  String imageUrl;
  bool isDeleted = false;
}