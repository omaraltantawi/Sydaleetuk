import 'dart:io';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/checkOutOrderScreen.dart';
import 'package:graduationproject/Screens/home/home_screen.dart';
import 'package:graduationproject/ServiceClasses/utilityClass.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/data_models/OrderClass.dart';
import 'package:graduationproject/data_models/Product.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/providers/ProductProvider.dart';
import 'package:graduationproject/size_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

enum NavOrderMenu { Dosage, Quantity }

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

class _BodyState extends State<Body> with CanShowMessages {
  Product selectedProduct;
  NavOrderMenu selectedMenu = NavOrderMenu.Dosage;
  int selectedDosageIndex = 0 , quantity = 1;
  @override
  void initState() {
    super.initState();
    setState(() {
      selectedProduct = widget.selectedProduct;
    });
    orderDosagePills();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   orderDosagePills();
    // });
  }

  orderDosagePills() {
    List<Map<int, int>> listData = [];
    selectedProduct.dosagePills
        .forEach((key, value) => listData.add({key: value}));
    print('before Sort ${selectedProduct.dosagePills}');
    listData.sort((a, b) => a.keys.first.compareTo(b.keys.first));
    // {
    //   int aValue = a.keys.first;
    //   int bValue = b.keys.first;
    //
    //   return aValue < bValue ;
    // });
    selectedProduct.dosagePills = Map.fromIterable(listData,
        key: (e) => e.keys.first, value: (e) => e.values.first);
    print('After Sort ${selectedProduct.dosagePills}');
  }

