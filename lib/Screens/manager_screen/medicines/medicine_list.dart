import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/data_models/Product.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';
import 'add_medicine.dart';
import 'medicine_screen.dart';

List<Widget> medicines;

class MedicineList extends StatefulWidget {
  static const String routeName = 'MedicineList';

  @override
  _MedicineListState createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> with CanShowMessages {
  User loggedInUser;
  Pharmacist phar;

  @override
  void initState() {
    super.initState();

    getPharmacist();
  }

  Future<void> getPharmacist() async {
    Pharmacist p =
        await Provider.of<FireBaseAuth>(context, listen: false).currentUser;
    setState(() {
      phar = p;
    });
  }

  String _scanBarcode = 'Unknown';

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      print(_scanBarcode);
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
      if (barcodeScanRes == '-1') {
        return null;
      }
      return barcodeScanRes;
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      return null;
    }
    //
    // // If the widget was removed from the tree while the asynchronous platform
    // // message was in flight, we want to discard the reply rather than calling
    // // setState to update our non-existent appearance.
    // if (!mounted) return;
    //
    // setState(() {
    //   _scanBarcode = barcodeScanRes;
    // });
  }

  @override
  Widget build(BuildContext context) {
    loggedInUser = Provider.of<FireBaseAuth>(context, listen: false).loggedUser;
    // phar = Provider.of<FireBaseAuth>(context, listen: false).pharmacist;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF099F9D),
        tooltip: "Click here to add new Medicine",
        child: Icon(Icons.add),
        onPressed: () async{
          await showDialog(
              builder: (context) => AlertDialog(
                    title: Text("Add new medicine"),
                    content: Container(
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              String barcode = await scanBarcodeNormal();
                              if (barcode != null && barcode != '') {
                                bool cond = await Provider.of<FireBaseAuth>(
                                        context,
                                        listen: false)
                                    .checkMedicineExistenceByBarcode(
                                        barcode: barcode);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Barcode : $barcode'),
                                  duration: Duration(seconds: 15),
                                ));
                                if (!cond) {
                                  QuestionMessage answer =
                                      await showQuestionDialog(
                                          context: context,
                                          msgTitle: 'Add Medicine',
                                          msgText: [
                                            'Medicine is not exist in the official medicines.',
                                            'Do you want to add it manually?'
                                          ],
                                          buttonText: '');
                                  if (answer == QuestionMessage.YES) {
                                    Navigator.pushNamed(
                                        context, AddMedicine.routeName,
                                        arguments: barcode);
                                  }
                                } else {
                                  bool condPhar = await Provider.of<
                                          FireBaseAuth>(context, listen: false)
                                      .checkPharmacyMedicineExistenceByBarcode(
                                          barcode: barcode);
                                  print(
                                      '-*************************** $condPhar');
                                  if (!condPhar) {
                                    await Provider.of<FireBaseAuth>(context,
                                            listen: false)
                                        .addMedicineToPharmacyFromOfficialByBarcode(
                                            barCode: barcode);
                                    await showMessageDialog(
                                        context: context,
                                        msgTitle: 'Add Medicine',
                                        msgText: [
                                          'Medicine added successfully to your pharmacy.'
                                        ],
                                        buttonText: 'OK');
                                  } else {
                                    await showMessageDialog(
                                        context: context,
                                        msgTitle: 'Warning',
                                        msgText: [
                                          'Medicine already exists in your pharmacy.'
                                        ],
                                        buttonText: 'OK');
                                  }
                                }
                              }
                            },
                            child: Container(
                              width: 150,
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Center(
                                child: Text(
                                  'By Scan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFF099F9D)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        side: BorderSide(
                                          color: Colors.white,
                                          width: 2,
                                        )))),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AddMedicine.routeName);
                            },
                            child: Container(
                              width: 150,
                              padding: EdgeInsets.only(bottom: 6.0),
                              child: Center(
                                child: Text(
                                  'Manually',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFF099F9D)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        side: BorderSide(
                                          color: Colors.white,
                                          width: 2,
                                        )))),
                          ),
                        ],
                      ),
                    ),
                  ),
              context: context);
        },
      ),
      appBar: AppBar(
        title: Text(
          'Medicine List',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF099F9D),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: phar != null && phar.pharmacy != null
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
                  Product product = Product();
                  product.id = medicine.id;
                  product.name = medicine.data()['name'];
                  Map<String,dynamic> map = medicine.data()['DosagePills'];
                  map.forEach((key, value) {
                    int k = int.tryParse(key);
                    product.dosagePills.addAll({k:value});
                  });
                  product.dosageUnit = medicine.data()['dosageUnit'];
                  product.prescriptionRequired = medicine.data()['PrescriptionRequired'];
                  product.description = medicine.data()['description'];
                  product.pillsUnit = medicine.data()['pillsUnit'];
                  var productImageUrl = medicine.data()['imageURLs'];
                  print(productImageUrl.length );
                  if ( productImageUrl == null || productImageUrl.length == 0 ){
                    product.imageUrls = [];
                  }else {
                    for( var image in productImageUrl ){
                      product.imageUrls.add(image.toString());
                    }
                  }
                  product.barcode = medicine.data()['barCode'];
                  var price = medicine.data()['price'];
                  if (price.runtimeType == int) {
                    double p = double.parse(price.toString());
                    product.price = p;
                  } else
                    product.price = price;
                  widgets.add(
                    MedicineWidget(
                      product: product,
                    ),
                  );
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
                        'You don\'t have any Medicines',
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
                        text: "Add Medicine Now",
                        press: () async{
                          await showDialog(
                              builder: (context) => AlertDialog(
                                title: Text("Add new medicine"),
                                content: Container(
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          String barcode = await scanBarcodeNormal();
                                          if (barcode != null && barcode != '') {
                                            bool cond = await Provider.of<FireBaseAuth>(
                                                context,
                                                listen: false)
                                                .checkMedicineExistenceByBarcode(
                                                barcode: barcode);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text('Barcode : $barcode'),
                                              duration: Duration(seconds: 15),
                                            ));
                                            if (!cond) {
                                              QuestionMessage answer =
                                              await showQuestionDialog(
                                                  context: context,
                                                  msgTitle: 'Add Medicine',
                                                  msgText: [
                                                    'Medicine is not exist in the official medicines.',
                                                    'Do you want to add it manually?'
                                                  ],
                                                  buttonText: '');
                                              if (answer == QuestionMessage.YES) {
                                                Navigator.pushNamed(
                                                    context, AddMedicine.routeName,
                                                    arguments: barcode);
                                              }
                                            } else {
                                              bool condPhar = await Provider.of<
                                                  FireBaseAuth>(context, listen: false)
                                                  .checkPharmacyMedicineExistenceByBarcode(
                                                  barcode: barcode);
                                              print(
                                                  '-*************************** $condPhar');
                                              if (!condPhar) {
                                                await Provider.of<FireBaseAuth>(context,
                                                    listen: false)
                                                    .addMedicineToPharmacyFromOfficialByBarcode(
                                                    barCode: barcode);
                                                await showMessageDialog(
                                                    context: context,
                                                    msgTitle: 'Add Medicine',
                                                    msgText: [
                                                      'Medicine added successfully to your pharmacy.'
                                                    ],
                                                    buttonText: 'OK');
                                              } else {
                                                await showMessageDialog(
                                                    context: context,
                                                    msgTitle: 'Warning',
                                                    msgText: [
                                                      'Medicine already exists in your pharmacy.'
                                                    ],
                                                    buttonText: 'OK');
                                              }
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 150,
                                          padding: EdgeInsets.only(bottom: 6.0),
                                          child: Center(
                                            child: Text(
                                              'By Scan',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(
                                                Color(0xFF099F9D)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(25.0),
                                                    side: BorderSide(
                                                      color: Colors.white,
                                                      width: 2,
                                                    )))),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, AddMedicine.routeName);
                                        },
                                        child: Container(
                                          width: 150,
                                          padding: EdgeInsets.only(bottom: 6.0),
                                          child: Center(
                                            child: Text(
                                              'Manually',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(
                                                Color(0xFF099F9D)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(25.0),
                                                    side: BorderSide(
                                                      color: Colors.white,
                                                      width: 2,
                                                    )))),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              context: context);
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
    );
  }
}
//
// class Data extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: ,
//       builder: (context, snapshot) {
//         return ListView(
//           padding: EdgeInsets.all(8.0),
//           children: widgets,
//         );
//       }
//     );
//   }
// }

