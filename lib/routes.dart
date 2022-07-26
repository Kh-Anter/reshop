import 'package:flutter/cupertino.dart';
import 'package:reshop/screens/favourites.dart';
import 'package:reshop/screens/search_screen.dart';
import './screens/product_details.dart';
import 'screens/authentication/verification.dart';
import './screens/splash_screen.dart';
import './screens/home.dart';
import './screens/authentication/auth_screen.dart';
import './screens/authentication/forget_password.dart';
import 'screens/category_screen/category_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  Home.routeName: (context) => Home(),
  AuthScreen.routeName: (context) => AuthScreen(),
  Verification.routeName: (context) => Verification(),
  ForgetPassword.routeName: (context) => ForgetPassword(),
  ProductDetails.routeName: (context) => ProductDetails(),
  CategoryScreen.routeName: (context) => CategoryScreen(),
  SearchScreen.routeName: (context) => SearchScreen(),
  FavouritesScreen.routeName: (context) => FavouritesScreen(),
};
