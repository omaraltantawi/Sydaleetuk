import 'package:flutter/cupertino.dart';

class Medicine {
  Image image;
  String name;
  String barCode;
  String EXPDate;
  String MFGDate;
  String price;
  String size;
  String type;
  bool prescription;
  String description;

  Medicine(
      {@required this.name,
      @required this.barCode,
      this.type,
      this.description,
      this.size,
      this.EXPDate,
      this.MFGDate,
      @required this.price,
      this.prescription,
      this.image});
}
