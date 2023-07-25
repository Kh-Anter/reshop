import 'package:flutter/cupertino.dart';
import 'package:reshop/models/product.dart';
import 'package:reshop/screens/address.dart';
import 'package:reshop/screens/authentication/checkInbox.dart';
import 'package:reshop/screens/checkout.dart';
import 'package:reshop/screens/favourites.dart';
import 'package:reshop/screens/orders.dart';
import 'package:reshop/screens/search_screen.dart';
import 'package:reshop/screens/editOrAdd_address.dart';
import 'package:reshop/screens/setting_screen.dart';
import 'package:reshop/widgets/hero_images.dart';
import '../screens/product_details.dart';
import '../screens/authentication/verification.dart';
import '../screens/splash_screen.dart';
import '../screens/home.dart';
import '../screens/authentication/auth_screen.dart';
import '../screens/authentication/forget_password.dart';
import '../screens/category_screen/category_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (_) => SplashScreen(),
  Home.routeName: (_) => Home(),
  AuthScreen.routeName: (_) => AuthScreen(),
  Verification.routeName: (_) => Verification(),
  ForgetPassword.routeName: (_) => ForgetPassword(),
  ProductDetails.routeName: (context) => ProductDetails(
      product: ModalRoute.of(context)!.settings.arguments as Product),
  CategoryScreen.routeName: (_) => CategoryScreen(),
  SearchScreen.routeName: (_) => SearchScreen(),
  FavouritesScreen.routeName: (_) => FavouritesScreen(),
  CheckOut.routeName: (_) => CheckOut(),
  Orders.routeName: (_) => Orders(),
  Address.routeName: (_) => Address(),
  EditOrAddAddress.routeName: (_) => EditOrAddAddress(),
  HeroImages.routeName: (context) => HeroImages(
        productImages:
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
      ),
  CheckInbox.routeName: (context) =>
      CheckInbox(email: ModalRoute.of(context)!.settings.arguments as String),
  SettingScreen.routeName: (context) => SettingScreen(),
};
