import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reshop/constants.dart';
import 'package:provider/provider.dart';
import 'package:reshop/size_config.dart';
import 'package:reshop/widgets/auth_widgets/signin_widget.dart';
import 'package:reshop/widgets/auth_widgets/signup_widget.dart';

import '../../providers/auth.dart';

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
  );
  TextStyle unselected = TextStyle(
    color: mySecondTextColor,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );
  SizeConfig _sizeConfig = SizeConfig();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    _sizeConfig.init(context);

    return Scaffold(
      body: SafeArea(
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
                      if (!authProvider.signIn) {
                        authProvider.changeStatus();
                      }
                    },
                    child: Text(
                      "Sign in",
                      style: authProvider.signIn ? selected : unselected,
                    )),
                TextButton(
                  onPressed: () {
                    if (authProvider.signIn) {
                      authProvider.changeStatus();
                    }
                  },
                  child: Text("Sign up",
                      style: authProvider.signIn ? unselected : selected),
                )
              ]),
              authProvider.signIn ? SigninWidget() : SignupWidget(),
            ]),
          ),
        ),
      ),
    );
  }
}
