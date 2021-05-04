import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/home/home_screen.dart';
import 'package:graduationproject/Screens/lets_text.dart';
import 'package:graduationproject/Screens/profile/profile_screen.dart';
import 'package:graduationproject/enums.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/providers/countries.dart';
import 'package:graduationproject/providers/phone_auth.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'screens/splash/splash_screen.dart';
import 'theme.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // runApp(FireApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CountryProvider>(
          create: (context) => CountryProvider(),
        ),
        ChangeNotifierProvider<FireBaseAuth>(
          create: (context) => FireBaseAuth(),
        ),
        ChangeNotifierProvider<PhoneAuthDataProvider>(
          create: (context) => PhoneAuthDataProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Graduation Project 2',
    //   theme: theme(),
    //   // home: SplashScreen(),
    //   // We use routeName so that we dont need to remember the name
    //   initialRoute: SplashScreen.routeName,
    //   routes: routes,
    // );
    return Consumer<FireBaseAuth>(
      builder: (ctx, value, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Graduation Project 2',
        theme: theme(),
        // We use routeName so that we dont need to remember the name
        //If the user is already login we will open the User home screen .
        initialRoute: value.isAuth ? HomeScreen.routeName : SplashScreen.routeName ,
        routes: routes,
      ),
    );
  }
}
