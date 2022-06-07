import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/providers/auth.dart';
import 'package:reshop/size_config.dart';
import 'package:reshop/widgets/auth_widgets/mytextfield.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({Key key}) : super(key: key);

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  SizeConfig _sizeConfig = SizeConfig();
  var _globalKey = GlobalKey<FormState>();
  String nameError = "";
  String emailError = "";
  String passError = "";
  String repassError = "";

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    _sizeConfig.init(context);
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            MyTextField(
              labelText: "Name",
              type: TextInputType.name,
              controller: authProvider.name_ctr,
              validator: (value) {
                if (value.toString().trim().isEmpty) {
                  setState(() {
                    nameError = "Enter your name!";
                  });
                }
              },
            ),
            if (nameError != "")
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  nameError,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: myPrimaryColor),
                ),
              ),
            MyTextField(
              labelText: "Email",
              type: TextInputType.emailAddress,
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
                  textAlign: TextAlign.left,
                  style: TextStyle(color: myPrimaryColor),
                ),
              ),
            MyTextField(
              labelText: "Password",
              type: TextInputType.text,
              controller: authProvider.password_ctr,
              validator: (value) {
                if (value.toString().trim().length < 6) {
                  setState(() {
                    passError = "Too short password!";
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
            MyTextField(
              labelText: "Repeat Password",
              type: TextInputType.text,
              controller: authProvider.rePassword_ctr,
              validator: (value) {
                if (authProvider.password_ctr.text != value) {
                  setState(() {
                    repassError = "Dismatch Password";
                  });
                }
              },
            ),
            if (repassError != "")
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  repassError,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: myPrimaryColor),
                ),
              ),
            SizedBox(
              height: _sizeConfig.getProportionateScreenHeight(20),
            ),
            Container(
              ///  signin button
              width: double.infinity,
              height: SizeConfig().getProportionateScreenHeight(60),
              child: ElevatedButton(
                  onPressed: () {
                    nameError = "";
                    emailError = "";
                    passError = "";
                    repassError = "";
                    if (_globalKey.currentState.validate()) {
                      print("--------------- signup done");
                    }
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(fontSize: 17),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(myPrimaryColor),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                  )),
            )
          ]),
        ),
        SizedBox(
          height: _sizeConfig.getProportionateScreenHeight(20),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "have account ?",
            style: TextStyle(color: mySecondTextColor),
          ),
          TextButton(
              onPressed: () {
                authProvider.changeStatus();
              },
              child: Text(
                "Sign in",
                style: TextStyle(
                    color: myPrimaryColor, fontWeight: FontWeight.w400),
              ))
        ]),
      ],
    );
  }
}
