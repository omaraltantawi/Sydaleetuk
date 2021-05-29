import 'package:flutter/cupertino.dart';

class Medicine {
  List<Image> image;
  String name;
  String barCode;
  String price;
  String size;
  String type;
  bool prescription;
  String description;

  Medicine(
      {this.name,
      this.barCode,
      this.type,
      this.description,
      this.size,
      this.price,
      this.prescription,
      this.image});


}
