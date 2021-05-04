import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'categories.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'recommended_products.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(30)),
            HomeHeader(),
            SizedBox(height: getProportionateScreenHeight(10)),
            Categories(),
            RecommendedProducts(),
            SizedBox(height: getProportionateScreenWidth(30)),
            PopularProducts(),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}
