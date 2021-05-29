import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:graduationproject/size_config.dart';

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
      description:
          'Aspirin is used to reduce fever and relieve mild to moderate pain from conditions such as muscle aches, toothaches, common cold, and headaches. It may also be used to reduce pain and swelling in conditions such as arthritis.',
      image: [
        Image.network(
            'https://kaifanonline.com/ecdata/stores/GRYBA173/image/cache/data/products/1602084178_aspirin-protect-595x738.png'),
        Image.network(
            'https://kaifanonline.com/ecdata/stores/GRYBA173/image/cache/data/products/1602084178_aspirin-protect-595x738.png'),
        Image.network(
            'https://kaifanonline.com/ecdata/stores/GRYBA173/image/cache/data/products/1602084178_aspirin-protect-595x738.png'),
        Image.network(
            'https://kaifanonline.com/ecdata/stores/GRYBA173/image/cache/data/products/1602084178_aspirin-protect-595x738.png'),
      ],
      prescription: false);

  Color background = Color(0xFF099F9D);
  TextStyle _textStyle1 = TextStyle(
    color: Colors.black,
    fontSize: 25,
  );
  TextStyle _textStyle = TextStyle(
    color: Color(0xFF099F9D),
    fontSize: 25,
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
        padding:
            EdgeInsets.only(top: 2.0, left: 20.0, right: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 350,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      medicine.image[0],
                      SizedBox(
                        width: 10,
                      ),
                      medicine.image[1],
                      SizedBox(
                        width: 10,
                      ),
                      medicine.image[2],
                      SizedBox(
                        width: 10,
                      ),
                      medicine.image[3],
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('edit Image'),
                      IconButton(
                        icon: Icon(Icons.edit,color: Colors.grey,),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text('Change image'),
                                    contentPadding: EdgeInsets.all(10.0),
                                    actions: [
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 20.0),
                                        constraints: BoxConstraints(
                                          maxHeight:
                                              getProportionateScreenHeight(300),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text('1. '),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        height:
                                                            getProportionateScreenHeight(
                                                                100),
                                                        width:
                                                            getProportionateScreenWidth(
                                                                100),
                                                        child: medicine.image[0],
                                                      ),
                                                    ],
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text('2. '),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        height:
                                                            getProportionateScreenHeight(
                                                                100),
                                                        width:
                                                            getProportionateScreenWidth(
                                                                100),
                                                        child: medicine.image[1],
                                                      ),
                                                    ],
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text('3. '),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        height:
                                                            getProportionateScreenHeight(
                                                                100),
                                                        width:
                                                            getProportionateScreenWidth(
                                                                100),
                                                        child: medicine.image[2],
                                                      ),
                                                    ],
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text('4. '),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        height:
                                                            getProportionateScreenHeight(
                                                                100),
                                                        width:
                                                            getProportionateScreenWidth(
                                                                100),
                                                        child: medicine.image[3],
                                                      ),
                                                    ],
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(color: Colors.black),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              child: Text('Submit'),
                                              onPressed: () {
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
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Name: ',
                        style: _textStyle,
                      ),
                      Expanded(
                        child: Text(
                          '${medicine.name}',
                          style: _textStyle1,
                        ),
                      ),
                    ],
                  ),
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
                                  minLines: 1,
                                  maxLines: 3,
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
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Barcode: ',
                  style: _textStyle,
                ),
                Text(
                  medicine.barCode,
                  style: _textStyle1,
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    TextEditingController _controller =
                        TextEditingController(text: medicine.barCode);
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text('Change name'),
                              actions: [
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'new bar code',
                                    labelText: 'BarCode',
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: _controller,
                                  minLines: 1,
                                  maxLines: 1,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        child: Text('Submit'),
                                        onPressed: () {
                                          setState(() {
                                            medicine.barCode = _controller.text;
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
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price: ',
                  style: _textStyle,
                ),
                Text(
                  medicine.price,
                  style: _textStyle1,
                ),
                Text(
                  ' JOD',
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
                                        MaterialStateProperty.all(background),
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
                                        MaterialStateProperty.all(background),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'prescription: ',
                  style: _textStyle,
                ),
                Text(
                  medicine.prescription ? 'required' : 'not required',
                  style: _textStyle1,
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
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'pillllsss: ',
                  style: _textStyle,
                ),
                Text(
                  medicine.prescription.toString(),
                  style: _textStyle1,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Description: ',
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
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Enter new description',
                                    labelText: 'Edit description',
                                  ),
                                  controller: _controller,
                                  maxLines: 10,
                                  minLines: 1,
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
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  constraints: BoxConstraints(
                    minHeight: 50.0,
                    maxHeight: 150.0,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
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
