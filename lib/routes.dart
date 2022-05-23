import 'package:flutter/cupertino.dart';
import './screens/splash_screen.dart';
import './screens/home.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  Home.routeName: (context) => Home(),
};
