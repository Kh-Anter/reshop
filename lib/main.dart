import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:reshop/firebase_options.dart';
import 'package:reshop/providers/auth_readwrite.dart';
import 'package:reshop/providers/auth_signin.dart';
import 'package:reshop/providers/auth_signup.dart';
import 'package:reshop/providers/auth_isloggedin.dart';
import 'package:reshop/providers/dummyData.dart';
import 'package:reshop/providers/auth_other.dart';
import 'package:reshop/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import '';

Future<void> main() async {
  bool isFirstUse = false;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();

  var result = prefs.getBool("firstUse");
  if (result != null) {
    isFirstUse = result;
  } else {
    isFirstUse = true;
  }
  runApp(MultiProvider(
    builder: (context, child) => MyApp(isFirstUse),
    providers: [
      ChangeNotifierProvider(create: (context) => Auth_IsLoggedin()),
      ChangeNotifierProvider(create: (context) => DummyData()),
      ChangeNotifierProvider(create: (context) => Auth_SignUp()),
      ChangeNotifierProvider(create: (context) => Auth_ReadWrite()),
      ChangeNotifierProvider(create: (context) => Auth_SignIn()),
      ChangeNotifierProvider(create: (context) => Auth_other()),
    ],
  ));
}

class MyApp extends StatelessWidget {
  bool isFirstUse;
  MyApp(this.isFirstUse);

  Widget build(BuildContext context) {
    SizeConfig _size = SizeConfig();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        routes: routes,
        home: isFirstUse
            ? SplashScreen()
            : StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  print("--------------changed --- ");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loading();
                  } else if (snapshot.hasError) {
                    return Center(child: Text("an error occured"));
                  } else if (snapshot.hasData) {
                    return Home();
                  } else {
                    return AuthScreen();
                  }
                }));
  }
}

Widget loading() {
  return Scaffold(
      body: ModalProgressHUD(inAsyncCall: true, child: Container()));
}
