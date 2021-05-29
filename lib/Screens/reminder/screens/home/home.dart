
import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../notifications/notifications.dart';
import '../../database/repository.dart';
import '../../models/pill.dart';
import '../../screens/home/medicines_list.dart';
import '../../screens/home/calendar.dart';
import '../../models/calendar_day_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //-------------------| Flutter notifications |-------------------
  final Notifications _notifications = Notifications();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  //===============================================================

  //--------------------| List of Pills from database |----------------------
  List<Pill> allListOfPills = List<Pill>();
  final Repository _repository = Repository();
  List<Pill> dailyPills = List<Pill>();
  //=========================================================================

  //-----------------| Calendar days |------------------
  final CalendarDayModel _days = CalendarDayModel();
  List<CalendarDayModel> _daysList;
  //====================================================

  //handle last choose day index in calendar
  int _lastChooseDay = 0;

  @override
  void initState() {
    super.initState();
    initNotifies();
    setData();
    _daysList = _days.getCurrentDays();
  }

  //init notifications
  Future initNotifies() async => flutterLocalNotificationsPlugin = await _notifications.initNotifies(context);


  //--------------------GET ALL DATA FROM DATABASE---------------------
  Future setData() async {
    allListOfPills.clear();
    (await _repository.getAllData("Pills")).forEach((pillMap) {
      allListOfPills.add(Pill().pillMapToObject(pillMap));
    });
    chooseDay(_daysList[_lastChooseDay]);
  }
  //===================================================================

  @override
  Widget build(BuildContext context) {
    final double deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    final Widget addButton = FloatingActionButton.extended(
      elevation: 2.0,
      shape: StadiumBorder(
          side: BorderSide(color: Color(0xFF65C1BF), width: 1)),
      onPressed: () async {
        //refresh the pills from database
        await Navigator.pushNamed(context, "/add_new_medicine")
            .then((_) => setData());
      },

      label: const Text('Add New Reminder',
          style: TextStyle(color: Colors.white)),
      icon:
      const Icon(Icons.access_alarm, color: Colors.white),
      tooltip:
      "Click here to add new reminder !",

      backgroundColor: Theme.of(context).primaryColor,
    );

    return Scaffold(
      floatingActionButton: addButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Color.fromRGBO(248, 248, 248, 1),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                top: 0.0, left: 25.0, right: 25.0, bottom: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: deviceHeight * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: deviceHeight * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Medication Reminder",
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(color: Colors.black),
                        ),
                        ShakeAnimatedWidget(
                          enabled: true,
                          duration: Duration(milliseconds: 2000),
                          curve: Curves.linear,
                          shakeAngle: Rotation.deg(z: 30),
                          child: Icon(
                            Icons.notifications_none,
                            size: 42.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Calendar(chooseDay,_daysList),
                ),
                SizedBox(height: deviceHeight * 0.03),
                dailyPills.isEmpty
                    ? SizedBox(
                        width: double.infinity,
                        height: 300,

                  child:  Image.asset(

                  "assets/images/empty.png",


          )

                      )
                    : MedicinesList(dailyPills,setData,flutterLocalNotificationsPlugin)
              ],
            ),
          ),
        ),
      ),
    );
  }


  //-------------------------| Click on the calendar day |-------------------------

  void chooseDay(CalendarDayModel clickedDay){
    setState(() {
      _lastChooseDay = _daysList.indexOf(clickedDay);
      _daysList.forEach((day) => day.isChecked = false );
      CalendarDayModel chooseDay = _daysList[_daysList.indexOf(clickedDay)];
      chooseDay.isChecked = true;
      dailyPills.clear();
      allListOfPills.forEach((pill) {
        DateTime pillDate = DateTime.fromMicrosecondsSinceEpoch(pill.time * 1000);
        if(chooseDay.dayNumber == pillDate.day && chooseDay.month == pillDate.month && chooseDay.year == pillDate.year){
          dailyPills.add(pill);
        }
      });
      dailyPills.sort((pill1,pill2) => pill1.time.compareTo(pill2.time));
    });
  }

  //===============================================================================


}
