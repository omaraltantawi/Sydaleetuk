import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/data_models/Pharmacist.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
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
  bool prescription;
  String pills;
  String description;

  User loggedInUser;
  Pharmacist phar;


  List<Asset> images = [];
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
      setState(() {
        images = resultList;
      });
    }on NoImagesSelectedException catch (e){
      print(e);
      setState(() {
        images = [];
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
        child: ListView(
          children: [
            InkWell(
              onTap: () async {
                await pickImage();
              },
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 150,
                ),
                width: double.infinity,
                child: Center(
                  child: Text('Click me + to add a medicine'),
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
            // Container(
            //   child:
            //     ListView.builder(itemBuilder: (context,index){
            //
            //     })
            // ),
            // Container(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        bool off = await Provider.of<FireBaseAuth>(context,
                                listen: false)
                            .checkMedicineExistence(medicineName: medicineName);
                        print ( off );
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
                            image = await getImageFilesFromAssets();
                            Provider.of<FireBaseAuth>(context, listen: false)
                                .addMedicineToPharmacy(
                                    medicineName: medicineName,
                                    prescription: prescription == 'True',
                                    barCode: barCode,
                                    description: description,
                                    image: image,
                                    price: _price,
                                    dosagePills: {});
                          }
                        } else {
                          double _price = 0;
                          _price = double.tryParse(price);
                          image = await getImageFilesFromAssets();
                          print ( 'getfiles' );
                          await Provider.of<FireBaseAuth>(context, listen: false)
                              .addMedicineToPharmacyAndOfficial(
                              medicineName: medicineName,
                              prescription: prescription == 'True',
                              barCode: barCode,
                              description: description,
                              image: image,
                              price: _price,
                              dosagePills: {});
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
