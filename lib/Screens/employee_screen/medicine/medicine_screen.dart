import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:graduationproject/Screens/employee_screen/medicine/medicine.dart';
import 'package:graduationproject/Screens/manager_screen/medicines/add_medicine.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/orderButton.dart';
import 'package:graduationproject/data_models/Product.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';

class EmployeeMedicineScreen extends StatelessWidget {

  static const String routeName = 'EmployeeMedicineScreen';
  const EmployeeMedicineScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments as Product;
    return Body(
      product: product,
    );
  }
}

class Body extends StatefulWidget {
  final Product product;
  Body({this.product});
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with CanShowMessages{
  Medicine medicine = Medicine(
      name: 'Vitamin C man zinc tupedu',
      barCode: '2013546136',
      price: '3.4',
      description:
      'Aspirin is used to reduce fever and relieve mild to moderate pain from conditions such as muscle aches, toothaches, common cold, and headaches. It may also be used to reduce pain and swelling in conditions such as arthritis.',
      image: [
        Image.network(
            'https://kaifanonline.com/ecdata/stores/GRYBA173/image/cache/data/products/1602084178_aspirin-protect-595x738.png'),
        Image.network(
            'https://kaifanonline.com/ecdata/stores/GRYBA173/image/cache/data/products/1602084178_aspirin-protect-595x738.png'),
        Image.network(
            'https://kaifanonline.com/ecdata/stores/GRYBA173/image/cache/data/products/1602084178_aspirin-protect-595x738.png'),
        Image.network(
            'https://kaifanonline.com/ecdata/stores/GRYBA173/image/cache/data/products/1602084178_aspirin-protect-595x738.png'),
      ],
      prescription: false);


  @override
  void initState() {
    super.initState();

    orderDosagePills();

  }

  Color background = Color(0xFF099F9D);
  TextStyle _textStyle1 = TextStyle(
    color: Colors.black,
    fontSize: getProportionateScreenWidth(18),
  );
  TextStyle _textStyle = TextStyle(
    color: Color(0xFF099F9D),
    fontSize: getProportionateScreenWidth(18),
  );

  orderDosagePills() {
    List<Map<int, int>> listData = [];
    widget.product.dosagePills
        .forEach((key, value) => listData.add({key: value}));
    listData.sort((a, b) => a.keys.first.compareTo(b.keys.first));
    setState(() {
      widget.product.dosagePills = Map.fromIterable(listData,
          key: (e) => e.keys.first, value: (e) => e.values.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<FireBaseAuth>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.product.name}',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: background,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding:
        EdgeInsets.only(top: getProportionateScreenHeight(2.0), left: getProportionateScreenWidth(15.0), right: getProportionateScreenWidth(15.0), bottom: getProportionateScreenHeight(15.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: SizeConfig.screenHeight*0.35,
                child: widget.product.imageUrls != null && widget.product.imageUrls.length > 0 ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.product.imageUrls.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Image.network(
                      widget.product.imageUrls[index],
                    );
                  },
                ) : Center(
                  child: Image.asset(
                    "assets/images/syrup.png",
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Name: ',
                        style: _textStyle,
                      ),
                      Expanded(
                        child: Text(
                          '${widget.product.name}',
                          style: _textStyle1,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    TextEditingController _controller =
                    TextEditingController(text: widget.product.name);
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Change name'),
                          actions: [
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter new name',
                                labelText: 'New name',
                              ),
                              controller: _controller,
                              minLines: 1,
                              maxLines: 3,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    child: Text('Submit'),
                                    onPressed: () async {
                                      setState(() {
                                        widget.product.name = _controller.text;
                                      });
                                      await auth.updateCollectionFieldWithRef(
                                          ref: FirebaseFirestore.instance
                                              .collection('PHARMACY')
                                              .doc(auth.pharmacist.pharmacy.pharmacyId)
                                              .collection('MEDICINE')
                                              .doc(widget.product.id),
                                          fieldName: 'name',
                                          fieldValue: widget.product.name);
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          background),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          background),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Barcode: ',
                  style: _textStyle,
                ),
                Text(
                  widget.product.barcode,
                  style: _textStyle1,
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    TextEditingController _controller =
                    TextEditingController(text: widget.product.barcode);
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Change Bar Code'),
                          actions: [
                            TextField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: 'new bar code',
                                labelText: 'BarCode',
                              ),
                              keyboardType: TextInputType.number,
                              controller: _controller,
                              minLines: 1,
                              maxLines: 1,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    child: Text('Submit'),
                                    onPressed: () async {
                                      setState(() {
                                        widget.product.barcode = _controller.text;
                                      });
                                      await auth.updateCollectionFieldWithRef(
                                          ref: FirebaseFirestore.instance
                                              .collection('PHARMACY')
                                              .doc(auth.pharmacist.pharmacy.pharmacyId)
                                              .collection('MEDICINE')
                                              .doc(widget.product.id),
                                          fieldName: 'barCode',
                                          fieldValue: widget.product.barcode);
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          background),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          background),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price: ',
                  style: _textStyle,
                ),
                Text(
                  widget.product.price.toStringAsFixed(2) + ' JOD',
                  style: _textStyle1,
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    TextEditingController _controller = TextEditingController(
                        text: widget.product.price.toStringAsFixed(2));
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Change price'),
                        actions: [
                          TextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                            ],
                            decoration: InputDecoration(
                                hintText: 'Enter the new price',
                                labelText: 'New price',
                                suffixText: 'JOD'),
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  child: Text('Submit'),
                                  onPressed: () async {
                                    double price = double.tryParse(_controller.text);
                                    setState(() {
                                      widget.product.price = price;
                                    });
                                    await auth.updateCollectionFieldWithRef(
                                        ref: FirebaseFirestore.instance
                                            .collection('PHARMACY')
                                            .doc(auth.pharmacist.pharmacy.pharmacyId)
                                            .collection('MEDICINE')
                                            .doc(widget.product.id),
                                        fieldName: 'price',
                                        fieldValue: price);
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(background),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(background),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Prescription Required:',
                  style: _textStyle,
                ),
                Text(
                  widget.product.prescriptionRequired ? 'Yes' : 'No',
                  style: _textStyle1,
                ),
                Switch(
                  value: widget.product.prescriptionRequired,
                  onChanged: (value) async {
                    setState(() {
                      widget.product.prescriptionRequired = value;
                    });
                    await auth.updateCollectionFieldWithRef(
                        ref: FirebaseFirestore.instance
                            .collection('PHARMACY')
                            .doc(auth.pharmacist.pharmacy.pharmacyId)
                            .collection('MEDICINE')
                            .doc(widget.product.id),
                        fieldName: 'PrescriptionRequired',
                        fieldValue: widget.product.prescriptionRequired);
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      'Dosage - Pills',
                      style: _textStyle,
                    ),
                  ),
                  OrderIconButton(
                    iconData: Icons.add,
                    color: Colors.black,
                    press: () async {
                      FocusScope.of(context).unfocus();
                      int _pills = 0;
                      int _dosage = 0;
                      bool isCancel = false;
                      await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Dosage - pills'),
                            contentPadding: EdgeInsets.all(10.0),
                            content: Container(
                              padding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                              constraints: BoxConstraints(
                                maxHeight:
                                getProportionateScreenHeight(190),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height:
                                    getProportionateScreenHeight(5.0),
                                  ),
                                  Divider(color: Colors.black),
                                  SizedBox(
                                    height:
                                    getProportionateScreenHeight(10.0),
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        _dosage = int.tryParse(value);
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Dosage',
                                      hintText: 'Dosage',
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    getProportionateScreenHeight(10.0),
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        _pills = int.tryParse(value);
                                      });
                                    },
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Number of pills',
                                      hintText: 'Number of pills',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              Divider(color: Colors.black),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text('Submit'),
                                      onPressed: () {
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            Color(0xFF099F9D)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        isCancel = true;
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            Color(0xFF099F9D)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ));
                      if (!isCancel) {
                        if (widget.product.dosagePills.containsKey(_dosage)) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Dosage already exists.'),
                            duration: Duration(seconds: 5),
                          ));
                          return;
                        }
                        widget.product.dosagePills.addAll({_dosage: _pills});
                        Map<String, int> _map = {};
                        widget.product.dosagePills.forEach((key, value) {
                          _map.addAll({key.toString(): value});
                        });
                        await auth.updateCollectionFieldWithRef(
                            ref: FirebaseFirestore.instance
                                .collection('PHARMACY')
                                .doc(auth.pharmacist.pharmacy.pharmacyId)
                                .collection('MEDICINE')
                                .doc(widget.product.id),
                            fieldName: 'DosagePills',
                            fieldValue: _map);
                        orderDosagePills();
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              alignment: AlignmentDirectional.center,
              height: SizeConfig.screenHeight * 0.08,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.product.dosagePills.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: SizeConfig.screenWidth * 0.55,
                      child: DosagePillsButton(
                        press: (index) async {
                          if (widget.product.dosagePills.length > 1) {
                            setState(() {
                              widget.product.dosagePills.remove(widget
                                  .product.dosagePills.keys
                                  .elementAt(index));
                            });
                            Map<String, int> _map = {};
                            widget.product.dosagePills.forEach((key, value) {
                              _map.addAll({key.toString(): value});
                            });
                            await auth.updateCollectionFieldWithRef(
                                ref: FirebaseFirestore.instance
                                    .collection('PHARMACY')
                                    .doc(auth.pharmacist.pharmacy.pharmacyId)
                                    .collection('MEDICINE')
                                    .doc(widget.product.id),
                                fieldName: 'DosagePills',
                                fieldValue: _map);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Dosage Can not be empty!!'),
                              duration: Duration(seconds: 5),
                            ));
                          }
                        },
                        text:
                        '${widget.product.dosagePills.keys.elementAt(index).toString()} ${widget.product.dosageUnit} - ${widget.product.dosagePills.values.elementAt(index).toString()} ${widget.product.pillsUnit}',
                        index: index,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Description: ',
                      style: _textStyle,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        TextEditingController _controller =
                        TextEditingController(
                            text: widget.product.description);
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Change description'),
                            actions: [
                              Container(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Enter new description',
                                    labelText: 'Edit description',
                                  ),
                                  controller: _controller,
                                  maxLines: 10,
                                  minLines: 1,
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text('Submit'),
                                      onPressed: () {
                                        setState(() async {
                                          widget.product.description =
                                              _controller.text;
                                          await auth
                                              .updateCollectionFieldWithRef(
                                              ref: FirebaseFirestore
                                                  .instance
                                                  .collection('PHARMACY')
                                                  .doc(
                                                  auth
                                                      .pharmacist
                                                      .pharmacy
                                                      .pharmacyId)
                                                  .collection('MEDICINE')
                                                  .doc(widget.product.id),
                                              fieldName: 'description',
                                              fieldValue: widget
                                                  .product.description);
                                          Navigator.pop(context);
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            background),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            background),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  constraints: BoxConstraints(
                    minHeight: 50.0,
                    maxHeight: 150.0,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 2,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      widget.product.description != null &&
                          widget.product.description != ''
                          ? widget.product.description
                          : '',
                      style: TextStyle(fontSize: 17, color: Colors.grey[600]),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var answer = await showQuestionDialog(context: context, msgTitle: 'Delete Medicine',
                      msgText: ['Are your sure you want to delete medicine?'],
                      buttonText: '');
                  if ( answer == QuestionMessage.YES) {
                    await auth.removePharmacyMedicine(
                        medicineId: widget.product.id);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Delete'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
