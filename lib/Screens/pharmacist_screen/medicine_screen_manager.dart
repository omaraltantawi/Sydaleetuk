import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MedicineScreenManager extends StatefulWidget {
  static const String routeName = 'MedicineScreenManager';

  @override
  State<MedicineScreenManager> createState() => _MedicineScreenManagerState();
}

class _MedicineScreenManagerState extends State<MedicineScreenManager> {
  String medicineName = 'ASPIRIN';

  String price = '4.5';

  String description =
      'Aspirin is used to reduce fever and relieve mild to moderate pain from conditions such as muscle aches, toothaches, common cold, and headaches. It may also be used to reduce pain and swelling in conditions such as arthritis.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          medicineName,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.green,
              child: Center(
                child: Text('Medicine Images'),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name: $medicineName'),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                          TextEditingController(text: medicineName);
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Change name'),
                                actions: [
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter new name',
                                      labelText: 'New name',
                                    ),
                                    controller: _controller,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          child: Text('Submit'),
                                          onPressed: () {
                                            setState(() {
                                              medicineName = _controller.text;
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Price: $price JOD'),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                          TextEditingController(text: price);
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Change price'),
                                actions: [
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter the new price',
                                      labelText: 'New price',
                                    ),
                                    controller: _controller,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          child: Text('Submit'),
                                          onPressed: () {
                                            setState(() {
                                              price = _controller.text;
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                    },
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 15, left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Description:'),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          TextEditingController _controller =
                          TextEditingController(text: description);
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Change description'),
                                actions: [
                                  Container(
                                    height: 300,
                                    child: TextField(

                                      decoration: InputDecoration(
                                        hintText: 'Enter new description',
                                        labelText: 'Edit description',

                                      ),
                                      controller: _controller,
                                      maxLines: 10,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          child: Text('Submit'),
                                          onPressed: () {
                                            setState(() {
                                              description = _controller.text;
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                        },
                      ),
                    ],
                  ),
                ),

                Container(

                  width: double.infinity,
                  padding: EdgeInsets.symmetric( horizontal: 15.0),
                  child: Container(
                    constraints:  BoxConstraints(
                      minHeight: 50.0,
                      maxHeight: 300.0,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Colors.red,
                        width: 3,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Text(description),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
