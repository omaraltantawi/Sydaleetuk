import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  static const String routeName = 'OrderScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Name',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF099F9D),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.red,
                    size: 100,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Name',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          Text('Order time: 02:45 PM'),
                          SizedBox(
                            width: 30,
                          ),
                          Text('Distance: 2K'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text('perception: '),
                ),
                SizedBox(width: 20,),
                ElevatedButton(onPressed: null, child: Text('Show perception'),)
              ],
            ),
            SizedBox(
              height: 50,
            ),
            // Container(
            //   width: double.infinity,
            //   height: 400,
            //   padding: EdgeInsets.all(10.0),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(width: 2,color: Colors.red),
            //
            //   ),
            //   child: ListView(
            //
            //     children: [
            //       ListTile(
            //         title: Text('Medicine Name 1'),
            //       ),
            //       ListTile(
            //         title: Text('Medicine Name 2'),
            //       ),
            //       ListTile(
            //         title: Text('Medicine Name 3'),
            //       ),
            //       ListTile(
            //         title: Text('Medicine Name 4'),
            //       ),
            //
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
