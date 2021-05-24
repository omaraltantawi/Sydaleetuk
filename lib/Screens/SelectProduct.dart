import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/order.dart' as order;
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/data_models/Product.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/providers/ProductProvider.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class SelectProduct extends StatelessWidget with CanShowMessages{
  static String routeName = "/select_product";
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    productProvider.user = Provider.of<FireBaseAuth>(context).patient ;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Search Product'),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SearchProductTF(controller: productProvider.searchController),
              IconButton(
                icon: const Icon(Icons.filter_alt_outlined,color: Colors.blue),
                tooltip: 'Filter',
                onPressed: () async {
                  ProductSearchFilter filter = await showFilterByPickerDialog(context: context , filter: productProvider.searchFilter);
                  print ('filter  $filter');
                  productProvider.searchFilter = filter;
                },
              ),
            ],
          ),
        ),
      ),
      body: Body(),
      // floatingActionButton: Stack(
      //   children: <Widget>[
      //     Align(
      //       alignment: Alignment.bottomRight,
      //       child: TextButton(
      //         style: ButtonStyle(
      //           foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      //         ),
      //         onPressed: () {
      //           productProvider.searchFilter = ProductSearchFilter.Price;
      //         },
      //         child: Text('Filter on Price'),
      //       ),
      //     ),
      //     Align(
      //       alignment: Alignment.bottomCenter,
      //       child: TextButton(
      //         style: ButtonStyle(
      //           foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      //         ),
      //         onPressed: () async {
      //           productProvider.searchFilter = ProductSearchFilter.Name;
      //           // await Location().getCurrentLocation ();
      //         },
      //         child: Text('Filter on Name'),
      //       ),
      //     ),
      //     Align(
      //       alignment: Alignment.bottomLeft,
      //       child: TextButton(
      //         style: ButtonStyle(
      //           foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      //         ),
      //         onPressed: () {
      //           productProvider.searchFilter = ProductSearchFilter.Distance;
      //         },
      //         child: Text('Filter on Distance'),
      //       ),
      //     ),
      //   ],
      // )
      // TextButton(
      //   style: ButtonStyle(
      //     foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      //   ),
      //   onPressed: () { },
      //   child: Text('Filter on Price'),
      // )
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    // productProvider.initiate();
    return ListView.builder(
      itemCount: productProvider.searchResults.length,
      itemBuilder: (BuildContext context, int i) {
        return SelectableWidget(
          product: productProvider.searchResults[i],
          selectThisProduct: (Product c) {
            // // productProvider.reset();
            print(i);
            print('${c.name} ${c.pharmacy.distance} ${c.pharmacy.name}');
            productProvider.isCompleted = false ;
            productProvider.selectedProduct = c;

            Navigator.pushNamed(context, order.OrderProduct.routeName,arguments: c);
          },
        );
      },
    );
  }
}

//
// class Body extends StatefulWidget {
//   const Body({Key key}) : super(key: key);
//
//   @override
//   _BodyState createState() => _BodyState();
// }
//
// class _BodyState extends State<Body> {
//   initiate(ProductProvider provider) {
//     provider.initiate();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final productProvider = Provider.of<ProductProvider>(context);
//     return ListView.builder(
//       itemCount: productProvider.searchResults.length,
//       itemBuilder: (BuildContext context, int i) {
//         return SelectableWidget(
//           product: productProvider.searchResults[i],
//           selectThisProduct: (Product c) {
//             // productProvider.reset();
//             print(i);
//             print('${c.name} ${c.pharmacy.distance} ${c.pharmacy.name}');
//             productProvider.isCompleted = false ;
//             productProvider.selectedProduct = c;
//             Navigator.pushNamed(context, order.OrderProduct.routeName,arguments: c);
//           },
//         );
//       },
//     );
//   }
// }

class SearchProductTF extends StatelessWidget {
  final TextEditingController controller;

  const SearchProductTF({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: SizeConfig.screenWidth * 0.80,
        decoration: BoxDecoration(
          color: kSecondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          autofocus: true,
          // onChanged: (value) => print(value),
          controller: this.controller,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenWidth(9)),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "Search product",
              prefixIcon: Icon(Icons.search)),
        ));
  }
}

class SelectableWidget extends StatelessWidget {
  final Function(Product) selectThisProduct;
  final Product product;

  const SelectableWidget({Key key, this.selectThisProduct, this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      type: MaterialType.canvas,
      child: InkWell(
        onTap: () => selectThisProduct(product), //selectThisCountry(country),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Row(
              children: [
                product.imageUrls != null && product.imageUrls.length > 0 ?
                Image.network(
                  product.imageUrls[0],
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(50),
                ) : Image.asset(
                  "assets/images/syrup.png",
                  height: getProportionateScreenHeight(50),
                  width: getProportionateScreenWidth(50),
                ),
                SizedBox(width: getProportionateScreenWidth(20),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                        product.name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700),
                  ),
                    Text(
                        product.pharmacy.name,
                        style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w200),
                  ),
                    Text(
                        "Distance: "+(product.pharmacy.distance/1000).toStringAsFixed(2) +" Km",
                        style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w200),
                  ),
                    Text(
                          product.price.toString() + " JOD" ,
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // child: Text(
          //       product.name +
          //       "\n" +
          //       product.price.toString() +
          //       " JOD\n" +
          //       (product.pharmacy.distance/1000).toString() +
          //       " Km\n" +
          //       product.pharmacy.name,//.toString(),
          //   style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 18.0,
          //       fontWeight: FontWeight.w500),
          // ),
        ),
      ),
    );
  }
}

class ShowSelectedProduct extends StatelessWidget {
  final VoidCallback onPressed;
  final Product product;

  const ShowSelectedProduct({Key key, this.onPressed, this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Text(' ${product.name}  ${product.company} ')),
              Icon(Icons.arrow_drop_down, size: 24.0)
            ],
          ),
        ),
      ),
    );
  }
}

class SearchProductTF2 extends StatelessWidget {
  final TextEditingController controller;

  const SearchProductTF2({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0, right: 8.0),
      child: Card(
        child: TextFormField(
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search your Product',
            contentPadding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
