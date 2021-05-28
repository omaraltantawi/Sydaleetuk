import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduationproject/Screens/OrderInfoScreen.dart';
import 'package:graduationproject/Screens/SelectProduct.dart';
import 'package:graduationproject/Screens/order.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/components/orderButton.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/data_models/OrderClass.dart';
import 'package:graduationproject/data_models/Patient.dart';
import 'package:graduationproject/data_models/Pharmacy.dart';
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
    String userId = auth.userId;
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Order').where('userId',isEqualTo:userId ).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          List<Widget> widgets = [];
          if (snapshot.connectionState == ConnectionState.waiting ) {
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

          final orders = snapshot.data.docs;
          for (var order in orders) {
              Order _order = Order();
              _order.pharmacy = Pharmacy();
              _order.pharmacy.pharmacyId = order.data()['pharmacyId'];
              _order.pharmacy.name = order.data()['pharmacyName'];
              _order.pharmacy.addressGeo = order.data()['pharmacyAddress'] ;
              _order.pharmacy.phoneNo = order.data()['pharmacyPhoneNo'] ;
              var distance = order.data()['distance'];
              if (distance.runtimeType == int) {
                double p = double.parse(distance.toString());
                _order.pharmacy.distance = p;
              } else
                _order.pharmacy.distance = distance;
              _order.products = [] ;
              _order.orderNo = order.data()['OrderNo'];
              _order.noOfProducts = order.data()['NoOfProducts'];
              _order.orderId = order.id;
              _order.status = order.data()['Status'];
              _order.isRejectFromPrescription = order.data()['isRejectFromPrescription'];
              _order.pharNote = order.data()['PharNote'];
              var _totalPrice = order.data()['totalPrice'];
              if ( _totalPrice.runtimeType == int ) {
                double p = double.parse(_totalPrice.toString());
                _order.totalPrice = p;
              }else
                _order.totalPrice = _totalPrice;
              Timestamp stamp = order.data()['orderTime'];
              if (stamp != null) _order.orderTime = stamp.toDate();
              widgets.add(OrderWidget(order:_order,));
              widgets.add(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Divider(
                    color: Colors.black.withOpacity(0.25),
                    thickness: 1,
                  ),
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
  final Order order;
  OrderWidget(
      {Key key,
      this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<FireBaseAuth>(context, listen: true);
    String userId = auth.userId;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Order').doc(order.orderId).collection('Products').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if ( snapshot.hasData ) {
          order.products = [];
          final orders = snapshot.data.docs;
          for (var _order in orders) {
            Product product = Product();
            product.pharmacy = Pharmacy();
            product.pharmacy = order.pharmacy;
            product.id = _order.data()['productId'];
            product.name = _order.data()['productName'];
            product.dosageUnit = _order.data()['dosageUnit'];
            product.pillsUnit = _order.data()['pillsUnit'];
            product.quantity = _order.data()['quantity'];
            String productNo = _order.id;
            product.productNo = int.tryParse(productNo);
            var prescriptionUrl = _order.data()['prescriptionUrl'];
            product.prescriptionRequired = prescriptionUrl != null && prescriptionUrl!= '';
            var productImageUrl = _order.data()['productImageUrl'];
            product.imageUrls = [productImageUrl];
            var price = _order.data()['price'];
            if (price.runtimeType == int) {
              double p = double.parse(price.toString());
              product.price = p;
            } else
              product.price = price;
            product.selectedPills = _order.data()['pills'];
            product.selectedDosage = _order.data()['dosage'];
            product.pharNote = _order.data()['PharNote'];
            product.isRejectFromPrescription = _order.data()['isRejectFromPrescription'];
            order.products.add(product);
          }
        }
        return Material(
          color: Colors.white,
          type: MaterialType.canvas,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 5.0, bottom: 5.0, right: 5.0, top: 5.0),
            child: InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(OrderInfoScreen.routeName,arguments: order);
              },
              child: Container(
                padding: EdgeInsets.only(
                    left: 10.0, bottom: 10.0, right: 5.0, top: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)
                  ),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    order.products.length > 0 && order.products[0].imageUrls[0] != null && order.products[0].imageUrls[0] != ''
                        ? Image.network(
                          order.products[0].imageUrls[0],
                          height: getProportionateScreenHeight(140),
                          )
                        : Image.asset(
                            "assets/images/syrup.png",
                            height: getProportionateScreenHeight(140),
                          ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.products.length > 0 && order.products[0].name != null && order.products[0].name != '' ? order.products[0].name : '' ,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if ( order.noOfProducts > 1 )
                        Text(
                          '+ ${order.noOfProducts -1} products',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          order.pharmacy.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w200),
                        ),
                        // Text(
                        //   (order.pharmacy.distance/1000).toStringAsFixed(2)+'Km',
                        //   style: TextStyle(
                        //       color: Colors.black,
                        //       fontSize: 18.0,
                        //       fontWeight: FontWeight.w200),
                        // ),
                        Text(
                          "${order.totalPrice} JOD",
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
                                text: order.status.toLowerCase() == 'pending'
                                    ? 'In Progress'
                                    : order.status,
                                isRed: order.status.toLowerCase() == 'rejected',
                              ),
                            ),
                            if ( order.status.toLowerCase() == 'rejected' && order.pharNote != null && order.pharNote != '' )
                              Container(width : SizeConfig.screenWidth * 0.1 ,height: 0.0),
                            if ( order.status.toLowerCase() == 'rejected' && order.pharNote != null && order.pharNote != '' )
                              SizedBox(
                                height: 50,
                                width: SizeConfig.screenWidth * 0.1,
                                child: OrderIconButton(
                                  press: () async {
                                    await showMessageDialog(context: context,msgTitle: 'Order' , msgText: [order.pharNote], buttonText: 'OK');
                                  },
                                  iconData: Icons.warning_amber_rounded,
                                ),
                              ),
                            // if ( order.status.toLowerCase() == 'rejected' && order.isRejectFromPrescription )
                            //   Container(width : SizeConfig.screenWidth * 0.1 ,height: 0.0),
                            // if ( order.status.toLowerCase() == 'rejected' && order.isRejectFromPrescription )
                            //   SizedBox(
                            //     height: 50,
                            //     width: SizeConfig.screenWidth * 0.1,
                            //     child: OrderIconButton(
                            //       press: () async {
                            //         // File file = await showPickFileDialog(context: context, msgText: ['You need to upload the Prescription again.',pharNote]);
                            //         // print('file $file');
                            //         // if ( file != null )
                            //         // Provider.of<FireBaseAuth>(context,listen: false).updateOrderPrescription( orderId, pharmacyId, productId, orderNo, file);
                            //       },
                            //       iconData: Icons.warning_amber_rounded,
                            //     ),
                            //   ),
                            // if ( order.status.toLowerCase() == 'rejected' && !order.isRejectFromPrescription && order.pharNote != null && order.pharNote != '' )
                            //   Container(width : SizeConfig.screenWidth * 0.1 ,height: 0.0),
                            // if ( order.status.toLowerCase() == 'rejected' && !order.isRejectFromPrescription && order.pharNote != null && order.pharNote != '' )
                            //   SizedBox(
                            //     height: 50,
                            //     width: SizeConfig.screenWidth * 0.1,
                            //     child: OrderIconButton(
                            //       press: () async {
                            //         await showMessageDialog(context: context,msgTitle: 'Order' , msgText: [order.pharNote], buttonText: 'OK');
                            //       },
                            //       iconData: Icons.warning_amber_rounded,
                            //     ),
                            //   ),
                            // if ( order.status.toLowerCase() == 'accepted' )
                            //   Container(width : SizeConfig.screenWidth * 0.010 ,height: 0.0),
                            // if ( order.status.toLowerCase() == 'accepted' )
                            //   SizedBox(
                            //     height: 50,
                            //     // width: SizeConfig.screenWidth * 0.05,
                            //     child: OrderIconButton(
                            //       press: () async {
                            //         // Patient user = await Provider.of<FireBaseAuth>(context,listen:false).currentUser;
                            //         // GeoPoint userLocation = user.addressGeoPoint;
                            //         // Product product = await Provider.of<ProductProvider>(context,listen: false).getProductData(productId, pharmacyId, userLocation);
                            //         // if ( product != null ){
                            //         //   Navigator.pushNamed(context, OrderProduct.routeName,arguments: product);
                            //         // }else{
                            //         //   showMessageDialog(
                            //         //       context: context,
                            //         //       msgTitle: 'Warning',
                            //         //       msgText: [
                            //         //         'Something went wrong','Please try again.'
                            //         //       ],
                            //         //       buttonText: 'OK');
                            //         // }
                            //       },
                            //       iconData: Icons.refresh,
                            //       text: 'Order Again',
                            //     ),
                            //   ),
                          ],
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
    );
  }
}

