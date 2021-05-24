import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduationproject/constants.dart';
import 'package:graduationproject/data_models/User.dart';
import 'package:graduationproject/providers/ProductProvider.dart';
import 'package:image_picker/image_picker.dart';

class MessageDialog {
  List<Text> getTextWidget(List<String> _textList) {
    List<Text> list = [];
    for (String _text in _textList) {
      list.add(Text(_text,textAlign: TextAlign.center,));
    }
    return list;
  }

  Future<void> _showDialog(
      {@required BuildContext context,
      @required String msgTitle,
      @required List<String> msgText,
      @required String buttonText}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: <Widget>[
            Image.asset('assets/images/splash_2.png',
                width: 50, height: 50, fit: BoxFit.contain),
            SizedBox(
              width: 10.0,
            ),
            Text(msgTitle)
          ]),
          content: SingleChildScrollView(
            child: ListBody(
              children: getTextWidget(msgText),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<QuestionMessage> _showQuestionDialog(
      {@required BuildContext context,
      @required String msgTitle,
      @required List<String> msgText,
      @required String buttonText}) async {
    return await showDialog<QuestionMessage>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: <Widget>[
            Image.asset('assets/images/splash_2.png',
                width: 50, height: 50, fit: BoxFit.contain),
            Text(msgTitle)
          ]),
          content: SingleChildScrollView(
            child: ListBody(
              children: getTextWidget(msgText),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('YES'),
              onPressed: () {
                Navigator.of(context).pop(QuestionMessage.YES);
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(QuestionMessage.CANCEL);
              },
            ),
          ],
        );
      },
    );
  }

  Future<File> _showPickFileDialog(
      {@required BuildContext context,
      @required List<String> msgText,}) async {
    File file ;
    return await showDialog<File>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(Icons.warning_amber_rounded, size: 32.0,color: kPrimaryColor,),
          content: SingleChildScrollView(
            child: ListBody(
              children: getTextWidget(msgText),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Upload Prescription'),
              onPressed: () async {
                try {
                  // file = await pickImage();
                  // if (file != null) {
                  //   print ('File picked');
                  //   return ;
                  // } else {
                  //   showMessageDialog(
                  //       context: this.context,
                  //       msgTitle: 'Warning',
                  //       msgText: [
                  //         'Prescription is required to make an order!!',
                  //       ],
                  //       buttonText: 'OK');
                  //   return;
                  // }
                  final picker = ImagePicker();
                  final pickedFile = await picker.getImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    file = File(pickedFile.path);
                  } else {
                    file = null ;
                    return;
                  }
                }catch(e){
                  _showDialog(
                      context: context,
                      msgTitle: 'Warning',
                      msgText: [
                        'Something went wrong','Please try again.'
                      ],
                      buttonText: 'OK');
                  return;
                }
                Navigator.of(context).pop(file);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
          ],
        );
      },
    );
  }

  UserType _pickeduserType = UserType.NormalUser;
  ProductSearchFilter _productSearchFilter = ProductSearchFilter.Name;

  Future<UserType> _showUserPickerDialog(
      {@required BuildContext context , }) async {
    _pickeduserType = UserType.NormalUser;
    String msgTitle = 'User Type';
    return await showDialog<UserType>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: <Widget>[
            Image.asset('assets/images/splash_2.png',
                width: 40, height: 40, fit: BoxFit.contain),
            Text(msgTitle)
          ]),
          content: Center(
            heightFactor: 1.0,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return DropdownButton<UserType>(
                  value: _pickeduserType,
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.blue, fontSize: 16.0),
                  underline: Container(
                    height: 2,
                    color: Colors.lightBlue,
                  ),
                  onChanged: (UserType newValue) {
                    setState(() {
                      _pickeduserType = newValue;
                    });
                    print('Selected User Type = $_pickeduserType');
                  },
                  items: <UserType>[UserType.NormalUser, UserType.PharmacyUser]
                      .map<DropdownMenuItem<UserType>>((UserType value) {
                    return DropdownMenuItem<UserType>(
                      value: value,
                      child: Text(value == UserType.NormalUser
                          ? "Normal User"
                          : "Pharmacy User"),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(_pickeduserType);
              },
            ),
          ],
        );
      },
    );
  }

  Future<ProductSearchFilter> _showFilterByPickerDialog(
      {@required BuildContext context , @required ProductSearchFilter filter}) async {
    _productSearchFilter = filter;
    String msgTitle = 'Filter By';
    return await showDialog<ProductSearchFilter>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: <Widget>[
            Image.asset('assets/images/splash_2.png',
                width: 40, height: 40, fit: BoxFit.contain),
            Text(msgTitle)
          ]),
          content: Center(
            heightFactor: 1.0,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return DropdownButton<ProductSearchFilter>(
                  value: _productSearchFilter,
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.blue, fontSize: 16.0),
                  underline: Container(
                    height: 2,
                    color: Colors.lightBlue,
                  ),
                  onChanged: (ProductSearchFilter newValue) {
                    setState(() {
                      _productSearchFilter = newValue;
                    });
                    print('Selected Product Search Filter = $_productSearchFilter');
                  },
                  items: <ProductSearchFilter>[ProductSearchFilter.Name, ProductSearchFilter.Distance,ProductSearchFilter.Price]
                      .map<DropdownMenuItem<ProductSearchFilter>>((ProductSearchFilter value) {
                    return DropdownMenuItem<ProductSearchFilter>(
                      value: value,
                      child: Text(value == ProductSearchFilter.Name
                          ? "Name"
                          : ( value == ProductSearchFilter.Distance ? "Distance" : "Price" )),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(_productSearchFilter);
              },
            ),
          ],
        );
      },
    );
  }

  // StatefulBuilder(
  // builder: (BuildContext context, StateSetter setState) {
  // return DropdownButton<UserType>(
  // value: _pickeduserType,
  // iconSize: 24,
  // elevation: 16,
  // style: const TextStyle(color: Colors.blue),
  // underline: Container(
  // height: 2,
  // color: Colors.lightBlue,
  // ),
  // onChanged: (UserType newValue) {
  // setState(() {
  // _pickeduserType = newValue;
  // });
  // print('Selected User Type = $_pickeduserType');
  // },
  // items: <UserType>[
  // UserType.NormalUser,
  // UserType.PharmacyUser
  // ].map<DropdownMenuItem<UserType>>((UserType value) {
  // return DropdownMenuItem<UserType>(
  // value: value,
  // child: Text(value == UserType.NormalUser
  // ? "Normal User"
  //     : "Pharmacy User"),
  // );
  // }).toList(),
  // );
  // },
  // ),
  Future<DateTime> _showDatePickerDialog(
      {@required BuildContext context , @required DateTime dateTime}) async {
    DateTime date;
    if ( dateTime == null )
      date = DateTime.now();
    else
      date = dateTime;
    return await showDatePicker(
      context: context,
      initialDate: date,
      lastDate: DateTime.now(),
      firstDate: DateTime(date.year - 100, 1, 1),
      currentDate: DateTime.now(),
      confirmText: 'OK',
      cancelText: 'Cancel',
    );
  }
}