class MedicineWidget extends StatelessWidget {
  final Product product;
  const MedicineWidget({Key key,this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Material(
      color: Colors.white,
      type: MaterialType.canvas,
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(5.0)),
        child: InkWell(
          onTap: (){
            Navigator.of(context).pushNamed(MedicineScreenManager.routeName,arguments: product);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(5.0),horizontal: getProportionateScreenWidth(10.0)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
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
                product.imageUrls[0] != null && product.imageUrls[0] != ''
                    ? Image.network(
                  product.imageUrls[0],
                  height: getProportionateScreenHeight(100),
                  width: SizeConfig.screenWidth *0.25 ,
                )
                    : Image.asset(
                  "assets/images/syrup.png",
                  height: getProportionateScreenHeight(100),
                  width: SizeConfig.screenWidth *0.25 ,
                ),
                SizedBox(
                  width: getProportionateScreenWidth(10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name != null && product.name != '' ? product.name : '' ,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(18.0),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Text(
                      product.barcode ,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(18.0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Text(
                      "${product.price.toStringAsFixed(2)} JOD",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(18.0),
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


class Medicine extends StatelessWidget {
  final int number;
  final String name;
  final String barCode;
  final String price;

  // final Image image;

  Medicine({this.number, this.name, this.barCode, this.price});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$number. ',
                      style: TextStyle(fontSize: 25),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 210,
                      child: Text(
                        name,
                        style: TextStyle(fontSize: 25),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text('BarCode: $barCode'),
              ],
            ),
            Text(
              '${price.substring(0, 4)} JOD',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, MedicineScreenManager.routeName);
      },
    );
  }
}

class NoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          'No data, press + to add a medicine',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
