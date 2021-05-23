
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MedicineList extends StatefulWidget {
  static const String routeName = 'MedicineList';

  @override
  _MedicineListState createState() => _MedicineListState();
}

List medicines = [];

class _MedicineListState extends State<MedicineList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF099F9D),
        tooltip: "Click here to add new Medicine",
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      appBar: AppBar(
        title: Text(
          'Medicine List',
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
        padding: EdgeInsets.all(8.0),
        children: [
          ListTile(
            title: Row(
              children: [
                Text('1. '),
                SizedBox(width: 10,),
                Icon(Icons.medical_services_outlined),
                SizedBox(width: 10,),
                Text('Medicine Name'),
              ],
            ),
            onTap: (){},
          ),
          ListTile(
            title: Row(
              children: [
                Text('2. '),
                SizedBox(width: 10,),
                Icon(Icons.medical_services_outlined),
                SizedBox(width: 10,),
                Text('Medicine Name'),
              ],
            ),
            onTap: (){},
          ),
          ListTile(
            title: Row(
              children: [
                Text('3. '),
                SizedBox(width: 10,),
                Icon(Icons.medical_services_outlined),
                SizedBox(width: 10,),
                Text('Medicine Name'),
              ],
            ),
            onTap: (){},
          ),
          ListTile(
            title: Row(
              children: [
                Text('4. '),
                SizedBox(width: 10,),
                Icon(Icons.medical_services_outlined),
                SizedBox(width: 10,),
                Text('Medicine Name'),
              ],
            ),
            onTap: (){},
          ),
        ],
      ),
    );
  }
}

class NoData extends StatelessWidget {
  const NoData({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          'No data, press + to add a medicine',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
