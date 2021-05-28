
import 'dart:io';

import 'package:graduationproject/data_models/Pharmacy.dart';

class Product{
  String id , name , company , dosageUnit = "mg" , pillsUnit = "pills" ,pharNote , prescriptionUrl , description;
  double price ,distance;
  int selectedDosage ,quantity , selectedPills , productNo;
  Pharmacy pharmacy;
  File prescription;
  List<String> imageUrls = [];
  Map<int,int> dosagePills = {};
  bool prescriptionRequired = false , isRejectFromPrescription = false ;

  Product clone(){
    Product product = Product();
    product.id = id ;
    product.name = name ;
    product.company = company ;
    product.pillsUnit = pillsUnit ;
    product.dosageUnit = dosageUnit ;
    product.pharNote = pharNote ;
    product.prescriptionUrl = prescriptionUrl ;
    product.description = description ;
    product.price = price ;
    product.distance = distance ;
    product.selectedDosage = selectedDosage ;
    product.quantity = quantity ;
    product.selectedPills = selectedPills ;
    product.productNo = productNo ;
    product.pharmacy = pharmacy.clone();
    product.prescription = prescription ;
    product.imageUrls = imageUrls ;
    product.dosagePills = dosagePills ;
    product.prescriptionRequired = prescriptionRequired ;
    product.isRejectFromPrescription = isRejectFromPrescription;
    return product;
  }

}