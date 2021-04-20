import 'package:flutter/material.dart';
import 'package:graduationproject/data_models/User.dart';

class MessageDialog {
  List<Text> getTextWidget(List<String> _textList) {
    List<Text> list = [];
    for (String _text in _textList) {
      list.add(Text(_text));
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
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(QuestionMessage.CANCEL);
              },
            ),
          ],
        );
      },
    );
  }

  UserType _pickeduserType = UserType.NormalUser;

  Future<UserType> _showUserPickerDialog(
      {@required BuildContext context}) async {
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
      {@required BuildContext context}) async {
    DateTime date = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: date,
      lastDate: date,
      firstDate: DateTime(date.year - 100, 1, 1),
      currentDate: date,
      confirmText: 'OK',
      cancelText: 'Cancel',
    );
  }
}

mixin CanShowMessages {
  MessageDialog _messageDialog = new MessageDialog();

  void showMessageDialog(
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
      {@required BuildContext context}) async {
    DateTime selectedDate =
        await _messageDialog._showDatePickerDialog(context: context);
    return selectedDate;
  }

  Future<UserType> showUserPickerDialog(
      {@required BuildContext context}) async {
    UserType selectedUser =
        await _messageDialog._showUserPickerDialog(context: context);
    return selectedUser;
  }
}

enum QuestionMessage { YES, CANCEL }
