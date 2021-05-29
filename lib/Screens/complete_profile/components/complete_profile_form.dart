import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduationproject/Screens/reminder/helpers/platform_flat_button.dart';
import 'package:graduationproject/Screens/sign_up/components/ScreenArguments.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/custom_surfix_icon.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/components/form_error.dart';
import 'package:graduationproject/providers/phone_auth.dart';
import 'package:graduationproject/screens/otp/otp_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  final ScreenArguments arguments;
  CompleteProfileForm(this.arguments);

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> with CanShowMessages {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String firstName;
  String lastName;
  String phoneNumber;
  String address;
  DateTime birthDate;
  String gender;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Future<void> openDatePicker() async {
    DateTime time = await showDatePickerDialog(context: context,dateTime: birthDate );
    setState(() {
      if ( time != null )
        birthDate = time;
    });
  }
  bool isLoading = false ;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              SizedBox(width: 10.0,),
              Text(
                'Gender : ' ,
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
              SizedBox(width: 10.0,),
              DropdownButton<String>(
                value: gender ,
                iconSize: 24,
                elevation: 16,
                onTap: (){
                  FocusScope.of(context).unfocus();
                },
                style: const TextStyle(color: kPrimaryColor, fontSize: 18.0),
                underline: Container(
                  height: 2.0,
                  color: kPrimaryColor,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    gender  = newValue;
                  });
                  print('Selected gender = $gender ');
                  FocusScope.of(context).unfocus();
                },
                items: <String>['Male','Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(15)),
          SizedBox(
            height : getProportionateScreenHeight(50),
            width :  SizeConfig.screenWidth * 0.90,
            child: Container(
              child: PlatformFlatButton(
                handler: () {
                    FocusScope.of(context).unfocus();
                    openDatePicker();
                  },
                buttonChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Birth Date:',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w200),
                    ),
                    SizedBox(width: 10),
                    Text(
                      this.birthDate != null ?DateFormat("dd/MM/yyyy").format(this.birthDate) : '',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.event,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
                color: Color.fromRGBO(7, 190, 200, 0.1),
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(15)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          if ( !isLoading )
            DefaultButton(
            text: "continue",
            press: () async {
              FocusScope.of(context).unfocus();
              bool hasError = false ;
              if ( birthDate == null ) {
                addError(error: kBirthDateEmptyError);
                hasError = true;
              }else
                removeError(error: kBirthDateEmptyError);
              if ( gender == null || gender == '' ) {
                addError(error: kGenderEmptyError);
                hasError = true;
              }else
                removeError(error: kGenderEmptyError);

              if (_formKey.currentState.validate() && !hasError) {
                _formKey.currentState.save();
                setState(() {
                  isLoading = true ;
                });
                await startPhoneAuth();
              }
              // setState(() {
              //   isLoading = false ;
              // });
            },
          ),
          if ( isLoading )
            SpinKitDoubleBounce(
              color: kPrimaryColor,
              size: SizeConfig.screenWidth * 0.15,
            ),
        ],
      ),
    );
  }

  startPhoneAuth() async {
    final phoneAuthDataProvider =
    Provider.of<PhoneAuthDataProvider>(context, listen: false);
    phoneAuthDataProvider.loading = true;
    bool validPhone = await phoneAuthDataProvider.instantiateNew(
        phoneNo: '+962${phoneNumber.substring(1)}',
        onCodeSent: () {
          print('onCodeSent Get Phone');
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text('onCodeSent'),
          //   duration: Duration(seconds: 5),
          // ));
          setState(() {
            isLoading = false;
          });
          Navigator.pushNamed(context, OtpScreen.routeName,arguments: ScreenArguments(email: widget.arguments.email,password: widget.arguments.password, addressGeoPoint: widget.arguments.addressGeoPoint,address: address,fName: firstName,lName: lastName, birthDate: birthDate , gender: gender ,phoneNo: '+962${phoneNumber.substring(1)}'));

        },
        onFailed: () {
          print('onFailed Get Phone');
          debugPrint('Fail to send.\n ${phoneAuthDataProvider.message}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(phoneAuthDataProvider.message),
            duration: Duration(seconds: 5),
          ));
          setState(() {
            isLoading = false;
          });
        },
        onError: () {
          print('onError Get Phone');
          debugPrint('Error while sending.\n ${phoneAuthDataProvider.message}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(phoneAuthDataProvider.message),
            duration: Duration(seconds: 5),
          ));
          setState(() {
            isLoading = false;
          });
        },
        onAutoRetrievalTimeout: (){
          setState(() {
            isLoading = false;
          });
        },
    );
    if (!validPhone) {
      phoneAuthDataProvider.loading = false;
      return;
    }
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter your address",

        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }else if ( value.length == 10 ){
          removeError(error: kInvalidPhoneNumberError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }else if ( value.length != 10 ){
          addError(error: kInvalidPhoneNumberError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",

        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",

        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
