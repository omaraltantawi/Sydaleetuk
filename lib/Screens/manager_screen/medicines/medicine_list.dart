
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:provider/provider.dart';
import 'add_medicine.dart';
import 'medicine_screen.dart';

List<Widget> medicines;

class MedicineList extends StatefulWidget  {
  static const String routeName = 'MedicineList';

  @override
  _MedicineListState createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> with CanShowMessages{
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
        '#ff6666', 'Cancel', true, ScanMode.BARCODE).listen((barcode) => print(barcode));
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

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF099F9D),
        tooltip: "Click here to add new Medicine",
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
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
                              bool cond = await Provider.of<FireBaseAuth>(context,listen: false).checkMedicineExistenceByBarcode(barcode: barcode);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Barcode : $barcode'),
                                duration: Duration(seconds: 15),
                              ));
                              if ( !cond ){
                                QuestionMessage answer = await showQuestionDialog(
                                context: context,
                                msgTitle: 'Add Medicine',
                                msgText: [
                                  'Medicine is not exist in the official medicines.',
                                  'Do you want to add it manually?'
                                ],
                                buttonText: '');
                                if (answer == QuestionMessage.YES) {
                                  Navigator.pushNamed(context, AddMedicine.routeName);
                                }
                              }else {
                                bool condPhar = await Provider.of<FireBaseAuth>(context,listen: false).checkPharmacyMedicineExistenceByBarcode(barcode: barcode);
                                if ( !condPhar ){
                                  await Provider.of<FireBaseAuth>(context,listen: false).addMedicineToPharmacyFromOfficialByBarcode(barCode: barcode);
                                  await showMessageDialog(context: context, msgTitle: 'Add Medicine', msgText: ['Medicine added successfully to your pharmacy.'], buttonText: 'OK');
                                }else {
                                  await showMessageDialog(context: context, msgTitle: 'Warning', msgText: ['Medicine already exists in your pharmacy.'], buttonText: 'OK');
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
      body: listMedicines().length == 0 ? NoData() : Data(),
    );
  }
}

class Data extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: listMedicines(),
    );
  }
}
List<Widget> listMedicines() {
  medicines = [
  ];

  return medicines;
}

class Medicine extends StatelessWidget {
  final int number;
  final String name;
  final int barCode;
  final String price;

  // final Image image;

  Medicine({this.number, this.name,this.barCode, this.price});

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
                      width: MediaQuery.of(context).size.width-210,
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
              '${price.substring(0,4)} JOD',
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
