import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/data_models/Product.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatelessWidget {
  static const String routeName = 'RequestScreen';

  @override
  Widget build(BuildContext context) {
    var phar = Provider.of<FireBaseAuth>(context, listen: true).pharmacist;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Medicines',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        backgroundColor: Color(0xFF42ADAC),
        leading: TextButton(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: phar != null && phar.pharmacy != null
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('PHARMACY')
                        .doc(phar.pharmacy.pharmacyId)
                        .collection('MEDICINE')
                        .snapshots(),
                    builder: (context, snapshot) {
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

                      final medicines = snapshot.data.docs;
                      int i = 0;
                      for (var medicine in medicines) {
                        bool isApp = medicine.data()['isApproved'];
                        if (isApp == null || isApp) continue;
                        Product product = Product();
                        product.id = medicine.id;
                        product.name = medicine.data()['name'];
                        Map<String, dynamic> map =
                            medicine.data()['DosagePills'];
                        map.forEach((key, value) {
                          int k = int.tryParse(key);
                          product.dosagePills.addAll({k: value});
                        });
                        product.dosageUnit = medicine.data()['dosageUnit'];
                        product.prescriptionRequired =
                            medicine.data()['PrescriptionRequired'];
                        product.description = medicine.data()['description'];
                        product.pillsUnit = medicine.data()['pillsUnit'];
                        var productImageUrl = medicine.data()['imageURLs'];
                        if (productImageUrl != null &&
                            productImageUrl.length > 0) {
                          for (var image in productImageUrl) {
                            product.imageUrls.add(image.toString());
                          }
                        } else {
                          product.imageUrls = [];
                        }
                        product.barcode = medicine.data()['barCode'];
                        var price = medicine.data()['price'];
                        if (price.runtimeType == int) {
                          double p = double.parse(price.toString());
                          product.price = p;
                        } else
                          product.price = price;
                        widgets.add(
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      'BarCode: ${product.barcode}',
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await Provider.of<FireBaseAuth>(context, listen: false).updateCollectionFieldWithRef(ref: FirebaseFirestore.instance.collection('PHARMACY').doc(phar.pharmacy.pharmacyId).collection('MEDICINE').doc(product.id), fieldName: 'isApproved', fieldValue: true);
                                  },
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        CircleBorder()),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.green),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance.collection('PHARMACY').doc(phar.pharmacy.pharmacyId).collection('MEDICINE').doc(product.id).delete();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        CircleBorder()),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        widgets.add(
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
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
                              'You don\'t have any requests',
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
                        padding: EdgeInsets.all(8.0),
                        children: widgets,
                      );
                    })
                : ListView(
                    padding: EdgeInsets.all(8.0),
                    children: [
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
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.6,
                        height: SizeConfig.screenHeight * 0.025,
                      ),
                      SpinKitDoubleBounce(
                        color: kPrimaryColor,
                        size: SizeConfig.screenWidth * 0.15,
                      ),
                    ],
                  ),
            // ListView(
            //   children: [
            //     Container(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'Medicine Name',
            //                 style: TextStyle(
            //                     color: Colors.grey.shade800, fontSize: 25),
            //               ),
            //               Text(
            //                 'BarCode: 12345678',
            //                 style: TextStyle(
            //                     color: Colors.grey.shade800, fontSize: 15),
            //               ),
            //               Text(
            //                 'Request by: EmployeeName',
            //                 style: TextStyle(
            //                     color: Colors.grey.shade800, fontSize: 15),
            //               ),
            //             ],
            //           ),
            //           TextButton(
            //             onPressed: () {
            //
            //             },
            //             child:Icon(
            //               Icons.check_circle,
            //               color: Colors.white,
            //             ),
            //             style: ButtonStyle(
            //               shape: MaterialStateProperty.all(CircleBorder() ),
            //               backgroundColor: MaterialStateProperty.all(Colors.green),
            //             ),
            //           ),
            //           TextButton(
            //             onPressed: () {
            //
            //             },
            //             child:Icon(
            //               Icons.close,
            //               color: Colors.white,
            //             ),
            //             style: ButtonStyle(
            //               shape: MaterialStateProperty.all(CircleBorder() ),
            //               backgroundColor: MaterialStateProperty.all(Colors.red),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     SizedBox(height: 15,),
            //     Container(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'Medicine Name',
            //                 style: TextStyle(
            //                     color: Colors.grey.shade800, fontSize: 25),
            //               ),
            //               Text(
            //                 'BarCode: 12345678',
            //                 style: TextStyle(
            //                     color: Colors.grey.shade800, fontSize: 15),
            //               ),
            //               Text(
            //                 'Request by: EmployeeName',
            //                 style: TextStyle(
            //                     color: Colors.grey.shade800, fontSize: 15),
            //               ),
            //             ],
            //           ),
            //           TextButton(
            //             onPressed: () {
            //
            //             },
            //             child:Icon(
            //               Icons.check_circle,
            //               color: Colors.white,
            //             ),
            //             style: ButtonStyle(
            //               shape: MaterialStateProperty.all(CircleBorder() ),
            //               backgroundColor: MaterialStateProperty.all(Colors.green),
            //             ),
            //           ),
            //           TextButton(
            //             onPressed: () {
            //
            //             },
            //             child:Icon(
            //               Icons.close,
            //               color: Colors.white,
            //             ),
            //             style: ButtonStyle(
            //               shape: MaterialStateProperty.all(CircleBorder() ),
            //               backgroundColor: MaterialStateProperty.all(Colors.red),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     SizedBox(height: 15,),
            //     Container(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'Medicine Name',
            //                 style: TextStyle(
            //                     color: Colors.grey.shade800, fontSize: 25),
            //               ),
            //               Text(
            //                 'BarCode: 12345678',
            //                 style: TextStyle(
            //                     color: Colors.grey.shade800, fontSize: 15),
            //               ),
            //               Text(
            //                 'Request by: EmployeeName',
            //                 style: TextStyle(
            //                     color: Colors.grey.shade800, fontSize: 15),
            //               ),
            //             ],
            //           ),
            //           TextButton(
            //             onPressed: () {
            //
            //             },
            //             child:Icon(
            //               Icons.check_circle,
            //               color: Colors.white,
            //             ),
            //             style: ButtonStyle(
            //               shape: MaterialStateProperty.all(CircleBorder() ),
            //               backgroundColor: MaterialStateProperty.all(Colors.green),
            //             ),
            //           ),
            //           TextButton(
            //             onPressed: () {
            //
            //             },
            //             child:Icon(
            //               Icons.close,
            //               color: Colors.white,
            //             ),
            //             style: ButtonStyle(
            //               shape: MaterialStateProperty.all(CircleBorder() ),
            //               backgroundColor: MaterialStateProperty.all(Colors.red),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     SizedBox(height: 15,),
            //     Container(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'Medicine Name',
            //                 style: TextStyle(
            //                     color: Colors.grey.shade800, fontSize: 25),
            //               ),
            //               Text(
            //                 'BarCode: 12345678',
            //                 style: TextStyle(
            //                     color: Colors.grey.shade800, fontSize: 15),
            //               ),
            //               Text(
            //                 'Request by: EmployeeName',
            //                 style: TextStyle(
            //                     color: Colors.grey.shade800, fontSize: 15),
            //               ),
            //             ],
            //           ),
            //           TextButton(
            //             onPressed: () {
            //
            //             },
            //             child:Icon(
            //               Icons.check_circle,
            //               color: Colors.white,
            //             ),
            //             style: ButtonStyle(
            //               shape: MaterialStateProperty.all(CircleBorder() ),
            //               backgroundColor: MaterialStateProperty.all(Colors.green),
            //             ),
            //           ),
            //           TextButton(
            //             onPressed: () {
            //
            //             },
            //             child:Icon(
            //               Icons.close,
            //               color: Colors.white,
            //             ),
            //             style: ButtonStyle(
            //               shape: MaterialStateProperty.all(CircleBorder() ),
            //               backgroundColor: MaterialStateProperty.all(Colors.red),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     SizedBox(height: 15,),
            //   ],
            // ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF42ADAC)),
                      onPressed: () {},
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Cancel all'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF42ADAC)),
                      onPressed: () {},
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Accept all'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
