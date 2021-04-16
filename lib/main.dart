import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/auth_screen.dart';
import 'package:graduationproject/Screens/lets_text.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/providers/countries.dart';
import 'package:graduationproject/providers/phone_auth.dart';
import 'package:provider/provider.dart';

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
      child: FireApp(),
    ),
  );
}

class FireApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //       create: (context) => CountryProvider(),
    //     ),
    //     ChangeNotifierProvider(
    //       create: (context) => PhoneAuthDataProvider(),
    //     ),
    //   ],
    //   child: MaterialApp(
    //     home: PhoneAuthGetPhone(),
    //     debugShowCheckedModeBanner: false,
    //   ),
    // );
    // var provider = Provider.of<FireBaseAuth>(context,listen: true);
    // return MaterialApp(
    //   home: provider.isAuth ? UserScreen() : AuthScreen(),
    //   debugShowCheckedModeBanner: false,
    // );
    return Consumer<FireBaseAuth>(
      builder: (ctx, value, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: value.isAuth ? UserScreen() : AuthScreen(),
      ),
    );
  }
}
