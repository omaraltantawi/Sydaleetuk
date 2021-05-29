import 'package:flutter/material.dart';

class RequestScreen extends StatelessWidget {
  static const String routeName = 'RequestScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Medicines',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        backgroundColor: Color(0xFF42ADAC),
        leading: TextButton(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
                context); /////////////////////////////////////////////
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
            child: ListView(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medicine Name',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 25),
                          ),
                          Text(
                            'BarCode: 12345678',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 15),
                          ),
                          Text(
                            'Request by: EmployeeName',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 15),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {

                        },
                        child:Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder() ),
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                        ),
                      ),
                      TextButton(
                        onPressed: () {

                        },
                        child:Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder() ),
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medicine Name',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 25),
                          ),
                          Text(
                            'BarCode: 12345678',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 15),
                          ),
                          Text(
                            'Request by: EmployeeName',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 15),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {

                        },
                        child:Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder() ),
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                        ),
                      ),
                      TextButton(
                        onPressed: () {

                        },
                        child:Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder() ),
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medicine Name',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 25),
                          ),
                          Text(
                            'BarCode: 12345678',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 15),
                          ),
                          Text(
                            'Request by: EmployeeName',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 15),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {

                        },
                        child:Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder() ),
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                        ),
                      ),
                      TextButton(
                        onPressed: () {

                        },
                        child:Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder() ),
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medicine Name',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 25),
                          ),
                          Text(
                            'BarCode: 12345678',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 15),
                          ),
                          Text(
                            'Request by: EmployeeName',
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 15),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {

                        },
                        child:Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder() ),
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                        ),
                      ),
                      TextButton(
                        onPressed: () {

                        },
                        child:Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(CircleBorder() ),
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
    style: ElevatedButton.styleFrom(
    primary: Color(0xFF42ADAC)),
                      onPressed: () {},
                      child: Container(

                        padding: EdgeInsets.all(10.0),
                        child: Text('Cancel all'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF42ADAC)),
                      onPressed: () {},
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Accept all'),
                      ),
                    ),
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
