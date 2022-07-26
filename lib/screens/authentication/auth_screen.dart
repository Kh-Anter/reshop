import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:reshop/constants.dart';
import 'package:provider/provider.dart';
import 'package:reshop/providers/sigin_up.dart';
import 'package:reshop/size_config.dart';
import 'package:reshop/widgets/auth_widgets/signin_widget.dart';
import 'package:reshop/widgets/auth_widgets/signup_widget.dart';

import '../../providers/auth_signup.dart';

class AuthScreen extends StatefulWidget {
  static String routeName = "/AuthScreen";
  const AuthScreen({Key key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextStyle selected = TextStyle(
      color: Colors.black,
      fontSize: 34,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline);
  TextStyle unselected = TextStyle(
    color: mySecondTextColor,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );
  SizeConfig _sizeConfig = SizeConfig();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth_SignUp>(context);
    final signInOrUp = Provider.of<SignInOrUp>(context);
    _sizeConfig.init(context);

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: authProvider.isLoading,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: _sizeConfig.getProportionateScreenHeight(50),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextButton(
                      onPressed: () {
                        if (!signInOrUp.isSignIn) {
                          signInOrUp.changeAuthState(true);
                        }
                      },
                      child: Text(
                        "Sign in",
                        style: signInOrUp.isSignIn ? selected : unselected,
                      )),
                  TextButton(
                    onPressed: () {
                      if (signInOrUp.isSignIn) {
                        signInOrUp.changeAuthState(false);
                      }
                    },
                    child: Text("Sign up",
                        style: signInOrUp.isSignIn ? unselected : selected),
                  )
                ]),
                signInOrUp.isSignIn ? SigninWidget() : SignupWidget(),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
