import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/manager_screen/order/order_screen.dart';

class OrderList extends StatelessWidget {
  static const String routeName = 'OrderList';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders',
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
      body: ListView(
        children: [
          ListTile(
            title: Text('1. Order by Mohammad Al-Hrout'),
            onTap: (){
              Navigator.pushNamed(context, OrderScreen.routeName);
            },
          ),
          ListTile(
            title: Text('2. Order by customerName'),
          ),
          ListTile(
            title: Text('3. Order by customerName'),
          ),
        ],
      ),
    );
  }
}
