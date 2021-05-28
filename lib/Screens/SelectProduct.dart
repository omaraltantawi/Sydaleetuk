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

class SelectProduct extends StatelessWidget with CanShowMessages {
  static String routeName = "/select_product";
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    productProvider.user = Provider.of<FireBaseAuth>(context).patient;

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
                icon: const Icon(Icons.filter_alt_outlined, color: Colors.blue),
                tooltip: 'Filter',
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  ProductSearchFilter filter = await showFilterByPickerDialog(
                      context: context, filter: productProvider.searchFilter);
                  print('filter  $filter');
                  productProvider.searchFilter = filter;
                },
              ),
            ],
          ),
        ),
      ),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<Widget> widgets = [];
    for (int i = 0; i < productProvider.searchResults.length; i++) {
      widgets.add(SelectableWidget(
        product: productProvider.searchResults[i],
        selectThisProduct: (Product c) async {
          print(i);
          print('${c.name} ${c.pharmacy.distance} ${c.pharmacy.name}');
          productProvider.isCompleted = true;
          productProvider.selectedProduct = c.clone();
          await productProvider.completeProductInfo();
          Navigator.pushNamed(context, order.OrderProduct.routeName,
              arguments: productProvider.selectedProduct.clone());
        },
      ));
      widgets.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(
            color: Colors.black.withOpacity(0.25),
            thickness: 1,
          ),
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.all(
        10.0,
      ),
      children: widgets,
    );
    // return ListView.builder(
    //   itemCount: productProvider.searchResults.length,
    //   itemBuilder: (BuildContext context, int i) {
    //     return SelectableWidget(
    //       product: productProvider.searchResults[i],
    //       selectThisProduct: (Product c) {
    //         // // productProvider.reset();
    //         print(i);
    //         print('${c.name} ${c.pharmacy.distance} ${c.pharmacy.name}');
    //         productProvider.isCompleted = false ;
    //         productProvider.selectedProduct = c;
    //
    //         Navigator.pushNamed(context, order.OrderProduct.routeName,arguments: c);
    //       },
    //     );
    //   },
    // );
  }

}

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
            padding: EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                product.imageUrls != null && product.imageUrls.length > 0
                    ? Image.network(
                        product.imageUrls[0],
                        height: getProportionateScreenHeight(100),
                        width: getProportionateScreenWidth(75),
                      )
                    : Image.asset(
                        "assets/images/syrup.png",
                        height: getProportionateScreenHeight(100),
                        width: getProportionateScreenWidth(75),
                      ),
                SizedBox(
                  width: getProportionateScreenWidth(10),
                ),
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
                    SizedBox(
                      height: getProportionateScreenHeight(5),
                    ),
                    Text(
                      product.pharmacy.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w200),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(5),
                    ),
                    Text(
                      "Distance: " +
                          (product.pharmacy.distance / 1000)
                              .toStringAsFixed(2) +
                          " Km",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w200),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(5),
                    ),
                    Text(
                      product.price.toStringAsFixed(2) + " JOD",
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
