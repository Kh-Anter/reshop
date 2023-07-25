import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/models/validations.dart';
import 'package:reshop/providers/authentication/auth_signin.dart';
import 'package:reshop/providers/authentication/auth_other.dart';
import 'package:reshop/screens/authentication/forget_password.dart';
import 'package:reshop/consts/size_config.dart';
import '../../widgets/mytextfield.dart';

class SigninWidget extends StatefulWidget {
  const SigninWidget({Key? key}) : super(key: key);

  @override
  State<SigninWidget> createState() => _SigninWidgetState();
}

class _SigninWidgetState extends State<SigninWidget> {
  SizeConfig sizeConfig = SizeConfig();
  bool tap = false;
  var globalKey = GlobalKey<FormState>();
  String emailError = "";
  String passError = "";

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    final authSignin = Provider.of<AuthSignIn>(context);
    final authOther = Provider.of<AuthOther>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: sizeConfig.getProportionateScreenHeight(30)),
        Text(
          "Please fill the information below",
          style: TextStyle(color: mySecondTextColor),
        ),
        SizedBox(height: sizeConfig.getProportionateScreenHeight(10)),
        Form(
            key: globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextField(
                  labelText: "Email",
                  type: TextInputType.name,
                  controller: authSignin.emailCtr,
                  parentState: setState,
                  validator: (value) {
                    if (!Validations.validateEmail(value)) {
                      setState(() => emailError = "Invalid Email!");
                    }
                  },
                ),
                if (emailError.isNotEmpty) error(emailError),
                MyTextField(
                  labelText: "Password",
                  controller: authSignin.passwordCtr,
                  parentState: setState,
                  validator: (value) {
                    setState(() => passError =
                        Validations.validatePasswrd(password: value));
                  },
                ),
                if (passError.isNotEmpty) error(passError),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgetPassword()));
                    },
                    child: Text(
                      "Forgot Password ?",
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            )),
        SizedBox(height: sizeConfig.getProportionateScreenHeight(10)),
        signInBtn(authSignin),
        SizedBox(height: sizeConfig.getProportionateScreenHeight(30)),
        orSigninWith(),
        SizedBox(
          height: sizeConfig.getProportionateScreenHeight(30),
        ),
        signinWithGoogle(context),
        signinWithFacebook(context),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Don't have account ?",
            style: TextStyle(color: mySecondTextColor),
          ),
          TextButton(
              onPressed: () => authOther.changeAuthState(false),
              child: Text(
                "Sign up now",
                style: TextStyle(
                    color: myPrimaryColor, fontWeight: FontWeight.w400),
              ))
        ]),
      ],
    );
  }

  Row orSigninWith() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: SizeConfig().getWidth / 3,
          child: Divider(
            endIndent: 15,
            thickness: 1,
            color: mySecondTextColor,
          ),
        ),
        Text(
          'Or Sign in With',
          style: TextStyle(color: mySecondTextColor),
        ),
        SizedBox(
          width: SizeConfig().getWidth / 3,
          child: Divider(
            indent: 15,
            thickness: 1,
            color: mySecondTextColor,
          ),
        )
      ],
    );
  }

  Widget signInBtn(authSignin) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig().getProportionateScreenHeight(60),
      child: ElevatedButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();
          setState(() {
            passError = "";
            emailError = "";
            globalKey.currentState?.validate();
            if (emailError == "" && passError == "") {
              authSignin.signIn(context);
            }
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(myPrimaryColor),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        ),
        child: Text(
          "Sign in",
          style: TextStyle(fontSize: 17),
        ),
      ),
      //  ),
    );
  }

  Container signinWithGoogle(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig().getProportionateScreenHeight(60),
      child: ElevatedButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: mySecondTextColor, width: 1)))),
        onPressed: () {
          AuthSignIn().signInWithGoogle(context);
        },
        label: Text(
          "Sign in with Google",
          style: TextStyle(fontSize: 17, color: mySecondTextColor),
        ),
        icon: Image.asset("assets/images/google_icon.png"),
      ),
    );
  }

  Container signinWithFacebook(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig().getProportionateScreenHeight(60),
      margin: EdgeInsets.only(top: 10),
      child: ElevatedButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: mySecondTextColor, width: 1)))),
        onPressed: () {
          // _auth_other.changeLoadingState(true);
          AuthSignIn().signInWithFacebook(context);
          // _auth_other.changeLoadingState(false);
        },
        label: Text(
          "Sign in with Facebook",
          style: TextStyle(fontSize: 17, color: mySecondTextColor),
        ),
        icon: Image.asset("assets/images/facebook_icon.png"),
      ),
    );
  }

  Widget error(txt) {
    return Padding(
        padding: EdgeInsets.only(left: 15),
        child: Text(
          txt,
          style: TextStyle(color: myPrimaryColor),
        ));
  }
}