  initiate(ProductProvider provider) {
    provider.initiate();
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

  void showSnackBar({String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: 15),
    ));
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
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: SizeConfig.screenHeight * 0.20,
              child: widget.selectedProduct.imageUrls != null &&
                      widget.selectedProduct.imageUrls.length > 0
                  ? PageView.builder(
                      itemCount: widget.selectedProduct.imageUrls.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(45),
                          right: getProportionateScreenWidth(45),
                          top: getProportionateScreenHeight(15),
                          bottom: getProportionateScreenHeight(15),
                        ),
                        child: Image.network(
                          widget.selectedProduct.imageUrls[index],
                          alignment: AlignmentDirectional.center,
                          fit: BoxFit.fill,
                          height: getProportionateScreenHeight(120),
                        ),
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(45),
                          right: getProportionateScreenWidth(45),
                          top: getProportionateScreenHeight(10),
                          bottom: getProportionateScreenHeight(15),
                        ),
                        child: Image.asset(
                          "assets/images/syrup.png",
                          height: getProportionateScreenHeight(120),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: getProportionateScreenWidth(20),
                top: getProportionateScreenHeight(5),
                bottom: getProportionateScreenHeight(5),
              ),
              child: Text(
                widget.selectedProduct.name,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(22),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            if (selectedProduct.prescriptionRequired)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "(Prescription Required)",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(15),
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(15),
                  ),
                ],
              ),
            SizedBox(
              height: getProportionateScreenHeight(7.5),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: getProportionateScreenWidth(15)),
                  child: Text(
                    selectedProduct.price.toStringAsFixed(2) + "JOD",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(right: getProportionateScreenWidth(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OrderTextContainer(
                        text: selectedProduct.dosagePills.keys.length > 0
                            ? selectedProduct.dosagePills.keys
                                    .elementAt(selectedDosageIndex)
                                    .toString() +
                                selectedProduct.dosageUnit
                            : "",
                        backColor: kPrimaryColor,
                        fontColor: Colors.white,
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(10),
                      ),
                      Text(
                        selectedProduct.dosagePills.keys.length > 0
                            ? selectedProduct.dosagePills.values
                                    .elementAt(selectedDosageIndex)
                                    .toString() +
                                selectedProduct.pillsUnit
                            : "",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Divider(
            //     color: Colors.black.withOpacity(0.25),
            //     thickness: 1,
            //   ),
            // ),
            Container(
              padding: EdgeInsets.only(
                  left: 15.0, bottom: 5.0, right: 5.0, top: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Pharmacy : ',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(19),
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        '${widget.selectedProduct.pharmacy.name}',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(19),
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Distance : ',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(19),
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        '${((widget.selectedProduct.pharmacy.distance) / 1000.0).toStringAsFixed(2)} Km',
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(19),
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(3),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.call,
                          size: 30.0,
                          color: kPrimaryColor,
                        ),
                        onTap: () async {
                          print('Press');
                          bool cond = await Utility.makePhoneCall(
                              'tel:+962${widget.selectedProduct.pharmacy.phoneNo.substring(1)}');
                          if (!cond)
                            showSnackBar(
                                text:
                                    'Could not call +962${widget.selectedProduct.pharmacy.phoneNo.substring(1)}.');
                        },
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(15),
                      ),
                      InkWell(
                        child: Icon(
                          Icons.location_on,
                          size: 30.0,
                          color: kPrimaryColor,
                        ),
                        onTap: () async {
                          print('Press');
                          bool cond = await Utility.openMap(
                              widget
                                  .selectedProduct.pharmacy.addressGeo.latitude,
                              widget.selectedProduct.pharmacy.addressGeo
                                  .longitude);
                          if (!cond)
                            showSnackBar(text: 'Could not open the map.');
                        },
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
            //   child: Divider(
            //     color: Colors.black.withOpacity(0.25),
            //     thickness: 1,
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(
                left: getProportionateScreenWidth(20),
                top: getProportionateScreenHeight(5),
                bottom: getProportionateScreenHeight(1),
              ),
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(17),
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: new BoxConstraints(
                maxHeight: SizeConfig.screenHeight * 0.17,
                minHeight: selectedProduct.prescriptionRequired ? SizeConfig.screenHeight * 0.10 :SizeConfig.screenHeight * 0.13,
              ),
              child: Container(
                padding: EdgeInsets.only(
                  left: getProportionateScreenWidth(20),
                  right: getProportionateScreenWidth(15),
                  top: getProportionateScreenHeight(1),
                  bottom: getProportionateScreenHeight(5),
                ),
                child: Text(
                  selectedProduct.description,
                  softWrap: true,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedMenu = NavOrderMenu.Dosage;
                    });
                  },
                  child: Text(
                    'Select Dosage',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: selectedMenu == NavOrderMenu.Dosage
                          ? FontWeight.w700
                          : FontWeight.w300,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(15),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedMenu = NavOrderMenu.Quantity;
                    });
                  },
                  child: Text(
                    'Select Quantity',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: selectedMenu == NavOrderMenu.Quantity
                          ? FontWeight.w600
                          : FontWeight.w300,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            if ( selectedMenu == NavOrderMenu.Dosage )
              Container(
              width: double.infinity,
              alignment: AlignmentDirectional.center,
              height: SizeConfig.screenHeight * 0.08,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: selectedProduct.dosagePills.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: OrderTextContainer(
                      text: selectedProduct.dosagePills.keys
                          .elementAt(index)
                          .toString() +
                          selectedProduct.dosageUnit,
                      fontColor: index == selectedDosageIndex ? Colors.white : Colors.black,
                      backColor: index == selectedDosageIndex ? kPrimaryColor : Colors.transparent,
                      onPressed: (int){
                        setState(() {
                          selectedDosageIndex = index;
                        });
                      },
                      index: index,
                    ),
                  );
                },
              ),
            ),
            if ( selectedMenu == NavOrderMenu.Quantity)
              Container(
                width: double.infinity,
                alignment: AlignmentDirectional.center,
                height: SizeConfig.screenHeight * 0.08,
                child: ConstrainedBox(
                  constraints: new BoxConstraints(
                    maxWidth: SizeConfig.screenWidth*0.5,
                  ),
                  child: Container(
                    padding: EdgeInsets.only( bottom: 5.0, top: 5.0 , right: 8.0 , left: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (quantity > 1) {
                                quantity--;
                              }
                            });
                          },
                          child: Container(
                            // margin: EdgeInsets.all(5),
                            alignment: Alignment.centerLeft,
                            // width: double.infinity,
                            height: getProportionateScreenHeight(30),
                            color: Colors.transparent,
                            child: Icon(
                              Icons.remove,
                              size: 25.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Text(quantity.toString(),style: TextStyle(
                          fontSize: getProportionateScreenWidth(20),
                        ),),
                        InkWell(
                          onTap: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          child: Container(
                            // margin: EdgeInsets.all(5),
                            alignment: Alignment.centerLeft,
                            // width: double.infinity,
                            height: getProportionateScreenHeight(30),
                            color: Colors.transparent,
                            child: Icon(
                              Icons.add,
                              size: 25.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            Row(
              children: [
                Container(
                  color: kSecondaryColor.withOpacity(0.4),
                  height: getProportionateScreenHeight(60),
                  width: SizeConfig.screenWidth *0.5,
                  child: TextButton(
                    child: Text('ADD TO CART',style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                    ),),
                    onPressed: () async {
                      bool exists =
                      await Provider.of<FireBaseAuth>(context, listen: false)
                          .checkCartFromSamePharmacy(
                          pharmacyId: selectedProduct.pharmacy.pharmacyId);
                      print(exists);
                      if (exists) {
                        QuestionMessage answer = await showQuestionDialog(
                            context: context,
                            msgTitle: 'Order',
                            msgText: [
                              'Your cart contain product from different pharmacy. If you continue this will delete all existing products in your cart.',
                              'Do you want to continue ?'
                            ],
                            buttonText: '');
                        if (answer == QuestionMessage.CANCEL)
                          return;
                        else {
                          await Provider.of<FireBaseAuth>(context, listen: false)
                              .deleteAllProductsFromCart();
                        }
                      }
                      if (selectedProduct.prescriptionRequired) {
                        File file;
                        try {
                          final picker = ImagePicker();
                          await showMessageDialog(
                              context: this.context,
                              msgTitle: 'Prescription',
                              msgText: [
                                'Please select your Prescription.',
                              ],
                              buttonText: 'OK');
                          final pickedFile =
                          await picker.getImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            file = File(pickedFile.path);
                            print(pickedFile.path);
                          } else {
                            await showMessageDialog(
                                context: this.context,
                                msgTitle: 'Warning',
                                msgText: [
                                  'Prescription is required to make an order!!',
                                ],
                                buttonText: 'OK');
                            return;
                          }
                        } catch (e) {
                          await showMessageDialog(
                              context: this.context,
                              msgTitle: 'Warning',
                              msgText: ['Something went wrong', 'Please try again.'],
                              buttonText: 'OK');
                          return;
                        }
                        await Provider.of<FireBaseAuth>(context, listen: false)
                            .addToCart(
                            product: selectedProduct,
                            dosage: selectedProduct.dosagePills.keys.elementAt(selectedDosageIndex),
                            quantity: quantity,
                            prescription: file,
                            distance: selectedProduct.pharmacy.distance,
                            pills:
                            selectedProduct.dosagePills.values.elementAt(selectedDosageIndex),
                            dosageUnit: selectedProduct.dosageUnit,
                            pillsUnit: selectedProduct.pillsUnit);
                      } else {
                        await Provider.of<FireBaseAuth>(context, listen: false)
                            .addToCart(
                            product: selectedProduct,
                            dosage: selectedProduct.dosagePills.keys.elementAt(selectedDosageIndex),
                            quantity: quantity,
                            distance: selectedProduct.pharmacy.distance,
                            pills:
                            selectedProduct.dosagePills.values.elementAt(selectedDosageIndex),
                            dosageUnit: selectedProduct.dosageUnit,
                            pillsUnit: selectedProduct.pillsUnit);
                      }
                      await showMessageDialog(
                          context: this.context,
                          msgTitle: 'Order',
                          msgText: ['The product added successfully to your cart.'],
                          buttonText: 'OK');
                      // Navigator.pushReplacementNamed(
                      //     context, OrderSuccessScreen.routeName,
                      //     arguments:
                      //         Arguments(pharmacyName: selectedProduct.pharmacy.name));
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          HomeScreen.routeName, (Route<dynamic> route) => false);
                    },
                  ),
                ),
                Container(
                  width: SizeConfig.screenWidth *0.5,
                  height: getProportionateScreenHeight(60),
                  color: kPrimaryColor,
                  child: TextButton(
                    child: Text('ORDER NOW',style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                    ),),
                    onPressed: () async {
                      if (selectedProduct.prescriptionRequired) {
                        File file;
                        try {
                          final picker = ImagePicker();
                          await showMessageDialog(
                              context: this.context,
                              msgTitle: 'Prescription',
                              msgText: [
                                'Please select your Prescription.',
                              ],
                              buttonText: 'OK');
                          final pickedFile =
                          await picker.getImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            file = File(pickedFile.path);
                            print(pickedFile.path);
                          } else {
                            await showMessageDialog(
                                context: this.context,
                                msgTitle: 'Warning',
                                msgText: [
                                  'Prescription is required to make an order!!',
                                ],
                                buttonText: 'OK');
                            return;
                          }
                        } catch (e) {
                          await showMessageDialog(
                              context: this.context,
                              msgTitle: 'Warning',
                              msgText: ['Something went wrong', 'Please try again.'],
                              buttonText: 'OK');
                          return;
                        }
                        Order order = Order();
                        order.pharmacy = selectedProduct.pharmacy;
                        order.orderTime = DateTime.now();
                        Product product = selectedProduct;
                        product.selectedPills =
                            selectedProduct.dosagePills.values.elementAt(selectedDosageIndex);
                        product.selectedDosage =
                            selectedProduct.dosagePills.keys.elementAt(selectedDosageIndex);
                        product.quantity = quantity;
                        product.prescription = file;
                        order.products.add(product);
                        // await Provider.of<FireBaseAuth>(context, listen: false)
                        //     .orderProducts(orders: order);
                        Navigator.pushNamed(context, CheckOutOrdersScreen.routeName,
                            arguments: order);
                        // await Provider.of<FireBaseAuth>(context, listen: false)
                        //     .orderProduct(
                        //         product: selectedProduct,
                        //         dosage: selectedProduct.dosagePills.keys.elementAt(0),
                        //         quantity: 2,
                        //         prescription: file);
                      } else {
                        Order order = Order();
                        order.pharmacy = selectedProduct.pharmacy;
                        order.orderTime = DateTime.now();
                        Product product = selectedProduct;
                        product.selectedPills =
                            selectedProduct.dosagePills.values.elementAt(selectedDosageIndex);
                        product.selectedDosage =
                            selectedProduct.dosagePills.keys.elementAt(selectedDosageIndex);
                        product.quantity = quantity;
                        order.products.add(product);
                        Navigator.pushNamed(context, CheckOutOrdersScreen.routeName,
                            arguments: order);
                        // await Provider.of<FireBaseAuth>(context, listen: false)
                        //     .orderProducts(orders: order);
                        // await Provider.of<FireBaseAuth>(context, listen: false)
                        //     .orderProduct(
                        //     product: selectedProduct,
                        //     dosage: selectedProduct.dosagePills.keys.elementAt(0),
                        //     quantity: 2,);
                      }
                      // Navigator.pushReplacementNamed(
                      //     context, OrderSuccessScreen.routeName,
                      //     arguments:
                      //         Arguments(pharmacyName: selectedProduct.pharmacy.name));
                      // Navigator.of(context).pushNamedAndRemoveUntil(OrderSuccessScreen.routeName, (Route<dynamic> route) => false);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(3),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderTextContainer extends StatelessWidget {
  final Function(int) onPressed ;
  final int index ;
  final String text;
  final Color backColor, fontColor;
  const OrderTextContainer({Key key, this.text, this.backColor, this.fontColor , this.onPressed , this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.backColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      // padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
      child: TextButton(
        onPressed: onPressed != null ? (){
          onPressed(index);
        } : null,
        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: fontColor,
          ),
        ),
      ),
    );
  }
}

class OrderIconContainer extends StatelessWidget {
  final IconData iconData;
  final Color backColor, iconColor;
  const OrderIconContainer(
      {Key key, this.iconData, this.backColor, this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.backColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }
}
