import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  TextEditingController email_ctr = TextEditingController();
  TextEditingController password_ctr = TextEditingController();
  TextEditingController rePassword_ctr = TextEditingController();
  TextEditingController name_ctr = TextEditingController();
  TextEditingController phone_ctr = TextEditingController();
  bool signIn = true;

  changeStatus() {
    signIn = !signIn;
    notifyListeners();
  }

  bool validatEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  void validatePass(String pass) {
    if (pass.length < 6) {
      //  return
    }
  }

  String siginInValidate(String email, String pass) {
    if (pass.length < 6) {
      return "invalid password (less than 6 character) ";
    } else {
      return "done";
    }
  }
}
