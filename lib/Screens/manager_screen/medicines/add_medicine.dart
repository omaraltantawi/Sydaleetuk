import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/components/orderButton.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';


class AddMedicine extends StatefulWidget {
  static const String routeName = 'AddMedicine';

  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> with CanShowMessages {

  
  List<File> image = [];
  String medicineName;
  String barCode;
  String price;
  bool prescription = true;
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
      List<File> _imagesFiles = [];
      _imagesFiles = await getImageFilesFromAssets();
      setState(() {
        images = resultList;
        imagesFiles = _imagesFiles;
      });
    }on NoImagesSelectedException catch (e){
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
  }

  Future<void> getPharmacist() async {
    Pharmacist p =
        await Provider.of<FireBaseAuth>(context, listen: false).currentUser;
    setState(() {
      phar = p;
    });
  }

  Map<int,int> dosagePills ={10:10,20:20,30:30};
  String dosageUnit , pillsUnit ;

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
          child: Column(
            children: [
              imagesFiles != null && imagesFiles.length > 0 ?
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
                          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
                          image: new FileImage(imagesFiles[index]),
                          fit: BoxFit.fill,
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
              ):
              SizedBox(
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
                      child: Text('Click me + to add a medicine'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    medicineName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                  hintText: 'Enter medicine name',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    barCode = value;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'bar code',
                  hintText: 'bar code',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    price = value;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: '3.5',
                  suffixText: 'JOD',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    prescription=!prescription;
                  });
                },
                child: Container(

                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey,width: 1.7),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Need prescription? ',style: TextStyle(
                        fontSize: 20,
                      ),
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
              TextField(
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
                      press: (){

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
                        width: SizeConfig.screenWidth*0.55,
                        child: DosagePillsButton(
                          press: (index){

                          },
                          text: '${dosagePills.keys.elementAt(index).toString()} $dosageUnit - ${dosagePills.values.elementAt(index).toString()} $pillsUnit',
                          index: index,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
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
                    // Expanded(
                    //   child: ElevatedButton(
                    //     onPressed: () async {
                    //       bool off = await Provider.of<FireBaseAuth>(context,
                    //               listen: false)
                    //           .checkMedicineExistence(medicineName: medicineName);
                    //       print ( off );
                    //       if (off) {
                    //         QuestionMessage answer = await showQuestionDialog(
                    //             context: context,
                    //             msgTitle: 'Add Medicine',
                    //             msgText: [
                    //               'Medicine is already exist in our Official Medicines.',
                    //               'Do you want to add it with official data?'
                    //             ],
                    //             buttonText: '');
                    //         if (answer == QuestionMessage.YES) {
                    //           Provider.of<FireBaseAuth>(context, listen: false)
                    //               .addMedicineToPharmacyFromOfficial(
                    //                   medicineName: medicineName);
                    //         } else {
                    //           double _price = 0;
                    //           _price = double.tryParse(price);
                    //           image = await getImageFilesFromAssets();
                    //           Provider.of<FireBaseAuth>(context, listen: false)
                    //               .addMedicineToPharmacy(
                    //                   medicineName: medicineName,
                    //                   prescription: prescription == 'True',
                    //                   barCode: barCode,
                    //                   description: description,
                    //                   image: image,
                    //                   price: _price,
                    //                   dosagePills: {});
                    //         }
                    //       } else {
                    //         double _price = 0;
                    //         _price = double.tryParse(price);
                    //         image = await getImageFilesFromAssets();
                    //         print ( 'getfiles' );
                    //         await Provider.of<FireBaseAuth>(context, listen: false)
                    //             .addMedicineToPharmacyAndOfficial(
                    //             medicineName: medicineName,
                    //             prescription: prescription == 'True',
                    //             barCode: barCode,
                    //             description: description,
                    //             image: image,
                    //             price: _price,
                    //             dosagePills: {});
                    //       }
                    //     },
                    //     child: Text('Submit'),
                    //   ),
                    // ),
                    Expanded(
                      child: DefaultButton(
                        text: 'Submit',
                        press: () async {
                          bool off = await Provider.of<FireBaseAuth>(context,
                              listen: false)
                              .checkMedicineExistence(medicineName: medicineName);
                          print ( off );
                          Map<String,int> _map = {};
                          dosagePills.forEach((key, value) {
                            _map.addAll({key.toString():value});
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
                              Provider.of<FireBaseAuth>(context, listen: false)
                                  .addMedicineToPharmacyFromOfficial(
                                  medicineName: medicineName);
                            } else {
                              double _price = 0;
                              _price = double.tryParse(price);
                              // image = await getImageFilesFromAssets();

                              Provider.of<FireBaseAuth>(context, listen: false)
                                  .addMedicineToPharmacy(
                                  medicineName: medicineName,
                                  prescription: prescription,
                                  barCode: barCode,
                                  description: description,
                                  image: image,
                                  price: _price,
                                  dosagePills: _map,dosageUnit: dosageUnit,pillsUnit: pillsUnit);
                            }
                          } else {
                            double _price = 0;
                            _price = double.tryParse(price);
                            // image = await getImageFilesFromAssets();
                            print ( 'getfiles' );
                            await Provider.of<FireBaseAuth>(context, listen: false)
                                .addMedicineToPharmacyAndOfficial(
                                medicineName: medicineName,
                                prescription: prescription,
                                barCode: barCode,
                                description: description,
                                image: image,
                                price: _price,
                                dosagePills: _map,dosageUnit: dosageUnit,pillsUnit: pillsUnit);
                          }
                        },
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
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      margin: EdgeInsets.all(3),
      alignment: Alignment.center,
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(8.0)),
        gradient: !isRed ? kPrimaryGradientColor : LinearGradient(
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
            onTap: press(index),
            child: Container(
              alignment: Alignment.centerRight,
              height: getProportionateScreenHeight(56),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.remove_circle_outline, size: getProportionateScreenWidth(25.0),color: Colors.red ,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
