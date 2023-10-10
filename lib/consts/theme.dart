import 'package:flutter/material.dart';

ThemeData theme() {
  MaterialColor myMaterialColor = const MaterialColor(0xFFE33434, {
    50: Color(0xFFE33434),
    100: Color(0xFFE33434),
    200: Color(0xFFE33434),
    300: Color(0xFFE33434),
    400: Color(0xFFE33434),
    500: Color(0xFFE33434),
    600: Color(0xFFE33434),
    700: Color(0xFFE33434),
    800: Color(0xFFE33434),
    900: Color(0xFFE33434)
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
      // brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black)
      // textTheme: TextTheme(
      // headline1: TextStyle(color: mySecondTextColor),
      // headline6: TextStyle(color: mySecondTextColor),
      // ),
      );
}
