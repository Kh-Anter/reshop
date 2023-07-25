import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier {
  bool onLandingLoading = false;
  bool authLoading = false;

  changeAuthLoading(bool newState) {
    authLoading = newState;
    notifyListeners();
  }

  // changeLandongLoading(bool newState) {
  //   onLandingLoading = newState;
  //   notifyListeners();
  // }
}
