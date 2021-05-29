import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduationproject/Screens/OrderInfoScreen.dart';
import 'package:graduationproject/Screens/manager_screen/order/PharmacyOrderInfoScreen.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/orderButton.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/data_models/OrderClass.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/data_models/Pharmacy.dart';
import 'package:graduationproject/data_models/Product.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//
// class OrderList extends StatelessWidget {
//   static const String routeName = 'OrderList';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Orders',
//           style: TextStyle(
//             fontSize: 25,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Color(0xFF099F9D),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: Text('1. Order by Mohammad Al-Hrout'),
//             onTap: (){
//               Navigator.pushNamed(context, OrderScreen.routeName);
//             },
//           ),
//           ListTile(
//             title: Text('2. Order by customerName'),
//           ),
//           ListTile(
//             title: Text('3. Order by customerName'),
//           ),
//         ],
//       ),
//     );
//   }
// }

class OrderList extends StatelessWidget {
  static const String routeName = 'OrderList';
  const OrderList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Orders'),
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
    Pharmacist user = auth.pharmacist;
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Order').where('pharmacyId',isEqualTo:user.pharmacy.pharmacyId ).snapshots(),
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
            _order.userName = order.data()['userName'] ;
            _order.UserPhoneNo = order.data()['UserPhoneNo'] ;
            _order.userAge = order.data()['userAge'] ;
            _order.userHealthState = order.data()['userHealthState'] ;
            _order.userLocation = order.data()['userLocation'] ;
            var distance = order.data()['distance'];
            if (distance.runtimeType == int) {
              double p = double.parse(distance.toString());
              _order.pharmacy.distance = p;
            } else
              _order.pharmacy.distance = distance;
            _order.products = [];
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
            widgets.add(PharmacyOrderWidget(order:_order,));
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

class PharmacyOrderWidget extends StatelessWidget with CanShowMessages {
  final Order order;
  PharmacyOrderWidget(
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
              product.prescriptionUrl = prescriptionUrl;
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
                  Navigator.of(context).pushNamed(PharmacyOrderInfoScreen.routeName,arguments: order);
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
                              fontSize: getProportionateScreenHeight(18),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if ( order.noOfProducts > 1 )
                            Text(
                              '+ ${order.noOfProducts -1} products',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenHeight(15),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          Text(
                            'Order Id: '+order.orderNo.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenHeight(17),
                                fontWeight: FontWeight.w200),
                          ),
                          Text(
                            'Order By: '+order.userName,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenHeight(17),
                                fontWeight: FontWeight.w200),
                          ),
                          Text(
                            'Time: '+DateFormat("hh:mm a dd/MM/yyyy").format(order.orderTime),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenHeight(17),
                                fontWeight: FontWeight.w200),
                          ),
                          Text(
                            'Distance: '+(order.pharmacy.distance/1000.0).toStringAsFixed(2)+'Km',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenHeight(17),
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
                            "${order.totalPrice.toStringAsFixed(2)} JOD",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: getProportionateScreenHeight(17),
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 50,
                            width: SizeConfig.screenWidth * 0.35,
                            child: OrderButton(
                              width: SizeConfig.screenWidth * 0.35,
                              height: 40,
                              press: null,
                              text: order.status,
                            ),
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
