import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduationproject/Screens/SelectProduct.dart';
import 'package:graduationproject/Screens/order.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/components/orderButton.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/data_models/Patient.dart';
import 'package:graduationproject/data_models/Product.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/providers/ProductProvider.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';

class UserOrders extends StatelessWidget {
  static String routeName = "/user_orders";
  const UserOrders({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<FireBaseAuth>(context, listen: true);
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Order').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          String userId = auth.userId;
          List<Widget> widgets = [];
          if (snapshot.connectionState == ConnectionState.waiting || widgets.length == 0) {
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
              // SizedBox(
              //   width: SizeConfig.screenWidth * 0.05,
              //   height: SizeConfig.screenHeight * 0.025,
              //   child: CircularProgressIndicator(
              //     backgroundColor: kPrimaryColor,
              //   ),
              // ),
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

          final orders = snapshot.data.docs.reversed;
          for (var order in orders) {
            if ( userId == order.data()['userId']) {
              var status = order.data()['Status'];
              var productName = order.data()['productName'];
              var pharmacyName = order.data()['pharmacyName'];
              var productImageUrl = order.data()['productImageUrl'];
              var totalPrice = order.data()['totalPrice'];
              var orderNo = order.data()['OrderNo'];
              var productId = order.data()['productId'];
              var pharmacyId = order.data()['pharmacyId'];
              var pharNote = '';
              var isRejectFromPrescription = false;
              if (status == 'Rejected') {
                pharNote = order.data()['PharNote'];
                isRejectFromPrescription =
                order.data()['isRejectFromPrescription'];
              }
              widgets.add(OrderWidget(
                isRejectFromPrescription: isRejectFromPrescription,
                orderId: order.id,
                pharNote: pharNote,
                orderNo: orderNo,
                productId: productId,
                pharmacyId: pharmacyId,
                pharmacyName: pharmacyName,
                productName: productName,
                price: totalPrice.toString(),
                productImage: productImageUrl,
                status: status,
              ));
              widgets.add(
                Divider(
                  color: Colors.black.withOpacity(0.25),
                  thickness: 1,
                ),
              );
            }
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
                  'You don\'t have any Orders',
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widgets,
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

class OrderWidget extends StatelessWidget with CanShowMessages {
  final String productId,
      orderId,
      pharmacyId,
      productName,
      pharmacyName,
      price,
      status,
      productImage,
      pharNote;
  final int orderNo;
  final bool isRejectFromPrescription;
  OrderWidget(
      {Key key,
      this.orderId,
      this.pharNote,
      this.orderNo,
      this.productId,
      this.pharmacyId,
      this.pharmacyName,
      this.productName,
      this.price,
      this.status,
      this.productImage,
      this.isRejectFromPrescription })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      type: MaterialType.canvas,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 15.0, bottom: 10.0, right: 10.0, top: 10.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              productImage != null && productImage != ''
                  ? Image.network(
                      productImage,
                      height: getProportionateScreenHeight(50),
                      width: getProportionateScreenWidth(50),
                    )
                  : Image.asset(
                      "assets/images/syrup.png",
                      height: getProportionateScreenHeight(70),
                      width: getProportionateScreenWidth(70),
                    ),
              SizedBox(
                width: getProportionateScreenWidth(20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName ,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    pharmacyName,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w200),
                  ),
                  Text(
                    price.toString() + " JOD",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: SizeConfig.screenWidth * 0.35,
                        child: OrderButton(
                          width: SizeConfig.screenWidth * 0.35,
                          height: 40,
                          press: null,//status.toLowerCase() != 'accepted' ? null : () { },
                          text: status.toLowerCase() == 'pending'
                              ? 'In Progress'
                              : status,
                          isRed: status.toLowerCase() == 'rejected',
                        ),
                      ),
                      if ( status.toLowerCase() == 'rejected' && isRejectFromPrescription )
                        Container(width : SizeConfig.screenWidth * 0.1 ,height: 0.0),
                      if ( status.toLowerCase() == 'rejected' && isRejectFromPrescription )
                        SizedBox(
                          height: 50,
                          width: SizeConfig.screenWidth * 0.1,
                          child: OrderIconButton(
                            press: () async {
                              File file = await showPickFileDialog(context: context, msgText: ['You need to upload the Prescription again.',pharNote]);
                              print('file $file');
                              if ( file != null )
                                Provider.of<FireBaseAuth>(context,listen: false).updateOrderPrescription( orderId, pharmacyId, productId, orderNo, file);
                            },
                            iconData: Icons.warning_amber_rounded,
                          ),
                        ),
                      if ( status.toLowerCase() == 'rejected' && !isRejectFromPrescription && pharNote != null && pharNote != '' )
                        Container(width : SizeConfig.screenWidth * 0.1 ,height: 0.0),
                      if ( status.toLowerCase() == 'rejected' && !isRejectFromPrescription && pharNote != null && pharNote != '' )
                        SizedBox(
                          height: 50,
                          width: SizeConfig.screenWidth * 0.1,
                          child: OrderIconButton(
                            press: () async {
                              await showMessageDialog(context: context,msgTitle: 'Order' , msgText: [pharNote], buttonText: 'OK');
                            },
                            iconData: Icons.warning_amber_rounded,
                          ),
                        ),
                      if ( status.toLowerCase() == 'accepted' )
                        Container(width : SizeConfig.screenWidth * 0.010 ,height: 0.0),
                      if ( status.toLowerCase() == 'accepted' )
                        SizedBox(
                          height: 50,
                          // width: SizeConfig.screenWidth * 0.05,
                          child: OrderIconButton(
                            press: () async {
                              Patient user = await Provider.of<FireBaseAuth>(context,listen:false).currentUser;
                              GeoPoint userLocation = user.addressGeoPoint;
                              Product product = await Provider.of<ProductProvider>(context,listen: false).getProductData(productId, pharmacyId, userLocation);
                              if ( product != null ){
                                Navigator.pushNamed(context, OrderProduct.routeName,arguments: product);
                              }else{
                                showMessageDialog(
                                    context: context,
                                    msgTitle: 'Warning',
                                    msgText: [
                                      'Something went wrong','Please try again.'
                                    ],
                                    buttonText: 'OK');
                              }
                            },
                            iconData: Icons.refresh,
                            text: 'Order Again',
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
