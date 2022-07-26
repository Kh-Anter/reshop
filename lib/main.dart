import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:reshop/firebase_options.dart';
import 'package:reshop/providers/auth_signin.dart';
import 'package:reshop/providers/auth_signup.dart';
import 'package:reshop/providers/auth_isloggedin.dart';
import 'package:reshop/providers/dummyData.dart';
import 'package:reshop/providers/sigin_up.dart';
import 'package:reshop/theme.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/category_screen/category_screen.dart';
import './screens/authentication/auth_screen.dart';
import 'screens/authentication/verification.dart';
import './screens/authentication/forget_password.dart';
import './screens/product_details.dart';
import './screens/home.dart';
import './screens/splash_screen.dart';
import './size_config.dart';
import './routes.dart';

import './providers/dummyData.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    builder: (context, child) => MyApp(),
    providers: [
      ChangeNotifierProvider(create: (context) => Auth_IsLoggedin()),
      ChangeNotifierProvider(create: (context) => DummyData()),
      ChangeNotifierProvider(create: (context) => Auth_SignUp()),
      ChangeNotifierProvider(create: (context) => Auth_SignIn()),
      ChangeNotifierProvider(create: (context) => SignInOrUp()),
    ],
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isloggedin = Provider.of<Auth_IsLoggedin>(context);
    SizeConfig _size = SizeConfig();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        routes: routes,
        home: FutureBuilder(
            future: isloggedin.isFirstUse(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loading(); //CircularProgressIndicator();
              } else {
                if (snapshot.data) {
                  return SplashScreen();
                } else {
                  return FutureBuilder(
                      future: isloggedin.isLoggedIn(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return loading(); // CircularProgressIndicator();
                        } else {
                          if (snapshot.data) {
                            return Home();
                          } else {
                            return AuthScreen();
                          }
                        }
                      });
                }
              }
            }));
  }

  Widget loading() {
    return Scaffold(
        body: ModalProgressHUD(inAsyncCall: true, child: Container()));
  }
}
