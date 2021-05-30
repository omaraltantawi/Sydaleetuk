import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/providers/ProductProvider.dart';
import 'package:provider/provider.dart';
import '../../../size_config.dart';
import '../../SelectProduct.dart';

class Menu_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text(

            "Products",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(17),
              color: Colors.grey,
            ),
          ),
        ),
        ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 10.0),
            Container(
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height ,
                child: GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  primary: false,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: 0.8,
                  children: <Widget>[
                    buildCard('Panadol Extra', '2.50\JOD', 'https://i-cf5.gskstatic.com/content/dam/cf-consumer-healthcare/health-professionals/en_IE/pain-relief/new-pain-relief/Panadol-Extra-750x421.jpg?auto=format',
                        false, context),
                    buildCard('Tramadol', '5.00\JOD',
                        'https://www.rxmedsondemand.com/wp-content/uploads/2021/03/Tramadol-100Mg.jpg', true, context),
                    buildCard('Vitamin C', '6.5\JOD',
                        'https://static2.mumzworld.com/media/catalog/product/n/p/np-129742-natures-aid-vitamin-c-500mg-50-tablets-1595411682.jpg', false, context),
                    buildCard('Revanin', '0.60\JOD',
                        'https://www.al-agzakhana.com/wp-content/uploads/2018/02/Revanin-Tablets.jpg', false, context),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  Widget buildCard(
      String name, String price, String imgPath, bool prescription, context) {
    return Padding(
        padding:
            EdgeInsets.only(top: 10.0, bottom: 25.0, left: 10.0, right: 10.0),
        child: InkWell(
            onTap: () async {
              await Provider.of<ProductProvider>(context,listen: false).initiate(text: name);
              Navigator.pushNamed(context, SelectProduct.routeName );
              //Navigator.of(context).push(
              //MaterialPageRoute(builder: (context) => medDetail(
              //  assetPath: imgPath,
              //medPrice:price,
              //,edName: name)));
            },
            child: Container(

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3.0,
                          blurRadius: 5.0)
                    ],
                    color: Colors.white),
                child: Column(children: [
                  Hero(
                      tag: imgPath,
                      child: Container(

                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(imgPath),
                                  fit: BoxFit.contain)))),
                  SizedBox(height: 5.0),
                  Text(name,
                      style: TextStyle(
                          color: Color(0xFF575E67),
                          fontFamily: 'Muli',
                          fontSize: 20)),
                  Text(price,
                      style: TextStyle(
                          color: Color(0xFF48B3B2),
                          fontFamily: 'Muli',
                          fontSize: 20)),
                  Padding(
                      padding: EdgeInsets.only(right: 6.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            prescription
                                ? Text("(Prescription Required)")
                                : Text(""),
                          ])),
                ]))));
  }
}
