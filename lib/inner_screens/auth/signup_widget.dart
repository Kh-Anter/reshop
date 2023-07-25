import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/models/validations.dart';
import 'package:reshop/providers/authentication/auth_signin.dart';
import 'package:reshop/providers/authentication/auth_signup.dart';
import 'package:reshop/providers/authentication/auth_other.dart';
import 'package:reshop/consts/size_config.dart';
import 'package:reshop/widgets/mytextfield.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({Key? key}) : super(key: key);

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  Object ob = Object();

  late EmailAuth emailAuth;

  @override
  void initState() {
    emailAuth = EmailAuth(sessionName: "Sample session");
    super.initState();
  }

  SizeConfig sizeConfig = SizeConfig();
  var globalKey = GlobalKey<FormState>();
  String nameError = "";
  String emailError = "";
  String passError = "";
  String repassError = "";
  String phoneError = "";

  @override
  Widget build(BuildContext context) {
    final authSignup = Provider.of<AuthSignUp>(context);
    final authSignin = Provider.of<AuthSignIn>(context, listen: false);
    final authOther = Provider.of<AuthOther>(context, listen: false);
    sizeConfig.init(context);
    print("--------------rebuild ");

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: sizeConfig.getProportionateScreenHeight(30),
          ),
          Text(
            "Please fill the information below",
            style: TextStyle(color: mySecondTextColor),
          ),
          SizedBox(
            height: sizeConfig.getProportionateScreenHeight(10),
          ),
          Form(
            key: globalKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              MyTextField(
                  labelText: "Name",
                  type: TextInputType.name,
                  controller: authSignup.nameCtr,
                  validator: (value) {
                    checkName(name: value.toString());
                  }),
              if (nameError != "") errorText(nameError),
              MyTextField(
                labelText: "Email",
                type: TextInputType.emailAddress,
                controller: authSignin.emailCtr,
                validator: (value) {
                  if (!Validations.validateEmail(value)) {
                    setState(() => emailError = "Invalid Email!");
                  }
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
                controller: authSignup.phoneCtr,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (!Validations.validatePhone(phone: value)) {
                    setState(() => phoneError = "Invalid phone number");
                  }
                },
              ),
              if (phoneError != "") errorText(phoneError),
              MyTextField(
                labelText: "Password",
                type: TextInputType.text,
                controller: authSignin.passwordCtr,
                validator: (value) {
                  setState(() {
                    passError = Validations.validatePasswrd(password: value);
                  });
                },
              ),
              if (passError != "") errorText(passError),
              MyTextField(
                labelText: "Repeat Password",
                type: TextInputType.text,
                controller: authSignup.rePasswordCtr,
                validator: (value) {
                  if (!Validations.validateRepassword(
                      repassword: value,
                      password: authSignin.passwordCtr.value.text)) {
                    setState(() => repassError = "Dissmatch password");
                  }
                },
              ),
              if (repassError != "") errorText(repassError),
              SizedBox(
                height: sizeConfig.getProportionateScreenHeight(20),
              ),
              signupBtn(authSignup, authSignin)
            ]),
          ),
          SizedBox(
            height: sizeConfig.getProportionateScreenHeight(20),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "have account ?",
              style: TextStyle(color: mySecondTextColor),
            ),
            TextButton(
                onPressed: () {
                  authOther.changeAuthState(true);
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

  Widget signupBtn(authSignup, authSignin) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig().getProportionateScreenHeight(60),
      child: ElevatedButton(
        onPressed: () {
          // print("here in on press funtion");
          FocusScope.of(context).unfocus();
          nameError = "";
          emailError = "";
          phoneError = "";
          passError = "";
          repassError = "";

          globalKey.currentState?.validate();
          if (nameError == "" &&
              passError == "" &&
              emailError == "" &&
              phoneError == "" &&
              repassError == "") {
            authSignup.signUpWithEmailAndPhone(context);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(myPrimaryColor),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        ),
        child: Text(
          "Sign up",
          style: TextStyle(fontSize: 16),
        ),
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