mixin CanShowMessages {
  final MessageDialog _messageDialog = MessageDialog();

  Future<void> showMessageDialog(
      {@required BuildContext context,
      @required String msgTitle,
      @required List<String> msgText,
      @required String buttonText}) async {
    await _messageDialog._showDialog(
        context: context,
        msgTitle: msgTitle,
        msgText: msgText,
        buttonText: buttonText);
  }

  Future<QuestionMessage> showQuestionDialog(
      {@required BuildContext context,
      @required String msgTitle,
      @required List<String> msgText,
      @required String buttonText}) async {
    QuestionMessage msg = await _messageDialog._showQuestionDialog(
        context: context,
        msgTitle: msgTitle,
        msgText: msgText,
        buttonText: buttonText);
    return msg;
  }

  Future<DateTime> showDatePickerDialog(
      {@required BuildContext context, @required DateTime dateTime}) async {
    DateTime selectedDate =
        await _messageDialog._showDatePickerDialog(context: context , dateTime: dateTime);
    return selectedDate;
  }

  Future<UserType> showUserPickerDialog(
      {@required BuildContext context}) async {
    UserType selectedUser =
        await _messageDialog._showUserPickerDialog(context: context);
    return selectedUser;
  }

  Future<ProductSearchFilter> showFilterByPickerDialog(
      {@required BuildContext context , @required ProductSearchFilter filter}) async {
    ProductSearchFilter selectedUser =
        await _messageDialog._showFilterByPickerDialog(context: context,filter: filter);
    return selectedUser;
  }

  Future<File> showPickFileDialog(
      {@required BuildContext context , @required List<String> msgText,}) async {
    File selectedFile =
        await _messageDialog._showPickFileDialog(context: context,msgText: msgText);
    return selectedFile;
  }
}

enum QuestionMessage { YES, CANCEL }
