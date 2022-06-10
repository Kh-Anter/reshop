import 'package:flutter/cupertino.dart';
import './screens/product_details.dart';
import './screens/authentication/email_verification.dart';
import './screens/splash_screen.dart';
import './screens/home.dart';
import './screens/authentication/auth_screen.dart';
import './screens/authentication/forget_password.dart';
import './screens/categories_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  Home.routeName: (context) => Home(),
  AuthScreen.routeName: (context) => AuthScreen(),
  EmailVerification.routeName: (context) => EmailVerification(),
  ForgetPassword.routeName: (context) => ForgetPassword(),
  ProductDetails.routeName: (context) => ProductDetails(),
  CategoriesScreen.routeName: (context) => CategoriesScreen(),
};
