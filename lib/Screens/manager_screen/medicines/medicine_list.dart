import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_medicine.dart';
import 'medicine_screen_manager.dart';

List<Widget> medicines;

class MedicineList extends StatefulWidget {
  static const String routeName = 'MedicineList';

  @override
  _MedicineListState createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF099F9D),
        tooltip: "Click here to add new Medicine",
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              builder: (context) => AlertDialog(
                    title: Text("Add new medicine"),
                    content: Container(
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Container(
                              width: 150,
                              padding: EdgeInsets.only(bottom:6.0),
                              child: Center(
                                child: Text(
                                  'By Scan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFF099F9D)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(25.0),
                                        side: BorderSide(
                                          color: Colors.white,
                                          width: 2,
                                        )))),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AddMedicine.routeName);
                            },
                            child: Container(
                              width: 150,
                              padding: EdgeInsets.only(bottom:6.0),
                              child: Center(
                                child: Text(
                                  'Manually',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFF099F9D)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(25.0),
                                        side: BorderSide(
                                          color: Colors.white,
                                          width: 2,
                                        )))),
                          ),

                        ],
                      ),
                    ),
                  ),
              context: context);
        },
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
      body: medicine().length == 0 ? NoData() : Data(),
    );
  }
}

class Data extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: medicine(),
    );
  }
}

List<Widget> medicine() {
  medicines = [
    Medicine(
      number: 1,
      name: 'cook',
    ),
    Medicine(
      number: 2,
      name: 'aspirin',
    ),
    Medicine(
      number: 3,
      name: 'cola',
    ),
  ];

  return medicines;
}

class Medicine extends StatelessWidget {
  final int number;
  final String name;

  // final Image image;

  const Medicine({this.number, this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text('$number. '),
          SizedBox(
            width: 10,
          ),
          Icon(Icons.medical_services_outlined),
          SizedBox(
            width: 10,
          ),
          Text(name),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, MedicineScreenManager.routeName);
      },
    );
  }
}

class NoData extends StatelessWidget {
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
