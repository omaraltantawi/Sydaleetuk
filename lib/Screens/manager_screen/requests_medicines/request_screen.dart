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
        backgroundColor: Color(0xFF42adac),
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
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
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
                            'BarCode',
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
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
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
                            'BarCode',
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
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
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
                            'BarCode',
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
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
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
                            'BarCode',
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
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
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
                            'BarCode',
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
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
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
                            'BarCode',
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
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
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
                            'BarCode',
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
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
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
                            'BarCode',
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
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
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
                            'BarCode',
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
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
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
                            'BarCode',
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
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
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
                            'BarCode',
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
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
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
                            'BarCode',
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
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Row(
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
                            'BarCode',
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
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                          ),
                          onPressed: () {},
                          iconSize: 75,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
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
