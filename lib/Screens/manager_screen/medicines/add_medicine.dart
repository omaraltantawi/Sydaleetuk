
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddMedicine extends StatefulWidget {
  static const String routeName = 'AddMedicine';

  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Medicine',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            ListView(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.green,
                  child: Center(
                    child: Text('Medicine Images'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Medicine Name',
                    hintText: 'Enter medicine name',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: '3.5',
                    suffixText: 'JOD',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Need prescription',
                    hintText: 'True Or False',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'pills',
                    hintText: 'The Number of pills',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Medicine Description',
                    hintText: 'Description',
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: ElevatedButton(onPressed: (){},child: Text('Cancel'),),),
                    SizedBox(width: 10,),
                    Expanded(child: ElevatedButton(onPressed: (){},child: Text('Submit'),),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
