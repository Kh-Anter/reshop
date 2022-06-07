import 'package:flutter/material.dart';
import './constants.dart';

ThemeData theme() {
  MaterialColor myMaterialColor = const MaterialColor(0xFFE33434, const {
    50: const Color(0xFFE33434),
    100: const Color(0xFFE33434),
    200: const Color(0xFFE33434),
    300: const Color(0xFFE33434),
    400: const Color(0xFFE33434),
    500: const Color(0xFFE33434),
    600: const Color(0xFFE33434),
    700: const Color(0xFFE33434),
    800: const Color(0xFFE33434),
    900: const Color(0xFFE33434)
  });

  return ThemeData(
      //primaryColor: myPrimaryColor,

      primarySwatch: myMaterialColor, //Colors.red,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: "SF-Pro-Display",
      appBarTheme: appBarTheme(),
      textTheme: textTheme(),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.white))),
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: ElevatedButton.styleFrom()));
}

// InputDecorationTheme inputDecorationTheme() {
//   OutlineInputBorder outlineInputBorder = OutlineInputBorder(
//     //borderRadius: BorderRadius.circular(28),
//     // borderSide: BorderSide(color: kTextColor),
//     gapPadding: 10,
//   );
//   return InputDecorationTheme(
//       // If  you are using latest version of flutter then lable text and hint text shown like this
//       // if you r using flutter less then 1.20.* then maybe this is not working properly
//       // if we are define our floatingLabelBehavior in our theme then it's not applayed
//       floatingLabelBehavior: FloatingLabelBehavior.always,
//       contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
//       enabledBorder: outlineInputBorder,
//       focusedBorder: outlineInputBorder,
//       border: outlineInputBorder,
//       iconColor: myPrimaryColor);
// }

TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: Colors.black),
    bodyText2: TextStyle(color: Colors.black),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: Colors.white,
    elevation: 0,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline1: TextStyle(color: mySecondTextColor),
      headline6: TextStyle(color: mySecondTextColor),
    ),
  );
}
