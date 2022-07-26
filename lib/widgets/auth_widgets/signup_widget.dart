import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/providers/auth_signin.dart';
import 'package:reshop/providers/auth_signup.dart';
import 'package:reshop/providers/sigin_up.dart';
import '/screens/authentication/verification.dart';
import 'package:reshop/size_config.dart';
import 'package:reshop/widgets/auth_widgets/mytextfield.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({Key key}) : super(key: key);

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  Object ob = new Object();

  EmailAuth emailAuth;

  @override
  void initState() {
    emailAuth = new EmailAuth(sessionName: "Sample session");
    super.initState();
  }

  SizeConfig _sizeConfig = SizeConfig();
  var _globalKey = GlobalKey<FormState>();
  String nameError = "";
  String emailError = "";
  String passError = "";
  String repassError = "";
  String phoneError = "";

  @override
  Widget build(BuildContext context) {
    final _auth_signup = Provider.of<Auth_SignUp>(context);
    final _auth_signin = Provider.of<Auth_SignIn>(context, listen: false);
    final _signInOrUp = Provider.of<SignInOrUp>(context, listen: false);
    _sizeConfig.init(context);

    return Center(
      child: Column(
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
                  controller: _auth_signup.name_ctr,
                  validator: (value) {
                    checkName(name: value.toString());
                  }),
              if (nameError != "") errorText(nameError),
              MyTextField(
                labelText: "Email",
                type: TextInputType.emailAddress,
                controller: _auth_signin.email_ctr,
                validator: (value) {
                  checkEmai(email: value);
                },
              ),
              if (emailError != "") errorText(emailError),
              MyTextField(
                labelText: "Phone number",
                maxLength: 11,
                prefex: Text(
                  "+2 ",
                  style: TextStyle(fontSize: 14),
                ),
                type: TextInputType.phone,
                controller: _auth_signup.phone_ctr,
                validator: (value) {
                  checkPhone(phone: value);
                },
              ),
              if (phoneError != "") errorText(phoneError),
              MyTextField(
                labelText: "Password",
                type: TextInputType.text,
                controller: _auth_signin.password_ctr,
                validator: (value) {
                  checkPasswrd(password: value);
                },
              ),
              if (passError != "") errorText(passError),
              MyTextField(
                labelText: "Repeat Password",
                type: TextInputType.text,
                controller: _auth_signup.rePassword_ctr,
                validator: (value) {
                  checkRepassword(
                      repassword: value,
                      password: _auth_signin.password_ctr.value.text);
                },
              ),
              if (repassError != "") errorText(repassError),
              SizedBox(
                height: _sizeConfig.getProportionateScreenHeight(20),
              ),
              Container(
                ///  signin button
                width: double.infinity,
                height: SizeConfig().getProportionateScreenHeight(60),
                child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      nameError = "";
                      emailError = "";
                      phoneError = "";
                      passError = "";
                      repassError = "";
                      _globalKey.currentState.validate();
                      if (nameError == "" &&
                          passError == "" &&
                          emailError == "" &&
                          phoneError == "" &&
                          repassError == "") {
                        _auth_signup.changeLoadingState(true);
                        _auth_signup.checkEmailAndPhone(context).then((value) {
                          if (value) {
                            _auth_signup.phoneVerification(context);
                          } else {
                            _auth_signup.changeLoadingState(false);
                          }
                        });
                      }
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(myPrimaryColor),
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
                  _signInOrUp.changeAuthState(true);
                },
                child: Text(
                  "Sign in",
                  style: TextStyle(
                      color: myPrimaryColor, fontWeight: FontWeight.w400),
                ))
          ]),
        ],
      ),
    );
  }

  void checkName({name}) {
    if (name.toString().trim().isEmpty) {
      setState(() {
        nameError = "Enter your name!";
      });
    }
  }

  void checkEmai({email}) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      setState(() {
        emailError = "Invalid Email!";
      });
    }
  }

  void checkPhone({phone}) {
    if (phone.length != 11) {
      setState(() {
        phoneError = "Invalid phone number!";
      });
    } else if (!phone.toString().startsWith("01")) {
      setState(() {
        phoneError = "Invalid phone number!";
      });
    }
  }

  void checkPasswrd({password}) {
    if (password.toString().trim().isEmpty) {
      setState(() {
        passError = "Enter a password!";
      });
    } else if (password.toString().trim().length < 6) {
      setState(() {
        passError = "Too short password!";
      });
    }
  }

  void checkRepassword({repassword, password}) {
    if (repassword.toString().trim() != password.toString().trim()) {
      setState(() {
        repassError = "dismatch password";
      });
    }
  }

  Widget errorText(String errorText) {
    return Padding(
      padding: EdgeInsets.only(left: 20, bottom: 3),
      child: Text(
        errorText,
        textAlign: TextAlign.left,
        style: TextStyle(color: myPrimaryColor),
      ),
    );
  }
}
