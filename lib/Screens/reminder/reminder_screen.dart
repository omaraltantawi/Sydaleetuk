import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduationproject/Screens/reminder/screens/add_new_medicine/add_new_medicine.dart';
import 'package:graduationproject/Screens/reminder/screens/home/home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black.withOpacity(0.05),
      statusBarColor: Colors.black.withOpacity(0.05),
      statusBarIconBrightness: Brightness.dark
  ));
}

class ReminderScreen extends StatelessWidget {

  static String routeName = "/reminder";
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(

          primaryColor: Color(0xFF099F9D),
          textTheme: TextTheme(
              headline1: ThemeData.light().textTheme.headline1.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20.0,

              ),
              headline5: ThemeData.light().textTheme.headline1.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 17.0,

              ),
              headline3: ThemeData.light().textTheme.headline3.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ))),
      routes: {

        "/home": (context) => Home(),
        "/add_new_medicine": (context) => AddNewMedicine(),
      },
      initialRoute: "/home",
    );
  }
}
