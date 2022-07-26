import 'package:flutter/cupertino.dart';

class SignInOrUp with ChangeNotifier {
  bool isSignIn = true;

  changeAuthState(bool isSigIn) {
    this.isSignIn = isSigIn;
    notifyListeners();
  }
}
