import 'package:flutter/cupertino.dart';

class Medicine {
  String name;
  String barCode;
  Map type;
  String description;
  Map date;
  String price;
  bool prescription;
  List image;

  Medicine(
      {@required this.name,
      @required this.barCode,
      this.type,
      this.description,
      this.date,
      @required this.price,
      this.prescription,
      this.image});
}