//
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:graduationproject/Screens/SelectProduct.dart';
// import 'package:graduationproject/Screens/order.dart';
// import 'package:graduationproject/components/MessageDialog.dart';
// import 'package:graduationproject/components/default_button.dart';
// import 'package:graduationproject/components/orderButton.dart';
// import 'package:graduationproject/constants.dart';
// import 'package:graduationproject/data_models/Patient.dart';
// import 'package:graduationproject/data_models/Product.dart';
// import 'package:graduationproject/firebase/auth/auth.dart';
// import 'package:graduationproject/providers/ProductProvider.dart';
// import 'package:graduationproject/size_config.dart';
// import 'package:provider/provider.dart';
//
// class UserOrders extends StatelessWidget {
//   static String routeName = "/user_orders";
//   const UserOrders({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('My Orders'),
//       ),
//       body: Body(),
//     );
//   }
// }
//
// class Body extends StatelessWidget {
//   const Body({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var auth = Provider.of<FireBaseAuth>(context, listen: true);
//     String userId = auth.userId;
//     return SafeArea(
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('Order').where('userId',isEqualTo:userId ).snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//
//           List<Widget> widgets = [];
//           if (snapshot.connectionState == ConnectionState.waiting ) {
//             widgets.add(
//               Center(
//                 child: Text(
//                   'Please wait...',
//                   style: TextStyle(
//                     fontSize: getProportionateScreenWidth(20),
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             );
//             widgets.add(
//               SizedBox(
//                 width: SizeConfig.screenWidth * 0.6,
//                 height: SizeConfig.screenHeight * 0.025,
//               ),
//             );
//             widgets.add(
//               // SizedBox(
//               //   width: SizeConfig.screenWidth * 0.05,
//               //   height: SizeConfig.screenHeight * 0.025,
//               //   child: CircularProgressIndicator(
//               //     backgroundColor: kPrimaryColor,
//               //   ),
//               // ),
//               SpinKitDoubleBounce(
//                 color: kPrimaryColor,
//                 size: SizeConfig.screenWidth * 0.15,
//               ),
//             );
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: widgets,
//             );
//           }
//
//           final orders = snapshot.data.docs.reversed;
//           for (var order in orders) {
//             var noOfProducts = order.data()['NoOfProducts'];
//             var orderNo = order.data()['OrderNo'];
//             var status = order.data()['Status'];
//             var orderTime = order.data()['orderTime'];
//             var pharmacyId = order.data()['pharmacyId'];
//             var pharmacyName = order.data()['pharmacyName'];
//             var totalPrice = order.data()['totalPrice'];
//             var userAge = order.data()['userAge'];
//             var userHealthState = order.data()['userHealthState'];
//             var userId = order.data()['userHealthState'];
//             var userName = order.data()['userHealthState'];
//             // var productName = order.data()['productName'];
//
//             // var productImageUrl = order.data()['productImageUrl'];
//             // var productId = order.data()['productId'];
//             // var pharNote = '';
//             // var isRejectFromPrescription = false;
//             // if (status == 'Rejected') {
//             //   pharNote = order.data()['PharNote'];
//             //   isRejectFromPrescription =
//             //   order.data()['isRejectFromPrescription'];
//             // }
//             widgets.add(OrderWidget(
//               // isRejectFromPrescription: isRejectFromPrescription,
//               // productId: productId,
//               // pharNote: pharNote,
//               orderId: order.id,
//               orderNo: orderNo,
//               pharmacyId: pharmacyId,
//               pharmacyName: pharmacyName,
//               productName: 'productName',
//               price: totalPrice.toString(),
//               productImage: null,
//               status: status,
//             ));
//             widgets.add(
//               Divider(
//                 color: Colors.black.withOpacity(0.25),
//                 thickness: 1,
//               ),
//             );
//           }
//
//           if (widgets.length == 0) {
//             widgets.add(
//               Icon(
//                 Icons.hourglass_empty,
//                 color: kPrimaryColor,
//                 size: SizeConfig.screenWidth * 0.4,
//               ),
//             );
//             widgets.add(
//               Center(
//                 child: Text(
//                   'You don\'t have any Orders',
//                   style: TextStyle(
//                     fontSize: getProportionateScreenWidth(20),
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             );
//             widgets.add(
//               SizedBox(
//                 width: SizeConfig.screenWidth * 0.6,
//                 height: SizeConfig.screenHeight * 0.025,
//               ),
//             );
//             widgets.add(
//               SizedBox(
//                 width: SizeConfig.screenWidth * 0.6,
//                 height: SizeConfig.screenHeight * 0.05,
//                 child: DefaultButton(
//                   text: "Order Now",
//                   press: () {
//                     // Navigator.pu(context, HomeScreen.routeName);
//                     Provider.of<ProductProvider>(context, listen: false)
//                         .initiate();
//                     Navigator.of(context)
//                         .pushReplacementNamed(SelectProduct.routeName);
//                   },
//                 ),
//               ),
//             );
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: widgets,
//             );
//           }
//
//           return ListView(
//
//             padding: EdgeInsets.symmetric(
//               horizontal: 10.0,
//               vertical: 10.0,
//             ),
//             children: widgets,
//           );
//         },
//       ),
//     );
//   }
// }
//
// class OrderWidget extends StatelessWidget with CanShowMessages {
//   final String productId,
//       orderId,
//       pharmacyId,
//       productName,
//       pharmacyName,
//       price,
//       status,
//       productImage,
//       pharNote;
//   final int orderNo;
//   final bool isRejectFromPrescription;
//   OrderWidget(
//       {Key key,
//         this.orderId,
//         this.pharNote,
//         this.orderNo,
//         this.productId,
//         this.pharmacyId,
//         this.pharmacyName,
//         this.productName,
//         this.price,
//         this.status,
//         this.productImage,
//         this.isRejectFromPrescription })
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       type: MaterialType.canvas,
//       child: Padding(
//         padding: const EdgeInsets.only(
//             left: 15.0, bottom: 10.0, right: 10.0, top: 10.0),
//         child: Container(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               productImage != null && productImage != ''
//                   ? Image.network(
//                 productImage,
//                 height: getProportionateScreenHeight(135),
//                 width: getProportionateScreenWidth(75),
//               )
//                   : Image.asset(
//                 "assets/images/syrup.png",
//                 height: getProportionateScreenHeight(90),
//                 width: getProportionateScreenWidth(75),
//               ),
//               SizedBox(
//                 width: getProportionateScreenWidth(20),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     productName ,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   Text(
//                     pharmacyName,
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.w200),
//                   ),
//                   Text(
//                     price.toString() + " JOD",
//                     style: TextStyle(
//                         color: kPrimaryColor,
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.w500),
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         height: 50,
//                         width: SizeConfig.screenWidth * 0.35,
//                         child: OrderButton(
//                           width: SizeConfig.screenWidth * 0.35,
//                           height: 40,
//                           press: null,//status.toLowerCase() != 'accepted' ? null : () { },
//                           text: status.toLowerCase() == 'pending'
//                               ? 'In Progress'
//                               : status,
//                           isRed: status.toLowerCase() == 'rejected',
//                         ),
//                       ),
//                       if ( status.toLowerCase() == 'rejected' && isRejectFromPrescription )
//                         Container(width : SizeConfig.screenWidth * 0.1 ,height: 0.0),
//                       if ( status.toLowerCase() == 'rejected' && isRejectFromPrescription )
//                         SizedBox(
//                           height: 50,
//                           width: SizeConfig.screenWidth * 0.1,
//                           child: OrderIconButton(
//                             press: () async {
//                               File file = await showPickFileDialog(context: context, msgText: ['You need to upload the Prescription again.',pharNote]);
//                               print('file $file');
//                               if ( file != null )
//                                 Provider.of<FireBaseAuth>(context,listen: false).updateOrderPrescription( orderId, pharmacyId, productId, orderNo, file);
//                             },
//                             iconData: Icons.warning_amber_rounded,
//                           ),
//                         ),
//                       if ( status.toLowerCase() == 'rejected' && !isRejectFromPrescription && pharNote != null && pharNote != '' )
//                         Container(width : SizeConfig.screenWidth * 0.1 ,height: 0.0),
//                       if ( status.toLowerCase() == 'rejected' && !isRejectFromPrescription && pharNote != null && pharNote != '' )
//                         SizedBox(
//                           height: 50,
//                           width: SizeConfig.screenWidth * 0.1,
//                           child: OrderIconButton(
//                             press: () async {
//                               await showMessageDialog(context: context,msgTitle: 'Order' , msgText: [pharNote], buttonText: 'OK');
//                             },
//                             iconData: Icons.warning_amber_rounded,
//                           ),
//                         ),
//                       if ( status.toLowerCase() == 'accepted' )
//                         Container(width : SizeConfig.screenWidth * 0.010 ,height: 0.0),
//                       if ( status.toLowerCase() == 'accepted' )
//                         SizedBox(
//                           height: 50,
//                           // width: SizeConfig.screenWidth * 0.05,
//                           child: OrderIconButton(
//                             press: () async {
//                               Patient user = await Provider.of<FireBaseAuth>(context,listen:false).currentUser;
//                               GeoPoint userLocation = user.addressGeoPoint;
//                               Product product = await Provider.of<ProductProvider>(context,listen: false).getProductData(productId, pharmacyId, userLocation);
//                               if ( product != null ){
//                                 Navigator.pushNamed(context, OrderProduct.routeName,arguments: product);
//                               }else{
//                                 showMessageDialog(
//                                     context: context,
//                                     msgTitle: 'Warning',
//                                     msgText: [
//                                       'Something went wrong','Please try again.'
//                                     ],
//                                     buttonText: 'OK');
//                               }
//                             },
//                             iconData: Icons.refresh,
//                             text: 'Order Again',
//                           ),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
