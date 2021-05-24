import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduationproject/Screens/sign_up/components/ScreenArguments.dart';
import 'package:graduationproject/Screens/splash/splash_screen.dart';
import 'package:graduationproject/components/MessageDialog.dart';
import 'package:graduationproject/components/custom_surfix_icon.dart';
import 'package:graduationproject/components/default_button.dart';
import 'package:graduationproject/components/form_error.dart';
import 'package:graduationproject/firebase/auth/auth.dart';
import 'package:graduationproject/providers/phone_auth.dart';
import 'package:graduationproject/screens/otp/otp_screen.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class CompletePharmacyProfileForm extends StatefulWidget {
  final ScreenArguments arguments;
  CompletePharmacyProfileForm(this.arguments);

  @override
  _CompletePharmacyProfileFormState createState() => _CompletePharmacyProfileFormState();
}

class _CompletePharmacyProfileFormState extends State<CompletePharmacyProfileForm> with CanShowMessages{
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String name;
  String phoneNumber;

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


  List<Asset> images = [];
  Future<void> pickImage() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: false,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Sydaleetuk",
        ),
      );
      setState(() {
        images = resultList;
      });
    }on NoImagesSelectedException catch (e){
      print(e);
      setState(() {
        images = [];
      });
    } catch (e) {
      print(e);
      print(e.runtimeType);
      showMessageDialog(
          context: this.context,
          msgTitle: 'Warning',
          msgText: ['Something went wrong.', 'Please try again'],
          buttonText: 'OK');
    }
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();
    final tempDirectory = Directory.systemTemp;
    print(tempDirectory.path);
    final tempFile = File('${tempDirectory.path}/${asset.name}');
    print(tempFile.path);
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    return file;
  }

  Future<List<File>> getImageFilesFromAssets() async {
    List<File> files = [];
    for (var value in images) {
      files.add(await getImageFileFromAssets(value));
    }
    return files;
  }

  bool isLoading = false ;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          SizedBox(
            width: SizeConfig.screenWidth * 0.65,
            child: DefaultButton(
              text: "Choose Pharmacy Docs",
              press: pickImage,
            ),
          ),
          Text(
              'Docs number : ${images.length}'
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          isLoading ?
          SpinKitDoubleBounce(
            color: kPrimaryColor,
            size: SizeConfig.screenWidth * 0.15,
          )
          :DefaultButton(
            text: "Request",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                if ( images.length == 0 ) {
                  addError(error: kDocsEmptyError);
                  return ;
                }
                else
                  removeError(error: kDocsEmptyError);
                setState(() {
                  isLoading = true;
                });
                List<File> files = await getImageFilesFromAssets();
                await Provider.of<FireBaseAuth>(context,listen:false).signUpPharmacyWithUser(widget.arguments.email, widget.arguments.fName, widget.arguments.lName, widget.arguments.phoneNo, widget.arguments.experience,pharmacyName:name,pharmacyPhoneNo: phoneNumber,files: files , addressGeoPoint: widget.arguments.addressGeoPoint );
                await showMessageDialog(
                    context: this.context,
                    msgTitle: 'Confirm',
                    msgText: [
                      'Your request has sent Successfully.',
                      'Please Wait until app admin approve your request.'
                    ],
                    buttonText: 'OK');
                Navigator.pushNamedAndRemoveUntil(context, SplashScreen.routeName, (route) => false);
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
        ],
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
        hintText: "Enter pharmacy phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      onSaved: (newValue) => name = newValue,
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
        labelText: "Pharmacy Name",
        hintText: "Enter pharmacy name",

        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
