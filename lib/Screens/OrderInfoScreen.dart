import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/ServiceClasses/utilityClass.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/data_models/OrderClass.dart';
import 'package:graduationproject/data_models/Patient.dart';
import 'package:graduationproject/data_models/Product.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/size_config.dart';
import 'package:provider/provider.dart';

class OrderInfoScreen extends StatelessWidget {
  static String routeName = "/order_info";
  const OrderInfoScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Order order = ModalRoute.of(context).settings.arguments as Order;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Order ${order.orderNo}',
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
  Patient patient;
  int numberOfProducts = 1 ;

  // Old variables
  Product selectedProduct;
  int selectedIndex;
  DismissDirection dismissDirection;

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.order.products[0];
    selectedIndex = 0;
    bool cond = false;
    if ( widget.order.products.length > 1 ) {
      dismissDirection = DismissDirection.endToStart;
      cond = true;
    }else
      dismissDirection = DismissDirection.none;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setProductsNo();
      if( cond )
        showSnackBar(text: 'Swipe Product to left or right to view all Products');
    });
  }

  void showSnackBar({String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: 15),
    ));
  }

  void setProductsNo (){
    int no = 0;
    for (var item in widget.order.products){
      no += item.quantity;
    }
    print(no);
    setState(() {
      numberOfProducts = no ;
    });
  }

  @override
  Widget build(BuildContext context) {
    patient = Provider.of<FireBaseAuth>(context, listen: true).patient;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            left: 12.0, top: 8.0, bottom: 8.0, right: 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pharmacy Info',
                style: textBodyStyle,
              ),
              SizedBox(
                height: getProportionateScreenHeight(6),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 10.0, bottom: 10.0, right: 5.0, top: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryColor, width: 2.5),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name : ${widget.order.pharmacy.name}',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(16),
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(7),
                    ),
                    Text(
                      'Phone Number : ${widget.order.pharmacy.phoneNo}',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(16),
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(7),
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
                                'tel:+962${widget.order.pharmacy.phoneNo.substring(1)}');
                            if ( !cond )
                              showSnackBar(text:'Could not call +962${widget.order.pharmacy.phoneNo.substring(1)}.');
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
                                widget.order.pharmacy.addressGeo.latitude,
                                widget.order.pharmacy.addressGeo.longitude);
                            if ( !cond )
                              showSnackBar(text:'Could not open the map.');
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
              SizedBox(
                height: getProportionateScreenHeight(7.5),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Divider(
                  color: Colors.black.withOpacity(0.25),
                  thickness: 1,
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(7.5),
              ),
              Text(
                'Products',
                style: textBodyStyle,
              ),
              SizedBox(
                height: getProportionateScreenHeight(6),
              ),
              Container(
                height: SizeConfig.screenHeight * 0.38,
                child: PageView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (context, index) => OrderInfoProductWidget(
                      product: widget.order.products[index],
                    ),
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(7.5),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Divider(
                  color: Colors.black.withOpacity(0.25),
                  thickness: 1,
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(7.5),
              ),
              Text(
                'Payment Summary',
                style: textBodyStyle,
              ),
              SizedBox(
                height: getProportionateScreenHeight(6),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 10.0, bottom: 10.0, right: 5.0, top: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryColor, width: 2.5),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Number of products : $numberOfProducts',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(16),
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(7),
                    ),
                    Text(
                      'Total Price : '+(widget.order.totalPrice).toStringAsFixed(2)+' JOD',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(16),
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        height: 1.5,
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

class OrderInfoProductWidget extends StatefulWidget {
  final Product product;
  final int index;
  const OrderInfoProductWidget({
    Key key,
    this.product,
    this.index,
  }) : super(key: key);

  @override
  _OrderInfoProductWidgetState createState() => _OrderInfoProductWidgetState();
}

class _OrderInfoProductWidgetState extends State<OrderInfoProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      type: MaterialType.canvas,
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Container(
          padding:EdgeInsets.all(12),
              // EdgeInsets.only(left: 10.0, bottom: 10.0, right: 5.0, top: 10.0),
          decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor, width: 2.5),
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.product.imageUrls != null &&
                      widget.product.imageUrls.length > 0 &&
                      widget.product.imageUrls[0] != ''
                      ? Image.network(
                    widget.product.imageUrls[0],
                    height: getProportionateScreenHeight(120),
                  )
                      : Image.asset(
                    "assets/images/syrup.png",
                    height: getProportionateScreenHeight(120),
                  ),
                ],
              ),
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              Text(
                'Name : '+widget.product.name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: getProportionateScreenHeight(5),
              ),
              Text(
                '${widget.product.selectedPills} ${widget.product.pillsUnit} - ${widget.product.selectedDosage} ${widget.product.dosageUnit}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: getProportionateScreenHeight(5),
              ),
              Text(
                'Price : '+widget.product.price.toString() + " JOD",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: getProportionateScreenHeight(8),
              ),
              Text(
                'Quantity : '+widget.product.quantity.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
