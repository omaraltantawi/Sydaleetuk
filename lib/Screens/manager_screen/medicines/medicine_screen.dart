import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'medicine.dart';

class MedicineScreenManager extends StatefulWidget {
  static const String routeName = 'MedicineScreenManager';

  @override
  State<MedicineScreenManager> createState() => _MedicineScreenManagerState();
}

class _MedicineScreenManagerState extends State<MedicineScreenManager> {
  Medicine medicine = Medicine(
      name: 'Vitamin C man zinc tupedu',
      barCode: '2013546136',
      price: '3.4',
      type: 'pills',
      size: '30',
      EXPDate: DateTime(2022, 11).toString(),
      MFGDate: DateTime(2022, 11).toString(),
      description:
          'Aspirin is used to reduce fever and relieve mild to moderate pain from conditions such as muscle aches, toothaches, common cold, and headaches. It may also be used to reduce pain and swelling in conditions such as arthritis.',
      image: Image.network(
          'https://kaifanonline.com/ecdata/stores/GRYBA173/image/cache/data/products/1602084178_aspirin-protect-595x738.png'),
      prescription: false);

  Color background = Color(0xFF099F9D);
  TextStyle _textStyle = TextStyle(
    color: Colors.black,
    fontSize: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${medicine.name}',
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
              child: Center(
                child: medicine.image,
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
                      'Name: ${medicine.name}',
                      overflow: TextOverflow.fade,
                      style: _textStyle,
                    ),
                    width: MediaQuery.of(context).size.width - 100,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                          TextEditingController(text: medicine.name);
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
                                              medicine.name = _controller.text;
                                              Navigator.pop(context);
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    background),
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
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    background),
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
                  Text(
                    'Barcode: ${medicine.barCode}',
                    style: _textStyle,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                          TextEditingController(text: medicine.barCode);
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
                                              medicine.barCode =
                                                  _controller.text;
                                              Navigator.pop(context);
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    background),
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
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    background),
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
                  Text(
                    'Price: ${medicine.price} JOD',
                    style: _textStyle,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                          TextEditingController(text: medicine.price);
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
                                              medicine.price = _controller.text;
                                              Navigator.pop(context);
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    background),
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
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    background),
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
                  Row(
                    children: [
                      Text(
                        'Size: ${medicine.size}',
                        style: _textStyle,
                      ),
                      SizedBox(width: 20,),
                      Text(
                        'Type: ${medicine.type}',
                        style: _textStyle,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                      TextEditingController(text: medicine.price);
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Change size and type'),
                            actions: [
                              Row(
                                children: [
                                  Container(
                                    width: 120,
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: 'Size',
                                          labelText: 'Size',),
                                      controller: _controller,
                                      keyboardType: TextInputType.number,
                                      maxLength: 6,
                                    ),
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
                                          medicine.size = _controller.text;
                                          Navigator.pop(context);
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            background),
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
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            background),
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
                  Text(
                    'prescription : ${medicine.prescription ? 'need' : 'don\'t need'} ',
                    style: _textStyle,
                  ),
                  Switch(
                    value: medicine.prescription,
                    onChanged: (value) {
                      setState(() {
                        medicine.prescription = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
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
                      Text(
                        'Description:',
                        style: _textStyle,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          TextEditingController _controller =
                              TextEditingController(text: medicine.description);
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
                                                  medicine.description =
                                                      _controller.text;
                                                  Navigator.pop(context);
                                                });
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        background),
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
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        background),
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
                        color: Colors.grey.shade700,
                        width: 2,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        medicine.description,
                        style: TextStyle(fontSize: 17, color: Colors.grey[600]),
                      ),
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
