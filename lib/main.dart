import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:reshop/providers/auth.dart';
import 'package:reshop/providers/dummyData.dart';
import 'package:reshop/theme.dart';

import 'screens/category_screen/category_screen.dart';
import './screens/authentication/auth_screen.dart';
import './screens/authentication/email_verification.dart';
import './screens/authentication/forget_password.dart';
import './screens/product_details.dart';
import './screens/home.dart';
import './screens/splash_screen.dart';
import './size_config.dart';
import './routes.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((_) => DummyData())),
      ChangeNotifierProvider(create: ((_) => AuthProvider()))
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig _size = SizeConfig();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      initialRoute: Home.routeName, //SplashScreen.routeName,
      routes: routes,
    );
  }
}
