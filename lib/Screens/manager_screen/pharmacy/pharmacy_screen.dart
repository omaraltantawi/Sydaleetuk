
import 'package:flutter/material.dart';

class PharmacyScreen extends StatefulWidget {
  static const String routeName = 'PharmacyScreen';

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  String pharmacyName;

  String pharmacyLocation;

  String phoneNumber;

  Color background = Color(0xFF099F9D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
        'Edit pharmacy information',
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
                child: Text('pharmacy Images'),
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
                      'Name: $pharmacyName',
                      overflow: TextOverflow.fade,
                    ),
                    width: MediaQuery.of(context).size.width - 100,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                      TextEditingController(text: pharmacyName);
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
                                          pharmacyName = _controller.text;
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
                  Text('phone: $phoneNumber'),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                      TextEditingController(text: phoneNumber);
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
                                          phoneNumber = _controller.text;
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
                  Text('location: $pharmacyLocation'),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                      TextEditingController(text: pharmacyLocation);
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Change Location'),
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
                                          pharmacyLocation = _controller.text;
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
                          ),);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
