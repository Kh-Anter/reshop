import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:reshop/constants.dart';

import 'package:reshop/providers/auth.dart';
import 'package:reshop/screens/authentication/auth_screen.dart';
import 'package:reshop/screens/authentication/forget_password.dart';
import 'package:reshop/size_config.dart';
import './mytextfield.dart';

class SigninWidget extends StatefulWidget {
  const SigninWidget({Key key}) : super(key: key);

  @override
  State<SigninWidget> createState() => _SigninWidgetState();
}

class _SigninWidgetState extends State<SigninWidget> {
  SizeConfig _sizeConfig = SizeConfig();
  bool tap = false;
  var _globalKey = GlobalKey<FormState>();
  String emailError = "";
  String passError = "";

  @override
  Widget build(BuildContext context) {
    _sizeConfig.init(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: _sizeConfig.getProportionateScreenHeight(30),
        ),
        Text(
          "Please fill the information below",
          style: TextStyle(color: mySecondTextColor),
        ),
        SizedBox(
          height: _sizeConfig.getProportionateScreenHeight(10),
        ),
        Form(
            key: _globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextField(
                  labelText: "Email",
                  type: TextInputType.name,
                  controller: authProvider.email_ctr,
                  validator: (value) {
                    if (!authProvider.validatEmail(value)) {
                      setState(() {
                        emailError = "Invalid Email!";
                      });
                    }
                  },
                ),
                if (emailError != "")
                  Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        emailError,
                        style: TextStyle(color: myPrimaryColor),
                      )),
                MyTextField(
                  labelText: "Password",
                  controller: authProvider.password_ctr,
                  validator: (value) {
                    if (value.toString().length < 6) {
                      setState(() {
                        passError = "To short password!";
                      });
                    }
                  },
                ),
                if (passError != "")
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      passError,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: myPrimaryColor),
                    ),
                  ),
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
                Container(
                  width: double.infinity,
                  height: SizeConfig().getProportionateScreenHeight(60),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          passError = "";
                          emailError = "";
                        });
                        if (_globalKey.currentState.validate()) {
                          print("------------done");
                        }
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(fontSize: 17),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(myPrimaryColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                      )),
                )
              ],
            )),
        SizedBox(
          height: _sizeConfig.getProportionateScreenHeight(30),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
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
            Container(
              width: SizeConfig().getWidth / 3,
              child: Divider(
                indent: 15,
                thickness: 1,
                color: mySecondTextColor,
              ),
            )
          ],
        ),
        SizedBox(
          height: _sizeConfig.getProportionateScreenHeight(30),
        ),
        Container(
          width: double.infinity,
          height: SizeConfig().getProportionateScreenHeight(60),
          child: ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: mySecondTextColor, width: 1)))),
            onPressed: () {},
            label: Text(
              "Sign in with Google",
              style: TextStyle(fontSize: 17, color: mySecondTextColor),
            ),
            icon: Image.asset("assets/images/google_icon.png"),
          ),
        ),
        Container(
          width: double.infinity,
          height: SizeConfig().getProportionateScreenHeight(60),
          margin: EdgeInsets.only(top: 10),
          child: ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: mySecondTextColor, width: 1)))),
            onPressed: () {},
            label: Text(
              "Sign in with Facebook",
              style: TextStyle(fontSize: 17, color: mySecondTextColor),
            ),
            icon: Image.asset("assets/images/facebook_icon.png"),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Don't have account ?",
            style: TextStyle(color: mySecondTextColor),
          ),
          TextButton(
              onPressed: () {
                authProvider.changeStatus();
              },
              child: Text(
                "Sign up now",
                style: TextStyle(
                    color: myPrimaryColor, fontWeight: FontWeight.w400),
              ))
        ]),
      ],
    );
  }
}
