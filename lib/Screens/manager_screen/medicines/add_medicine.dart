import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduationproject/Screens/manager_screen/manager_screen.dart';
import 'package:graduationproject/Screens/manager_screen/medicines/medicine_list.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/components/orderButton.dart';
///////////////////////////delete comment down ///////////////////////////////
// import 'package:graduationproject/components/orderButton.dart';
///////////////////////////delete comment up ///////////////////////////////
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class AddMedicine extends StatelessWidget {
  static const String routeName = 'AddMedicine';
  const AddMedicine({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String barCode = ModalRoute.of(context).settings.arguments as String;
    return Body(barCode: barCode);
  }
}

class Body extends StatefulWidget {
  final String barCode;
  Body({this.barCode});
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> with CanShowMessages {
  List<File> image = [];
  String medicineName;
  String barCode;
  String price;
  bool prescription = false;
  String pills;
  String description;

  User loggedInUser;
  Pharmacist phar;

  List<Asset> images = [];
  List<File> imagesFiles = [];

  Future<void> pickImage() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: false,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Sydaleetuk",
        ),
      );
      images = resultList;
      List<File> _imagesFiles = [];
      _imagesFiles = await getImageFilesFromAssets();
      setState(() {
        imagesFiles = _imagesFiles;
      });
    } on NoImagesSelectedException catch (e) {
      print(e);
      setState(() {
        images = [];
        imagesFiles = [];
      });
    } catch (e) {
      print(e);
      print(e.runtimeType);
      showMessageDialog(
          context: this.context,
          msgTitle: 'Warning',
          msgText: ['Something went wrong.', 'Please try again'],
          buttonText: 'OK');
    }
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();
    final tempDirectory = Directory.systemTemp;
    print(tempDirectory.path);
    final tempFile = File('${tempDirectory.path}/${asset.name}');
    print(tempFile.path);
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    return file;
  }

  Future<List<File>> getImageFilesFromAssets() async {
    List<File> files = [];
    for (var value in images) {
      files.add(await getImageFileFromAssets(value));
    }
    return files;
  }

  @override
  void initState() {
    super.initState();

    getPharmacist();
    orderDosagePills();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      addBarcode();
    });
  }

  addBarcode(){
    barcodeController.text = widget.barCode == null || widget.barCode == '' ? '' : widget.barCode ;
  }

  Future<void> getPharmacist() async {
    Pharmacist p =
        await Provider.of<FireBaseAuth>(context, listen: false).currentUser;
    setState(() {
      phar = p;
    });
  }

  Map<int, int> dosagePills = {};
  String dosageUnit='mg', pillsUnit='pills';
  orderDosagePills() {
    List<Map<int, int>> listData = [];
    dosagePills
        .forEach((key, value) => listData.add({key: value}));
    print('before Sort $dosagePills');
    listData.sort((a, b) => a.keys.first.compareTo(b.keys.first));
    setState(() {
      dosagePills = Map.fromIterable(listData,
          key: (e) => e.keys.first, value: (e) => e.values.first);
    });
    print('After Sort $dosagePills');
  }

  final _formKey = GlobalKey<FormState>();
  bool isDosageValid = true ;
  bool isLoading = false ;
  var barcodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    loggedInUser = Provider.of<FireBaseAuth>(context, listen: false).loggedUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Medicine',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF42adac),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: getProportionateScreenHeight(200),
                  child: imagesFiles != null && imagesFiles.length > 0
                      ? Stack(
                          children: [
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.90,
                              height: SizeConfig.screenHeight * 0.20,
                              child: PageView.builder(
                                itemCount: imagesFiles.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.only(
                                    left: getProportionateScreenWidth(45),
                                    right: getProportionateScreenWidth(45),
                                    top: getProportionateScreenHeight(15),
                                    bottom: getProportionateScreenHeight(15),
                                  ),
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: new FileImage(imagesFiles[index]),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  // Image.file(
                                  //     imagesFiles[index],
                                  //     alignment: AlignmentDirectional.center,
                                  //     // fit: BoxFit.fill,
                                  //     height: getProportionateScreenHeight(120),
                                  // ),
                                  // Image.network(
                                  //   widget.selectedProduct.imageUrls[index],
                                  //   alignment: AlignmentDirectional.center,
                                  //   fit: BoxFit.fill,
                                  //   height: getProportionateScreenHeight(120),
                                  // ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                onPressed: () async {
                                  await pickImage();
                                },
                                icon: Icon(Icons.add_a_photo),
                              ),
                            )
                          ],
                        )
                      : SizedBox(
                          height: SizeConfig.screenHeight * 0.20,
                          width: SizeConfig.screenWidth * 0.84,
                          child: Container(
                            height: SizeConfig.screenHeight * 0.20,
                            width: SizeConfig.screenWidth * 0.90,
                            constraints: BoxConstraints(
                              minHeight: SizeConfig.screenHeight * 0.20,
                              maxHeight: SizeConfig.screenHeight * 0.20,
                            ),
                            child: InkWell(
                              onTap: () async {
                                await pickImage();
                              },
                              child: Center(
                                child: Text('Click me + to add a medicine images'),
                              ),
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      medicineName = value;
                    });
                  },
                  validator: (value){
                    if ( value == null || value == '' ){
                      return 'Enter a valid Medicine Name';
                    }
                    return null ;
                  },
                  decoration: InputDecoration(
                    labelText: 'Medicine Name',
                    hintText: 'Enter medicine name',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: barcodeController,
                  onSaved:(value)=> barCode = value ,
                  onChanged: (value) {
                    setState(() {
                      barCode = value;
                    });
                  },
                  validator: (value){
                    int val = int.tryParse(value);
                    if ( val == null ||  val < 0 ){
                      return 'Enter a valid Bar code.';
                    }
                    return null ;
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Bar code',
                    hintText: 'Enter the Bar code',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      price = value;
                    });
                  },
                  validator: (value){
                    double val = double.tryParse(value);
                    if ( val == null ||  val < 0 ){
                      return 'Enter a valid price';
                    }
                    return null ;
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: 'Enter the price',
                    suffixText: 'JOD',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      prescription = !prescription;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.7),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Prescription ?',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              prescription?'Yes':'No',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: prescription,
                          onChanged: (value) {
                            setState(() {
                              prescription = value;
                            });
                          },
                          activeTrackColor: Color(0xFF42adac),
                          activeColor: Color(0xFF42bbbb),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                  maxLines: 5,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Medicine Description',
                    hintText: 'Description',
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Dosage - Pills',
                          style: textBodyStyle,
                        ),
                      ),
                      OrderIconButton(
                        iconData: Icons.add,
                        press: () async {
                          FocusScope.of(context).unfocus();
                          int _pills = 0 ; 
                          int _dosage = 0 ;
                          bool isCancel = false ;
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
                                        height:getProportionateScreenHeight(5.0),
                                      ),
                                      Divider(color: Colors.black),
                                      SizedBox(
                                        height:getProportionateScreenHeight(10.0),
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
                                        height:getProportionateScreenHeight(10.0),
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
                                            isCancel= true;
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
                          if ( !isCancel ){
                            if ( dosagePills.containsKey(_dosage) ){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Dosage already exists.'),
                                duration: Duration(seconds: 5),
                              ));
                              return ;
                            }
                            dosagePills.addAll({_dosage:_pills});
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
                    itemCount: dosagePills.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: SizeConfig.screenWidth * 0.70,
                          child: DosagePillsButton(
                            press: (index) {
                              setState(() {
                                dosagePills.remove(dosagePills.keys.elementAt(index));
                              });
                              print(index);
                            },
                            text:
                                '${dosagePills.keys.elementAt(index).toString()} $dosageUnit - ${dosagePills.values.elementAt(index).toString()} $pillsUnit',
                            index: index,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if ( !isDosageValid )
                  Container(
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsets.only(left: getProportionateScreenWidth(30)),
                  child: Text(
                    'Enter at least one dosage.',
                    style: TextStyle(
                      color: Colors.red
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if ( !isLoading )
                  Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Expanded(
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       Navigator.pop(context);
                      //     },
                      //     child: Text('Cancel'),
                      //   ),
                      // ),
                      Expanded(
                        child: DefaultButton(
                          text: 'Cancel',
                          press: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: DefaultButton(
                          text: 'Submit',
                          press: () async {
                            FocusScope.of(context).unfocus();
                            if ( dosagePills.length == 0 ){
                              setState(() {
                                isDosageValid = false;
                              });
                            }else{
                              setState(() {
                                isDosageValid = true;
                              });
                            }
                            if ( _formKey.currentState.validate() ) {
                              _formKey.currentState.save();
                              bool cond = await Provider.of<FireBaseAuth>(
                                  context,
                                  listen: false)
                                  .checkPharmacyMedicineExistence(medicineName: medicineName);
                              print(cond);
                              if ( !cond ) {
                                setState(() {
                                  isLoading = true ;
                                });
                                bool off = await Provider.of<FireBaseAuth>(
                                    context,
                                    listen: false)
                                    .checkMedicineExistence(
                                    medicineName: medicineName);
                                print(off);
                                Map<String, int> _map = {};
                                dosagePills.forEach((key, value) {
                                  _map.addAll({key.toString(): value});
                                });
                                if (off) {
                                  QuestionMessage answer = await showQuestionDialog(
                                      context: context,
                                      msgTitle: 'Add Medicine',
                                      msgText: [
                                        'Medicine is already exist in our Official Medicines.',
                                        'Do you want to add it with official data?'
                                      ],
                                      buttonText: '');
                                  if (answer == QuestionMessage.YES) {
                                    await Provider.of<FireBaseAuth>(
                                        context, listen: false)
                                        .addMedicineToPharmacyFromOfficial(
                                        medicineName: medicineName);
                                    setState(() {
                                      isLoading = false ;
                                    });
                                    await showMessageDialog(context: context, msgTitle: 'Add Medicine', msgText: ['Medicine added successfully to your pharmacy.'], buttonText: 'OK');
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      MedicineList.routeName,
                                      ModalRoute.withName(ManagerScreen.routeName),
                                    );
                                  } else {
                                    double _price = 0;
                                    _price = double.tryParse(price);
                                    // image = await getImageFilesFromAssets();
                                    print(_map);
                                    await Provider.of<FireBaseAuth>(
                                        context, listen: false)
                                        .addMedicineToPharmacy(
                                      medicineName: medicineName,
                                      prescription: prescription,
                                      barCode: barCode,
                                      description: description,
                                      image: imagesFiles,
                                      price: _price,
                                      dosagePills: _map,
                                      dosageUnit: dosageUnit,
                                      pillsUnit: pillsUnit,
                                    );
                                    setState(() {
                                      isLoading = false ;
                                    });
                                    await showMessageDialog(context: context, msgTitle: 'Add Medicine', msgText: ['Medicine added successfully to your pharmacy.'], buttonText: 'OK');
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      MedicineList.routeName,
                                      ModalRoute.withName(ManagerScreen.routeName),
                                    );
                                  }
                                } else {
                                  double _price = 0;
                                  _price = double.tryParse(price);
                                  await Provider.of<FireBaseAuth>(context,
                                      listen: false)
                                      .addMedicineToPharmacyAndOfficial(
                                      medicineName: medicineName,
                                      prescription: prescription,
                                      barCode: barCode,
                                      description: description,
                                      image: imagesFiles,
                                      price: _price,
                                      dosagePills: _map,
                                      dosageUnit: dosageUnit,
                                      pillsUnit: pillsUnit
                                  );
                                  setState(() {
                                    isLoading = false ;
                                  });
                                  await showMessageDialog(context: context, msgTitle: 'Add Medicine', msgText: ['Medicine added successfully to your pharmacy.'], buttonText: 'OK');
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    MedicineList.routeName,
                                    ModalRoute.withName(ManagerScreen.routeName),
                                  );
                                }
                              }else{
                                await showMessageDialog(context: context, msgTitle: 'Warning', msgText: ['Medicine already exists in your pharmacy.'], buttonText: 'OK');
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if ( isLoading )
                  SpinKitDoubleBounce(
                    color: kPrimaryColor,
                    size: SizeConfig.screenWidth * 0.15,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DosagePillsButton extends StatelessWidget {
  const DosagePillsButton(
      {Key key,
      this.text,
      this.press,
      this.index,
      this.width = double.infinity,
      this.height = 50,
      this.isRed = false})
      : super(key: key);
  final String text;
  final Function(int) press;
  final double width, height;
  final bool isRed;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      margin: EdgeInsets.all(3),
      alignment: Alignment.center,
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(8.0)),
        gradient: !isRed
            ? kPrimaryGradientColor
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red[900],
                  Colors.red[900],
                  kPrimaryColor,
                ],
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              color: Colors.white,
            ),
          ),
          InkWell(
            onTap: ()=>press(index),
            child: Container(
              alignment: Alignment.centerRight,
              height: getProportionateScreenHeight(56),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.remove_circle_outline,
                    size: getProportionateScreenWidth(25.0),
                    color: Colors.red,
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
