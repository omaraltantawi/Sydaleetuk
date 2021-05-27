import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MedicineScreenManager extends StatefulWidget {
  static const String routeName = 'MedicineScreenManager';

  @override
  State<MedicineScreenManager> createState() => _MedicineScreenManagerState();
}

class _MedicineScreenManagerState extends State<MedicineScreenManager> {
  String medicineName = 'Vitamin C man zinc tupedu';

  String price = '4.5';

  List<String> type = ['pills', 'ml', 'mg'];

  String size = '30';

  var types;

  String barcode = '2013546136';

  bool prescription = false;

  String description =
      'Aspirin is used to reduce fever and relieve mild to moderate pain from conditions such as muscle aches, toothaches, common cold, and headaches. It may also be used to reduce pain and swelling in conditions such as arthritis.';

  Color background = Color(0xFF099F9D);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$medicineName',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: background,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.red,
              child: Center(
                child: Text('Medicine Images'),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      'Name: $medicineName',
                      overflow: TextOverflow.fade,
                    ),
                    width: MediaQuery.of(context).size.width - 100,
                  ),
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



                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(background),
                                          ),
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
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(background),
                                          ),
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
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Barcode: $barcode'),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                          TextEditingController(text: barcode);
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Change barCode'),
                                actions: [
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter the new barcode',
                                      labelText: 'New barcode',
                                    ),
                                    controller: _controller,
                                    keyboardType: TextInputType.number,
                                    maxLength: 20,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          child: Text('Submit'),
                                          onPressed: () {
                                            setState(() {
                                              barcode = _controller.text;
                                              Navigator.pop(context);
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(background),
                                          ),
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
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(background),
                                          ),
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
              padding: EdgeInsets.symmetric(horizontal: 15.0),
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
                                        suffixText: 'JOD'),
                                    controller: _controller,
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
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

                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(background),
                                          ),
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
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(background),
                                          ),
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
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('pills: $size'),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                          TextEditingController(text: size);
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Change barCode'),
                                actions: [
                                  Row(
                                    children: [
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Enter the new pill',
                                          labelText: 'New pill',
                                          constraints: BoxConstraints(
                                            maxWidth: 150,
                                            maxHeight: 150
                                          ),
                                        ),
                                        maxLength: 4,
                                        controller: _controller,
                                        keyboardType: TextInputType.number,
                                      ),
                                      DropdownButton(
                                          value: 1,
                                          items: [
                                            DropdownMenuItem(
                                              child: Text(type[0]),
                                              value: 1,
                                            ),
                                            DropdownMenuItem(
                                              child: Text(type[1]),
                                              value: 2,
                                            ),
                                            DropdownMenuItem(
                                                child: Text(type[2]), value: 3),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              types = value;
                                            });
                                          }),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          child: Text('Submit'),
                                          onPressed: () {
                                            setState(() {
                                              barcode = _controller.text;
                                              Navigator.pop(context);
                                            });
                                          },

                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(background),
                                          ),
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

                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(background),
                                          ),
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
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('prescription : $prescription '),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                          TextEditingController(text: prescription.toString());
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Change prescription '),
                                actions: [
                                  Row(
                                    children: [
                                      Text('prescription? '),
                                      Switch(
                                        value: prescription,
                                        onChanged: (value) {
                                          setState(() {
                                            prescription = value;
                                            print(prescription);
                                          });
                                        },
                                        activeTrackColor:
                                            Colors.lightGreenAccent,
                                        activeColor: Colors.green,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          child: Text('Submit'),
                                          onPressed: () {
                                            setState(() {
                                              prescription =
                                                  _controller.text.isNotEmpty;
                                              Navigator.pop(context);
                                            });
                                          },

                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(background),
                                          ),
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
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(background),
                                          ),
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
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
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
                                                  description =
                                                      _controller.text;
                                                  Navigator.pop(context);
                                                });
                                              },

                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(background),
                                              ),
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
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(background),
                                              ),
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
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 50.0,
                      maxHeight: 150.0,
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Delete'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
