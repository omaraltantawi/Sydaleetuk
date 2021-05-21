
import 'package:graduationproject/data_models/Pharmacy.dart';

class Product{
  String id , name , company , unit = "mg" ;
  double price ;
  Pharmacy pharmacy;
  int distance ;
  List<String> imageUrls = [];
  Map<int,int> dosagePills = {};
  bool prescriptionRequired = false ;

}