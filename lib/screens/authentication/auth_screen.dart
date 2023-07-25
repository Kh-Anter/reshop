import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:provider/provider.dart';
import 'package:reshop/providers/authentication/auth_other.dart';
import 'package:reshop/consts/size_config.dart';
import 'package:reshop/providers/loading_provider.dart';
import 'package:reshop/widgets/loading_widget.dart';
import '../../inner_screens/auth/signin_widget.dart';
import '../../inner_screens/auth/signup_widget.dart';

class AuthScreen extends StatefulWidget {
  static String routeName = "/AuthScreen";
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  SizeConfig sizeConfig = SizeConfig();

  @override
  Widget build(BuildContext context) {
    final authOther = Provider.of<AuthOther>(context);
    sizeConfig.init(context);

    return Scaffold(
      body: Selector<LoadingProvider, bool>(
        selector: (context, loadingProvider) => loadingProvider.authLoading,
        builder: (context, value, child) => LoadingWidget(
          isLoading: value,
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: sizeConfig.getProportionateScreenHeight(50)),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    TextButton(
                        onPressed: () {
                          if (!authOther.isSignIn) {
                            authOther.changeAuthState(true);
                          }
                        },
                        child: Text(
                          "Sign in",
                          style: authOther.isSignIn
                              ? selectedTitleStyle
                              : unselectedTitleStyle,
                        )),
                    TextButton(
                      onPressed: () {
                        if (authOther.isSignIn) {
                          authOther.changeAuthState(false);
                        }
                      },
                      child: Text("Sign up",
                          style: authOther.isSignIn
                              ? unselectedTitleStyle
                              : selectedTitleStyle),
                    )
                  ]),
                  authOther.isSignIn ? SigninWidget() : SignupWidget(),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
