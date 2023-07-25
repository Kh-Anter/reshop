import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/consts/enums.dart';

class MySnackbar {
  static void showSnackBar(
      BuildContext context, String txt, SnackBarType snackType) {
    Color theColor;
    if (snackType == SnackBarType.success) {
      theColor = Colors.teal;
    } else if (snackType == SnackBarType.fail) {
      theColor = myPrimaryColor;
    } else {
      theColor = mySecondTextColor;
    }
    final snackBar = SnackBar(
      content: Text(txt),
      backgroundColor: theColor,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
