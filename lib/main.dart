import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:reshop/firebase_options.dart';

import './consts/constants.dart';
import './providers/authentication/auth_readwrite.dart';
import './providers/authentication/auth_signin.dart';
import './providers/authentication/auth_signup.dart';
import './providers/categories.dart';
import './providers/chart/cart_provider.dart';
import './providers/chart/total.dart';
import './providers/dummyData.dart';
import './providers/authentication/auth_other.dart';
import './providers/favourites.dart';
import './providers/loading_provider.dart';
import './providers/onboarding.dart';
import './providers/orders_provider.dart';
import './providers/root_provider.dart';
import './screens/authentication/auth_screen.dart';
import './screens/home.dart';
import './screens/splash_screen.dart';
import './consts/theme.dart';
import './consts/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]).then((_) {
    runApp(MultiProvider(
      builder: (context, child) => MyApp(),
      providers: [
        ChangeNotifierProvider(create: (context) => RootProvider()),
        ChangeNotifierProvider(create: (context) => DummyData()),
        ChangeNotifierProvider(create: (context) => AuthSignUp()),
        ChangeNotifierProvider(create: (context) => AuthReadWrite()),
        ChangeNotifierProvider(create: (context) => AuthSignIn()),
        ChangeNotifierProvider(create: (context) => AuthOther()),
        ChangeNotifierProvider(create: (context) => FavouritesProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => TotalCartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => OnBoardingProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => LoadingProvider()),
      ],
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final Future isFirstTime = isFirstUse();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        routes: routes,
        home: FutureBuilder(
            future: isFirstTime,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loading();
              } else {
                return StreamBuilder(
                    stream: FirebaseAuth.instance
                        .authStateChanges()
                        .handleError((error) {
                      if (error is FirebaseAuthException &&
                          error.code == 'user-not-found') {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => AuthScreen()),
                          ModalRoute.withName(AuthScreen.routeName),
                        );
                      }
                    }),
                    builder: (context, streamSnapshot) {
                      if (snapshot.data == true) {
                        return SplashScreen();
                      } else if (snapshot.data == false &&
                          FirebaseAuth.instance.currentUser == null) {
                        return AuthScreen();
                      } else if (streamSnapshot.hasData) {
                        return Home();
                      } else {
                        return loading();
                      }
                    });
              }
            }));
  }

  Widget loading() {
    return Scaffold(
        body: SafeArea(
      child: Center(
          child: Container(
        color: Colors.black.withOpacity(0.1),
        child: Center(child: SpinKitFadingCube(color: myPrimaryColor)),
      )),
    ));
  }

  Future<bool> isFirstUse() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    final prefs = await SharedPreferences.getInstance();
    var result = prefs.getBool("firstUse");
    if (result != null) {
      return false;
    } else {
      return true;
    }
  }
}
