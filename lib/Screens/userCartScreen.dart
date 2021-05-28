import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduationproject/Screens/SelectProduct.dart';
import 'package:graduationproject/Screens/checkOutOrderScreen.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/data_models/OrderClass.dart';
import 'package:graduationproject/data_models/Patient.dart';
import 'package:graduationproject/data_models/Pharmacy.dart';
import 'package:graduationproject/data_models/Product.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/providers/ProductProvider.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';

class UserCartScreen extends StatelessWidget {
  static String routeName = "/user_cart";
  const UserCartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Cart ',
        ),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 40.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Cart', style: headingStyle),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: [
        //     Body(),
        //     Padding(
        //       padding: const EdgeInsets.all(5.0),
        //       child: DefaultButton(
        //         press: (){
        //
        //         },
        //         text: 'Continue',
        //       ),
        //     ),
        //   ],
        // ),
        child: Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with CanShowMessages {
  List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    Patient patient = Provider.of<FireBaseAuth>(context, listen: true).patient;
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('PATIENT')
            .doc(patient.patientId)
            .collection('Cart')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Widget> widgets = [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            widgets.add(
              Center(
                child: Text(
                  'Please wait...',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(20),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
            widgets.add(
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                height: SizeConfig.screenHeight * 0.025,
              ),
            );
            widgets.add(
              SpinKitDoubleBounce(
                color: kPrimaryColor,
                size: SizeConfig.screenWidth * 0.15,
              ),
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widgets,
            );
          }
          products = [];
          final orders = snapshot.data.docs;
          for (var order in orders) {
            Product product = Product();
            product.pharmacy = Pharmacy();
            product.id = order.data()['productId'];
            product.name = order.data()['productName'];
            product.dosageUnit = order.data()['dosageUnit'];
            product.pillsUnit = order.data()['pillsUnit'];
            product.description = order.data()['description'];
            product.quantity = order.data()['quantity'];
            product.pharmacy.pharmacyId = order.data()['pharmacyId'];
            product.pharmacy.name = order.data()['pharmacyName'];
            product.pharmacy.addressGeo = order.data()['pharmacyAddress'];
            product.pharmacy.phoneNo = order.data()['pharmacyPhoneNo'];
            product.pharmacy.phoneNo = order.data()['pharmacyPhoneNo'];
            product.pharmacy.distance = order.data()['distance'];
            String productNo = order.id;
            product.productNo = int.tryParse(productNo);
            var prescriptionUrl = order.data()['prescriptionUrl'];
            product.prescriptionUrl = prescriptionUrl;
            product.prescriptionRequired =
                prescriptionUrl != null && prescriptionUrl != '';
            var productImageUrl = order.data()['productImageUrl'];
            product.imageUrls = [productImageUrl];
            var price = order.data()['price'];
            if (price.runtimeType == int) {
              double p = double.parse(price.toString());
              product.price = p;
            } else
              product.price = price;
            product.selectedPills = order.data()['pills'];
            product.selectedDosage = order.data()['dosage'];
            products.add(product);
            widgets.add(
              CartProductWidget(
                product: product,
              ),
            );
            widgets.add(
              Divider(
                color: Colors.black.withOpacity(0.25),
                thickness: 1,
              ),
            );
          }

          if (widgets.length == 0) {
            widgets.add(
              Icon(
                Icons.hourglass_empty,
                color: kPrimaryColor,
                size: SizeConfig.screenWidth * 0.4,
              ),
            );
            widgets.add(
              Center(
                child: Text(
                  'You don\'t have any products',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(20),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
            widgets.add(
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                height: SizeConfig.screenHeight * 0.025,
              ),
            );
            widgets.add(
              SizedBox(
                width: SizeConfig.screenWidth * 0.6,
                height: SizeConfig.screenHeight * 0.05,
                child: DefaultButton(
                  text: "Order Now",
                  press: () {
                    // Navigator.pu(context, HomeScreen.routeName);
                    Provider.of<ProductProvider>(context, listen: false)
                        .initiate();
                    Navigator.of(context)
                        .pushReplacementNamed(SelectProduct.routeName);
                  },
                ),
              ),
            );
            return Padding(
              padding:
                  EdgeInsets.only(top: getProportionateScreenHeight(100.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: widgets,
              ),
            );
          } else {
            widgets.add(
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: DefaultButton(
                  press: () {
                    // print(products.length);
                    Order order = Order();
                    order.isFromCart = true;
                    order.pharmacy = products[0].pharmacy;
                    order.orderTime = DateTime.now();
                    order.products.addAll(products);
                    Navigator.pushNamed(context, CheckOutOrdersScreen.routeName,
                        arguments: order);
                  },
                  text: 'Continue',
                ),
              ),
            );
          }
          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            children: widgets,
          );
        },
      ),
    );
  }
}

