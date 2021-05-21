import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:graduationproject/ServiceClasses/Location.dart';
import 'package:graduationproject/data_models/Patient.dart';
import 'package:graduationproject/data_models/Pharmacy.dart';
import 'package:graduationproject/data_models/Product.dart';

enum ProductSearchFilter{
  Price, Distance , Name
}

class ProductProvider with ChangeNotifier {

  final _fireStore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> pharmacyDocs = [] ;
  bool isCompleted = false ;

  Patient user;

  /// setting up listeners
  ProductProvider() {
    searchController.addListener(_search);
  }

  List<Product> _searchResults = [];
  List<Product> get searchResults => _searchResults;

  set searchResults(List<Product> value) {
    _searchResults = value;
    print('SearchResults ${searchResults.length}');
    notifyListeners();
  }

  Product _selectedProduct = Product();
  Product get selectedProduct => _selectedProduct;

  set selectedProduct(Product value) {
    _selectedProduct = value;
    if ( !isCompleted && value != null && value.name != null && value.name.length > 0 ){
      completeProductInfo ();
      isCompleted = true;
    }
    notifyListeners();
  }

  ProductSearchFilter _searchFilter = ProductSearchFilter.Name;
  ProductSearchFilter get searchFilter => _searchFilter;

  set searchFilter(ProductSearchFilter value) {
    if ( _searchFilter != value ) {
      _searchFilter = value;
      List<Product> _results = searchResults;
      if (searchFilter == ProductSearchFilter.Name)
        _results.sort((a, b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      else if (searchFilter == ProductSearchFilter.Price)
        _results.sort((a, b) => a.price.compareTo(b.price));
      else if (searchFilter == ProductSearchFilter.Distance)
        _results.sort((a, b) =>
            a.pharmacy.distance.compareTo(b.pharmacy.distance));
      searchResults = _results;
      notifyListeners();
    }
  }

  TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  ///  This will be the listener for searching the query entered by user for product, (dialog pop-up),
  ///  searches for the query and returns list of products matching the query by adding the results to the sink of [searchResults]
  ///  and sorted depending on the nearest pharmacy
  Future<void> _search()  async {
    String query = searchController.text.toLowerCase().trim();
    print(query);
    if (query.length == 0 ) {
      searchResults = [];
      // if ( !initialized )
      //   initiate ();
    } else {
      GeoPoint userLocation = user.addressGeoPoint;
      List<Product> _results = [];
      for ( var element in pharmacyDocs ){
        try {
          var querySnapshot = await element.reference.collection('Medicine').get();
          var medicineDocs = querySnapshot.docs;
          GeoPoint pharmacylocation = element.data()['addressGeoPoint'];
          for ( var medicine in medicineDocs ){
            if (medicine.data()['name'].toString().toLowerCase().contains(
                query)) {
              Product prod = Product();
              prod.id = medicine.id;
              prod.name = medicine.data()['name'];
              // prod.imageUrls = medicine.data()['imageUrls'];
              // prod.prescriptionRequired = medicine.data()['PrescriptionRequired'];
              // Map<String,dynamic> dosagePills = medicine.data()['DosagePills'];
              // dosagePills.forEach((key, value) {
              //   var d = int.parse(key);
              //   prod.dosagePills.addAll({d:value});
              // });
              var price = medicine.data()['price'];
              if ( price.runtimeType == int ) {
                double p = double.parse(price.toString());
                prod.price = p;
              }else
                prod.price = price;
              prod.pharmacy = Pharmacy();
              prod.pharmacy.pharmacyId = element.id;
              prod.pharmacy.name = element.data()['pharmacyName'];
              prod.company = element.data()['pharmacyName'];
              prod.pharmacy.phoneNo = element.data()['phoneNo'];
              prod.pharmacy.distance = await Location.getDistance(startLatitude: userLocation.latitude, startLongitude: userLocation.longitude, endLatitude: pharmacylocation.latitude, endLongitude: pharmacylocation.longitude);
              _results.add(prod);
            }
          }
        }catch ( e ){
          print ( e );
        }
      }

      // pharmacyDocs.forEach((element) async {
      //   var querySnapshot = await element.reference.collection('Medicine').get();
      //   var medicineDocs = querySnapshot.docs;
      //   medicineDocs.forEach((medicine) {
      //     if ( medicine.data()['name'].toString().toLowerCase().contains(query) ){
      //       Product prod = Product();
      //       prod.id = medicine.id;
      //       prod.name = medicine.data()['name'];
      //       prod.price = medicine.data()['price'];
      //
      //       prod.pharmacy = Pharmacy();
      //       prod.pharmacy.pharmacyId = element.id;
      //       prod.pharmacy.name = element.data()['pharmacyName'];
      //       prod.company = element.data()['pharmacyName'];
      //       prod.pharmacy.phoneNo = element.data()['phoneNo'];
      //
      //       _results.add(prod);
      //     }
      //   });
      // });

      if ( searchFilter == ProductSearchFilter.Name )
        _results.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      else if ( searchFilter == ProductSearchFilter.Price )
        _results.sort((a, b) => a.price.compareTo(b.price));
      else if ( searchFilter == ProductSearchFilter.Distance )
        _results.sort((a, b) => a.pharmacy.distance.compareTo(b.pharmacy.distance));
      searchResults = _results;
      // print("results length: ${searchResults.length}");
    }
  }

  Future<void> completeProductInfo () async {
    print( 'completeProductInfo Invoked ');
    Product prod = selectedProduct;
    var medicine = await _fireStore.collection('PHARMACY').doc(selectedProduct.pharmacy.pharmacyId).collection('Medicine').doc(selectedProduct.id).get();
    prod.imageUrls = medicine.data()['imageUrls'];
    if  ( prod.imageUrls == null )
      prod.imageUrls = [];
    prod.prescriptionRequired = medicine.data()['PrescriptionRequired'];
    Map<String,dynamic> dosagePills = medicine.data()['DosagePills'];
    dosagePills.forEach((key, value) {
      var d = int.parse(key);
      prod.dosagePills.addAll({d:value});
    });
    selectedProduct = prod;
  }

  Future<void> initiate () async {
    reset();
    var querySnapshot = await _fireStore.collection('PHARMACY').get();
    pharmacyDocs = querySnapshot.docs;
    print("initiate");
  }

  void reset (){
    isCompleted = false ;
    selectedProduct = Product();
    _searchController.text = "" ;
    searchResults = [];
  }

}
