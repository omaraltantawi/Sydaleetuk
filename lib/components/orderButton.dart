import 'package:flutter/material.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/size_config.dart';
import 'package:intl/intl.dart';

class OrderButton extends StatelessWidget {
  const OrderButton(
      {Key key,
      this.text,
      this.press,
      this.width = double.infinity,
      this.height = 50,
      this.isRed = false})
      : super(key: key);
  final String text;
  final Function press;
  final double width, height;
  final bool isRed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        margin: EdgeInsets.all(5),
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
        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class OrderIconButton extends StatelessWidget {
  const OrderIconButton({Key key, this.press,this.iconData,this.text,this.color})
      : super(key: key);
  final Function press;
  final IconData iconData;
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        // margin: EdgeInsets.all(5),
        alignment: Alignment.centerLeft,
        // width: double.infinity,
        height: getProportionateScreenHeight(56),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(iconData, size: 30.0,color: color == null ? kPrimaryColor : color ,),
            if ( text != null && text != '' )
              Text(text,style: TextStyle(
                color: kPrimaryColor
              ),),
          ],
        ),
      ),
    );
  }
}
