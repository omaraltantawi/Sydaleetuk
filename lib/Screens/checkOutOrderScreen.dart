import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/home/home_screen.dart';
import 'package:graduationproject/Screens/order_success/components/arguments.dart';
import 'package:graduationproject/Screens/order_success/order_success_screen.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/data_models/OrderClass.dart';
import 'package:graduationproject/data_models/Patient.dart';
import 'package:graduationproject/data_models/Product.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';

class CheckOutOrdersScreen extends StatelessWidget {
  static String routeName = "/check_out_orders";
  const CheckOutOrdersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Order order = ModalRoute.of(context).settings.arguments as Order;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Order from ',
            ),
            Text(
              '${order.pharmacy.name}',
              style: textBodyStyle,
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 40.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Checkout', style: headingStyle),
              ],
            ),
          ),
        ),
      ),
      body: Body(
        order: order,
      ),
    );
  }
}

class Body extends StatefulWidget {
  final Order order;
  Body({Key key, this.order}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with CanShowMessages {
  List<Widget> widgets = [];
  Patient patient;
  bool isInitiate = false;

  changeProductQuantity(int index, int quantity) async {
    double tPrice = 0;
    widget.order.products[index].quantity = quantity;
    if ( widget.order.isFromCart ){
      await Provider.of<FireBaseAuth>(context, listen: false)
          .updateProductQuantityFromCart(quantity: widget.order.products[index].quantity , productNo: widget.order.products[index].productNo);
    }
    // for (int i = 0; i < widget.order.products.length; i++) {
    //   tPrice += (widget.order.products[i].price * widget.order.products[i].quantity);
    // }
    // setState(() {
    //   totalPrice = tPrice;
    // });
    getBody();
  }

  deleteProduct(int i) async {
    if (widget.order.products.length - 1 == 0) {
      QuestionMessage answer = await showQuestionDialog(
          context: context,
          msgTitle: 'Order',
          msgText: [
            'If you delete this product, your order will be removed',
            'Do you want to continue ?'
          ],
          buttonText: '');
      if (answer == QuestionMessage.YES) {
        if ( widget.order.isFromCart )
        await Provider.of<FireBaseAuth>(context, listen: false)
            .deleteAllProductsFromCart();
        Navigator.pop(context);
      } else {
        return;
      }
    }
    getBody();
    print(i);
    print(widget.order.products.length);
    widget.order.products.removeAt(i);
  }

  List<Widget> getBody() {
    List<Widget> widgetsTemp = [];
    double totalPrice = 0;
    for (int i = 0; i < widget.order.products.length; i++) {
      totalPrice +=
          (widget.order.products[i].price * widget.order.products[i].quantity);
      widgetsTemp.add(
        CheckOutProductWidget(
          product: widget.order.products[i],
          index: i,
          deleteFunction: deleteProduct,
          changeQuantity: changeProductQuantity,
        ),
      );
      widgetsTemp.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(
            color: Colors.black.withOpacity(0.25),
            thickness: 1,
          ),
        ),
      );
    }
    widgetsTemp.add(
      SizedBox(
        height: getProportionateScreenHeight(20),
      ),
    );
    widgetsTemp.add(
      Text('${patient.address}', style: textHeadStyleBlack),
    );
    widgetsTemp.add(
      Text('Phone Number ${patient.phoneNo}', style: textHeadStyleBlack),
    );
    widgetsTemp.add(
      SizedBox(
        height: getProportionateScreenHeight(20),
      ),
    );
    widgetsTemp.add(
      Text('Total Price ${totalPrice.toStringAsFixed(2)} JOD', style: textHeadStyle),
    );
    widgetsTemp.add(
      SizedBox(
        height: getProportionateScreenHeight(15),
      ),
    );
    widgetsTemp.add(
      DefaultButton(
        press: () async {
          print('pressed');
          if (!widget.order.isFromCart)
            await Provider.of<FireBaseAuth>(context, listen: false)
                .orderProducts(orders: widget.order);
          else
            await Provider.of<FireBaseAuth>(context, listen: false)
                .orderProductsFromCart(orders: widget.order);
          Navigator.pushNamedAndRemoveUntil(
              context,
              OrderSuccessScreen.routeName,
              ModalRoute.withName(HomeScreen.routeName),
              arguments: Arguments(pharmacyName: widget.order.pharmacy.name));
        },
        text: 'Place Order',
      ),
    );
    widgetsTemp.add(
      SizedBox(
        height: getProportionateScreenHeight(15),
      ),
    );
    setState(() {
      widgets = widgetsTemp;
    });
    return widgetsTemp;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBody();
    });
  }

  @override
  Widget build(BuildContext context) {
    patient = Provider.of<FireBaseAuth>(context, listen: true).patient;
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(
          10.0,
        ),
        children: widgets,
      ),
    );
  }
}

