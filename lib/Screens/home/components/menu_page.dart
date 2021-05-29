import 'package:flutter/material.dart';
import '../../../size_config.dart';

class Menu_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text("Products",style: TextStyle(
    fontSize: getProportionateScreenWidth(17),
    color: Colors.grey, ),
        ),),

           ListView(
             scrollDirection: Axis.vertical,
             shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 10.0),
              Container(

                  width: MediaQuery.of(context).size.width-390,
                  height: MediaQuery.of(context).size.height-260,
                  child: GridView.count(
                    crossAxisCount: 2,
                    primary: false,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 0.0,
                    childAspectRatio: 0.8,
                    children: <Widget>[
                      buildCard('Panadol', '3.99\JOD', 'assets/images/cream.png',true,
                           context),
                      buildCard('Tramadol', '3.99\JOD', 'assets/images/Tramadol.jpg',false,
                          context),
                      buildCard('Face Mask', '3.99\JOD', 'assets/images/gloves.jpg',true,
                          context),
                      buildCard('Face Mask', '3.99\JOD', 'assets/images/gloves.jpg',false,
                          context),
                      buildCard('Face Mask', '3.99\JOD', 'assets/images/gloves.jpg',true,
                          context),
                      buildCard('Face Mask', '3.99\JOD', 'assets/images/gloves.jpg',false,
                          context),
                      buildCard('Face Mask', '3.99\JOD', 'assets/images/gloves.jpg',true,
                          context),
                      buildCard('Teeth Brush', '3.99\JOD', 'assets/images/gloves.jpg',false,
                          context)


                    ],
                  )),

            ],
          ),

      ],
    );
  }

  Widget buildCard(String name, String price, String imgPath,bool prescription, context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.0, bottom:25.0, left: 10.0, right: 10.0),
        child: InkWell(
            onTap: () {//Navigator.of(context).push(
                //MaterialPageRoute(builder: (context) => medDetail(
                  //  assetPath: imgPath,
                    //medPrice:price,
                    //,edName: name)));
      },

            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3.0,
                          blurRadius: 5.0)
                    ],
                    color: Colors.white),
                child: Column(children: [

                  Hero(
                      tag: imgPath,
                      child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(imgPath),
                                  fit: BoxFit.contain)))),
                  SizedBox(height: 5.0),

                  Text(name,
                      style: TextStyle(
                          color: Color(0xFF575E67),
                          fontFamily: 'Muli',
                          fontSize: 20)),
                  Text(price,
                      style: TextStyle(
                          color: Color(0xFF48B3B2),
                          fontFamily: 'Muli',
                          fontSize: 20)),
                  Padding(
                      padding: EdgeInsets.only(right: 6.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            prescription
                                ? Text("(Prescription Required)")
                                : Text(""),

                          ])),


                ]))));
  }
}
