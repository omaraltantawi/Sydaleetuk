import 'dart:math';

double estimateBruteforceStrength(String password) {
  if (password.isEmpty) return 0.0;

  // Check which types of characters are used and create an opinionated bonus.
  double charsetBonus;
  if (RegExp(r'^[a-z]*$').hasMatch(password)) {
    charsetBonus = 1.0;
  } else if (RegExp(r'^[a-z0-9]*$').hasMatch(password)) {
    charsetBonus = 1.2;
  } else if (RegExp(r'^[a-zA-Z]*$').hasMatch(password)) {
    charsetBonus = 1.3;
  } else if (RegExp(r'^[a-z\-_!?]*$').hasMatch(password)) {
    charsetBonus = 1.3;
  } else if (RegExp(r'^[a-zA-Z0-9]*$').hasMatch(password)) {
    charsetBonus = 1.5;
  } else {
    charsetBonus = 1.8;
  }

  final logisticFunction = (double x) {
    return 1.0 / (1.0 + exp(-x));
  };

  final curve = (double x) {
    return logisticFunction((x / 3.0) - 4.0);
  };

  return curve(password.length * charsetBonus);
}

bool isEmailChecker(String string) {
  // Null or empty string is invalid
  if (string == null || string.isEmpty) {
    return false;
  }

  const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final regExp = RegExp(pattern);

  if (!regExp.hasMatch(string)) {
    return false;
  }
  return true;
}

bool checkPasswordStrength(String password ) {
  if (estimateBruteforceStrength(password) > 0.5)
    return true;
  else
    return false;
}


String generatePassword(bool _isWithLetters, bool _isWithUppercase,
    bool _isWithNumbers, bool _isWithSpecial, double _numberCharPassword) {

  //Define the allowed chars to use in the password
  String _lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
  String _upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  String _numbers = "0123456789";
  String _special = "@#=+!£\$%&?[](){}";

  //Create the empty string that will contain the allowed chars
  String _allowedChars = "";

  //Put chars on the allowed ones based on the input values
  _allowedChars += (_isWithLetters ? _lowerCaseLetters : '');
  _allowedChars += (_isWithUppercase ? _upperCaseLetters : '');
  _allowedChars += (_isWithNumbers ? _numbers : '');
  _allowedChars += (_isWithSpecial ? _special : '');

  int i = 0;
  String _result = "";

  //Create password
  while (i < _numberCharPassword.round()) {
    //Get random int
    int randomInt = Random.secure().nextInt(_allowedChars.length);
    //Get random char and append it to the password
    _result += _allowedChars[randomInt];
    i++;
  }

  return _result;
}