class CartProductWidget extends StatefulWidget {
  final Product product;
  const CartProductWidget({Key key, this.product}) : super(key: key);

  @override
  _CartProductWidgetState createState() => _CartProductWidgetState();
}

class _CartProductWidgetState extends State<CartProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      type: MaterialType.canvas,
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Container(
          padding:
              EdgeInsets.only(left: 10.0, bottom: 10.0, right: 5.0, top: 10.0),
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
          width: SizeConfig.screenWidth * 0.90,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              widget.product.imageUrls != null &&
                      widget.product.imageUrls.length > 0 &&
                      widget.product.imageUrls[0] != ''
                  ? Image.network(
                      widget.product.imageUrls[0],
                      height: getProportionateScreenHeight(110),
                      width: getProportionateScreenWidth(75),
                    )
                  : Image.asset(
                      "assets/images/syrup.png",
                      height: getProportionateScreenHeight(110),
                      width: getProportionateScreenWidth(75),
                    ),
              // SizedBox(
              //   width: getProportionateScreenWidth(10),
              // ),
              Padding(
                padding: EdgeInsets.only(left: getProportionateScreenWidth(85)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700),
                        ),
                        InkWell(
                          onTap: () async {
                            print(widget.product.productNo);
                            await Provider.of<FireBaseAuth>(context,
                                    listen: false)
                                .deleteProductFromCart(
                                    hasPrescription:
                                        widget.product.prescriptionRequired,
                                    pharmacyId:
                                        widget.product.pharmacy.pharmacyId,
                                    productNo: widget.product.productNo);
                          },
                          child: Container(
                            // margin: EdgeInsets.all(5),
                            alignment: Alignment.centerRight,
                            // width: double.infinity,
                            height: getProportionateScreenHeight(30),
                            color: Colors.transparent,
                            child: Icon(
                              Icons.cancel_outlined,
                              size: 25.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${widget.product.pharmacy.name}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w200),
                    ),
                    Text(
                      '${widget.product.selectedDosage} ${widget.product.dosageUnit} - ${widget.product.selectedPills} ${widget.product.pillsUnit}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w200),
                    ),
                    Text(
                      (widget.product.price * widget.product.quantity)
                              .toStringAsFixed(2) +
                          " JOD",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(5),
                    ),
                    ConstrainedBox(
                      constraints: new BoxConstraints(
                        maxWidth: SizeConfig.screenWidth*0.39,
                      ),
                      child: Container(
                        padding: EdgeInsets.only( bottom: 5.0, top: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (widget.product.quantity > 1) {
                                  print('decrease');
                                  setState(() {
                                    widget.product.quantity--;
                                  });
                                  await Provider.of<FireBaseAuth>(context,
                                          listen: false)
                                      .updateProductQuantityFromCart(
                                          productNo: widget.product.productNo,
                                          quantity: widget.product.quantity);
                                } else {
                                  //Call Remove Product.
                                  print('remove');
                                  print(widget.product.productNo);
                                  print(widget.product.prescriptionRequired);
                                  await Provider.of<FireBaseAuth>(context,
                                          listen: false)
                                      .deleteProductFromCart(
                                          hasPrescription:
                                              widget.product.prescriptionRequired,
                                          pharmacyId:
                                              widget.product.pharmacy.pharmacyId,
                                          productNo: widget.product.productNo);
                                }
                              },
                              child: Container(
                                // margin: EdgeInsets.all(5),
                                alignment: Alignment.centerLeft,
                                // width: double.infinity,
                                height: getProportionateScreenHeight(30),
                                color: Colors.transparent,
                                child: Icon(
                                  Icons.remove,
                                  size: 25.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(30),
                            ),
                            Text(
                              '${widget.product.quantity}',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(30),
                            ),
                            InkWell(
                              onTap: () async {
                                print('increase');
                                setState(() {
                                  widget.product.quantity++;
                                });
                                await Provider.of<FireBaseAuth>(context,
                                        listen: false)
                                    .updateProductQuantityFromCart(
                                        productNo: widget.product.productNo,
                                        quantity: widget.product.quantity);
                              },
                              child: Container(
                                // margin: EdgeInsets.all(5),
                                alignment: Alignment.centerLeft,
                                // width: double.infinity,
                                height: getProportionateScreenHeight(30),
                                color: Colors.transparent,
                                child: Icon(
                                  Icons.add,
                                  size: 25.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
