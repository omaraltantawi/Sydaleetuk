import 'package:flutter/widgets.dart';
import 'package:graduationproject/Screens/LoadAppScreen/load_screen.dart';
import 'package:graduationproject/Screens/OrderInfoScreen.dart';
import 'package:graduationproject/Screens/UserOrders.dart';
import 'package:graduationproject/Screens/checkOutOrderScreen.dart';
import 'package:graduationproject/Screens/complete_pharmacy_profile/complete_pharmacy_profile_screen.dart';
import 'package:graduationproject/Screens/employee_screen/main_employee_screen.dart';
import 'package:graduationproject/Screens/employee_screen/medicine/add_medicine.dart';
import 'package:graduationproject/Screens/employee_screen/medicine/medicine_list.dart';
import 'package:graduationproject/Screens/employee_screen/medicine/medicine_screen.dart';
import 'package:graduationproject/Screens/manager_screen/medicines/medicine_screen.dart';
import 'package:graduationproject/Screens/manager_screen/order/PharmacyOrderInfoScreen.dart';
import 'package:graduationproject/Screens/manager_screen/pharmacy/pharmacy_screen.dart';
import 'package:graduationproject/Screens/manager_screen/profile/profile_screen_pharmacist.dart';
import 'package:graduationproject/Screens/manager_screen/requests_medicines/request_screen.dart';
import 'package:graduationproject/Screens/signup_pharmacy/sign_up_pharmacy_screen.dart';
import 'package:graduationproject/Screens/userCartScreen.dart';
import 'package:graduationproject/Screens/userSettings.dart';
import 'Screens/SelectProduct.dart';
import 'Screens/manager_screen/employee/add_employee.dart';
import 'Screens/manager_screen/employee/employee_list.dart';
import 'Screens/manager_screen/employee/employee_screen.dart';
import 'Screens/manager_screen/managerSettings.dart';
import 'Screens/manager_screen/manager_screen.dart';
import 'Screens/manager_screen/medicines/add_medicine.dart';
import 'Screens/manager_screen/medicines/medicine_list.dart';
import 'Screens/manager_screen/order/order_list.dart';
import 'Screens/manager_screen/order/order_screen.dart';
import 'Screens/order_success/order_success_screen.dart';
import 'Screens/profile/profile_screen.dart';
import 'Screens/reminder/reminder_screen.dart';
import 'Screens/home/home_screen.dart';
import 'Screens/lets_text.dart';
import 'Screens/order.dart';
import 'Screens/show_profile/show_profile_screen.dart';
import 'screens/complete_profile/complete_profile_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/login_success/login_success_screen.dart';
import 'screens/otp/otp_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  UserScreen.routeName : (context) => UserScreen(),
  HomeScreen.routeName : (context) => HomeScreen(),
  ProfileScreen.routeName : (context) => ProfileScreen(),
  SelectProduct.routeName : (context) => SelectProduct(),
  OrderProduct.routeName : (context) => OrderProduct(),
  ReminderScreen.routeName : (context) => ReminderScreen(),
  OrderSuccessScreen.routeName : (context) => OrderSuccessScreen(),
  ManagerScreen.routeName : (context) => ManagerScreen(),
  MedicineList.routeName : (context) => MedicineList(),
  MedicineScreenManager.routeName : (context) => MedicineScreenManager(),
  AddMedicine.routeName : (context) => AddMedicine(),
  EmployeeList.routeName: (context) => EmployeeList(),
  LoadAppScreen.routeName: (context) => LoadAppScreen(),
  UserOrders.routeName: (context) => UserOrders(),
  SignUpPharmacyScreen.routeName: (context) => SignUpPharmacyScreen(),
  CompletePharmacyProfileScreen.routeName: (context) => CompletePharmacyProfileScreen(),
  EmployeeScreen.routeName: (context) => EmployeeScreen(),
  AddEmployee.routeName : (context) => AddEmployee(),
  OrderList.routeName : (context) => OrderList(),
  OrderScreen.routeName : (context) => OrderScreen(),
  ShowProfileScreen.routeName : (context) => ShowProfileScreen(),
  UserSettingsScreen.routeName : (context) => UserSettingsScreen(),
  CheckOutOrdersScreen.routeName : (context) => CheckOutOrdersScreen(),
  UserCartScreen.routeName : (context) => UserCartScreen(),
  OrderInfoScreen.routeName : (context) => OrderInfoScreen(),
  RequestScreen.routeName : (context) => RequestScreen(),
  PharmacyScreen.routeName: (context) => PharmacyScreen(),
  ProfileScreenPharmacist.routeName: (context) => ProfileScreenPharmacist(),
  MainEmployeeScreen.routeName : (context) => MainEmployeeScreen(),
  EmployeeMedicineList.routeName:(context) => EmployeeMedicineList(),
  EmployeeMedicineScreen.routeName:(context) => EmployeeMedicineScreen(),
  EmployeeAddMedicine.routeName:(context) => EmployeeAddMedicine(),
  PharmacyOrderInfoScreen.routeName:(context) => PharmacyOrderInfoScreen(),
  ManagerSettingsScreen.routeName:(context) => ManagerSettingsScreen(),
};
