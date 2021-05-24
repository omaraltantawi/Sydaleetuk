import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/LoadAppScreen/load_screen.dart';
import 'package:graduationproject/Screens/home/home_screen.dart';
import 'package:graduationproject/Screens/manager_screen/manager_screen.dart';
import 'package:graduationproject/data_models/User.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/providers/ProductProvider.dart';
import 'package:graduationproject/providers/countries.dart';
import 'package:graduationproject/providers/phone_auth.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'screens/splash/splash_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();

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
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  String getInitialRoute(UserType type) {
    print('UserType $type');
    if (type == UserType.NormalUser)
      return HomeScreen.routeName;
    else if (type == UserType.PharmacyUser)
      return ManagerScreen.routeName;
    else if (type == UserType.EmployeeUser)
      return ManagerScreen.routeName;
    else
      return SplashScreen.routeName;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FireBaseAuth>(builder: (ctx, authProvider, _) {
      return FutureBuilder(
          future: authProvider.getCurrentUserData(),
          builder: (BuildContext ctxt, AsyncSnapshot<UserType> snapshot) {
            String initialRoute ;
            if (authProvider.key == '1234') {
              initialRoute = SplashScreen.routeName;
            }else if (snapshot.connectionState == ConnectionState.waiting) {
              print('waiting');
              initialRoute = LoadAppScreen.routeName;
            } else if (snapshot.hasError || !snapshot.hasData) {
              initialRoute = SplashScreen.routeName;
              authProvider.key = '12345';
              print('error or no data');
            } else {
              initialRoute = getInitialRoute(snapshot.data);
              authProvider.key = '12345';
              print('Route is $initialRoute');
            }
            return MaterialApp(
              key: Key(authProvider.key),
              debugShowCheckedModeBanner: false,
              title: 'Graduation Project 2',
              theme: theme(),
              // We use routeName so that we dont need to remember the name
              //If the user is already login we will open the User home screen .
              initialRoute: initialRoute,
              routes: routes,
            );
          });
    });
  }
}

//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//
//   String getInitialRoute(UserType type) {
//     print('UserType $type');
//     if (type == UserType.NormalUser)
//       return HomeScreen.routeName;
//     else if (type == UserType.PharmacyUser)
//       return ManagerScreen.routeName;
//     else if (type == UserType.EmployeeUser)
//       return ManagerScreen.routeName;
//     else
//       return SplashScreen.routeName;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // return MaterialApp(
//     //   debugShowCheckedModeBanner: false,
//     //   title: 'Graduation Project 2',
//     //   theme: theme(),
//     //   // home: SplashScreen(),
//     //   // We use routeName so that we dont need to remember the name
//     //   initialRoute: SplashScreen.routeName,
//     //   routes: routes,
//     // );
//     return Consumer<FireBaseAuth>(builder: (ctx, value, _) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Graduation Project 2',
//         theme: theme(),
//         // We use routeName so that we dont need to remember the name
//         //If the user is already login we will open the User home screen .
//         initialRoute: value.isLoading
//             ? LoadAppScreen.routeName
//             : (value.isAuth
//                 ? getInitialRoute(value.loggedUserType)
//                 : SplashScreen.routeName),
//         routes: routes,
//       );
//     });
//   }
// }
