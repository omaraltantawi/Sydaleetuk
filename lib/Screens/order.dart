import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/order_success/components/arguments.dart';
import 'package:graduationproject/Screens/order_success/order_success_screen.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/data_models/Product.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/providers/ProductProvider.dart';
import 'package:graduationproject/size_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class OrderProduct extends StatelessWidget {
  static String routeName = "/order_product";
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    productProvider.user = Provider.of<FireBaseAuth>(context).patient;
    final Product args = ModalRoute.of(context).settings.arguments as Product;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Order Product'),
      ),
      body: Body(
        selectedProduct: args,
      ),
    );
  }
}

class Body extends StatefulWidget {
  final Product selectedProduct;
  const Body({Key key, this.selectedProduct}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body>with CanShowMessages {
  Product selectedProduct;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedProduct = widget.selectedProduct;
    });
  }

  initiate(ProductProvider provider) {
    provider.initiate();
  }

  Widget getImages(List<String> imagesUrls, index) {
    if (imagesUrls != null &&
        imagesUrls.length > 0 &&
        index > 0 &&
        index < imagesUrls.length) {
      return Image.network(
        imagesUrls[index],
        height: getProportionateScreenHeight(100),
        width: getProportionateScreenWidth(100),
      );
    } else {
      return Image.asset(
        "assets/images/syrup.png",
        height: getProportionateScreenHeight(100),
        width: getProportionateScreenWidth(100),
      );
    }
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  List<Widget> getDots(List<String> imagesUrls) {
    List<Widget> widgets = [];
    widgets.add(
      SizedBox(
        width: getProportionateScreenWidth(75),
      ),
    );
    widgets.addAll(List.generate(
      imagesUrls.length > 0 ? imagesUrls.length : 1,
      (index) => buildDot(index: index),
    ));
    return widgets;
  }

  String getPrescriptionText(bool cond) {
    print('getPrescriptionText $cond');
    if (cond) return "( Prescription required )";
    return "";
  }
  
  Future<File> pickImage() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: [],
        materialOptions: MaterialOptions(
          actionBarTitle: "Sydaleetuk",
        ),
      );
      File file = await getImageFileFromAssets(resultList[0]);
      return file;
    } catch (e) {
      print('From Pick Image $e');
      return null;
    }
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    try {
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
    }catch(e){
      throw e;
    }
  }

  int currentPage = 0;
  int selectedDosage = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: ListView(
          children: <Widget>[
            // Container(
            //   child: PageView.builder(
            //
            //     onPageChanged: (value) {
            //       setState(() {
            //         currentPage = value;
            //       });
            //     },
            //     itemCount: selectedProduct.imageUrls.length > 0 ? selectedProduct.imageUrls.length : 1 ,
            //     itemBuilder: (context, index) => Column(
            //       children: <Widget>[
            //         SizedBox(
            //           height: getProportionateScreenHeight(10),
            //         ),
            //         getImages(selectedProduct.imageUrls, index),
            //         SizedBox(
            //           height: getProportionateScreenHeight(10),
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: getDots(selectedProduct.imageUrls),
            //         ),
            //         SizedBox(
            //           height: getProportionateScreenHeight(5),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     SizedBox(
            //       width: getProportionateScreenWidth(20),
            //     ),
            //     Text(selectedProduct.name + "  "+getPrescriptionText(selectedProduct.prescriptionRequired)),
            //   ],
            // ),
            getImages(selectedProduct.imageUrls, 0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(15),
                ),
                Text("Pharmacy :" + widget.selectedProduct.pharmacy.name),
                SizedBox(
                  width: getProportionateScreenWidth(15),
                ),
                Text(getPrescriptionText(selectedProduct.prescriptionRequired)),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(15),
                ),
                Text(selectedProduct.price.toString() + "JOD"),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                ),
                Text(selectedProduct.dosagePills.keys.length > 0
                    ? selectedProduct.dosagePills.keys
                            .elementAt(selectedDosage)
                            .toString() +
                        "mg"
                    : ""),
                SizedBox(
                  width: getProportionateScreenWidth(5),
                ),
                Text(selectedProduct.dosagePills.keys.length > 0
                    ? selectedProduct.dosagePills.values
                            .elementAt(selectedDosage)
                            .toString() +
                        "Pills"
                    : ""),
              ],
            ),

            TextButton(
              child: Text('Order Now'),
              onPressed: () async {
                if (selectedProduct.prescriptionRequired) {
                  File file;
                  try {
                    // file = await pickImage();
                    // if (file != null) {
                    //   print ('File picked');
                    //   return ;
                    // } else {
                    //   showMessageDialog(
                    //       context: this.context,
                    //       msgTitle: 'Warning',
                    //       msgText: [
                    //         'Prescription is required to make an order!!',
                    //       ],
                    //       buttonText: 'OK');
                    //   return;
                    // }
                    final picker = ImagePicker();
                    await showMessageDialog(
                        context: this.context,
                        msgTitle: 'Prescription',
                        msgText: [
                          'Please select your Prescription.',
                        ],
                        buttonText: 'OK');
                    final pickedFile = await picker.getImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      file = File(pickedFile.path);
                      print ( pickedFile.path );
                    } else {
                        showMessageDialog(
                            context: this.context,
                            msgTitle: 'Warning',
                            msgText: [
                              'Prescription is required to make an order!!',
                            ],
                            buttonText: 'OK');
                        return;
                    }
                  }catch(e){
                    showMessageDialog(
                        context: this.context,
                        msgTitle: 'Warning',
                        msgText: [
                          'Something went wrong','Please try again.'
                        ],
                        buttonText: 'OK');
                    return;
                  }
                  Provider.of<FireBaseAuth>(context, listen: false)
                      .orderProduct(
                          product: selectedProduct,
                          dosage: selectedProduct.dosagePills.keys.elementAt(0),
                          quantity: 2,
                          prescription: file);
                }else{
                  Provider.of<FireBaseAuth>(context, listen: false)
                      .orderProduct(
                      product: selectedProduct,
                      dosage: selectedProduct.dosagePills.keys.elementAt(0),
                      quantity: 2,);
                }
                Navigator.pushReplacementNamed(context, OrderSuccessScreen.routeName,arguments: Arguments(pharmacyName: selectedProduct.pharmacy.name));
                // Navigator.of(context).pushNamedAndRemoveUntil(OrderSuccessScreen.routeName, (Route<dynamic> route) => false);
              },
            ),
            // TextButton(onPressed: (){
            //   // final picker = ImagePicker();
            //   // final pickedFile = await picker.getImage(source: ImageSource.gallery);
            //   // File file = File(pickedFile.path);
            //   // print ( pickedFile.path );
            //   // Provider.of<FireBaseAuth>(context,listen: false).signUpPharmacyWithUser('pharmacy2@Sydaleetuk.com','Pharmacist','2','','Good',pharmacyName: 'Pharmacy 2',pharmacyPhoneNo: '0790000000',files: [file]);
            //   Provider.of<FireBaseAuth>(context,listen: false).addEmployeeUser('pharmacy@Sydaleetuk.com','emp@12345','Employee','1','','Good','JnLHedMrmjqmyso4Zfzc');
            //   // Provider.of<FireBaseAuth>(context,listen: false).signUpPharmacyWithUser('pharmacy@Sydaleetuk.com','Pharmacist','1','','Good',pharmacyName: 'Pharmacy 1',pharmacyPhoneNo: '0790000000',files: []);
            // }, child: Text('SignUp Pharmacy'))

          ],
        ),
      ),
    );
  }
}

class OrderProductBody extends StatelessWidget {
  const OrderProductBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