class CheckOutProductWidget extends StatefulWidget {
  final Function(int index, int product) changeQuantity;
  final Function(int product) deleteFunction;
  final Product product;
  final int index;
  const CheckOutProductWidget(
      {Key key,
      this.product,
      this.index,
      this.deleteFunction,
      this.changeQuantity})
      : super(key: key);

  @override
  _CheckOutProductWidgetState createState() => _CheckOutProductWidgetState();
}

class _CheckOutProductWidgetState extends State<CheckOutProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      type: MaterialType.canvas,
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Container(
          padding:
          EdgeInsets.all(7.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          width: SizeConfig.screenWidth * 0.90,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              widget.product.imageUrls != null &&
                      widget.product.imageUrls.length > 0 &&
                      widget.product.imageUrls[0] != ''
                  ? Image.network(
                      widget.product.imageUrls[0],
                      height: getProportionateScreenHeight(90),
                      width: getProportionateScreenWidth(75),
                    )
                  : Image.asset(
                      "assets/images/syrup.png",
                      height: getProportionateScreenHeight(90),
                      width: getProportionateScreenWidth(75),
                    ),
              Padding(
                padding: EdgeInsets.only(left: getProportionateScreenWidth(85)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700),
                        ),
                        InkWell(
                          onTap: () {
                            print(widget.index);
                            widget.deleteFunction(widget.index);
                          },
                          child: Container(
                            // margin: EdgeInsets.all(5),
                            alignment: Alignment.centerRight,
                            // width: double.infinity,
                            height: getProportionateScreenHeight(30),
                            color: Colors.transparent,
                            child: Icon(
                              Icons.cancel_outlined,
                              size: 25.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(5),
                    ),
                    Text(
                      '${widget.product.selectedPills} ${widget.product.pillsUnit} - ${widget.product.selectedDosage} ${widget.product.dosageUnit}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w200),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(5),
                    ),
                    Text(
                      widget.product.price.toString() + " JOD",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(8),
                    ),
                    // Row(
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         setState(() {
                    //           print(widget.product.quantity);
                    //           if (widget.product.quantity > 1) {
                    //             widget.product.quantity--;
                    //             widget.changeQuantity(
                    //                 widget.index, widget.product.quantity);
                    //             print('decrease');
                    //           } else {
                    //             //Call Remove Product.
                    //             print('remove');
                    //             widget.deleteFunction(widget.index);
                    //           }
                    //         });
                    //       },
                    //       child: Container(
                    //         // margin: EdgeInsets.all(5),
                    //         alignment: Alignment.centerLeft,
                    //         // width: double.infinity,
                    //         height: getProportionateScreenHeight(30),
                    //         color: Colors.transparent,
                    //         child: Icon(
                    //           Icons.remove,
                    //           size: 25.0,
                    //           color: Colors.black54,
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: getProportionateScreenWidth(30),
                    //     ),
                    //     Text('${widget.product.quantity}'),
                    //     SizedBox(
                    //       width: getProportionateScreenWidth(30),
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         setState(() {
                    //           widget.product.quantity++;
                    //           widget.changeQuantity(
                    //               widget.index, widget.product.quantity);
                    //         });
                    //       },
                    //       child: Container(
                    //         // margin: EdgeInsets.all(5),
                    //         alignment: Alignment.centerLeft,
                    //         // width: double.infinity,
                    //         height: getProportionateScreenHeight(30),
                    //         color: Colors.transparent,
                    //         child: Icon(
                    //           Icons.add,
                    //           size: 25.0,
                    //           color: Colors.black54,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    ConstrainedBox(
                      constraints: new BoxConstraints(
                        maxWidth: SizeConfig.screenWidth*0.39,
                      ),
                      child: Container(
                        padding: EdgeInsets.only( bottom: 5.0, top: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  print(widget.product.quantity);
                                  if (widget.product.quantity > 1) {
                                    widget.product.quantity--;
                                    widget.changeQuantity(
                                        widget.index, widget.product.quantity);
                                    print('decrease');
                                  } else {
                                    //Call Remove Product.
                                    print('remove');
                                    widget.deleteFunction(widget.index);
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
                            SizedBox(
                              width: getProportionateScreenWidth(30),
                            ),
                            Text('${widget.product.quantity}'),
                            SizedBox(
                              width: getProportionateScreenWidth(30),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  widget.product.quantity++;
                                  widget.changeQuantity(
                                      widget.index, widget.product.quantity);
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
