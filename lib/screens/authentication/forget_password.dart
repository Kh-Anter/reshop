import 'package:flutter/material.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:reshop/widgets/auth_widgets/mytextfield.dart';

class ForgetPassword extends StatefulWidget {
  static const routeName = "/forgetPassword";
  const ForgetPassword({Key key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _myctrl = TextEditingController();
  String error = "";
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              })),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Forgot Password",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Please enter your email to send verification code",
                style: TextStyle(color: mySecondTextColor),
              ),
              SizedBox(
                height: 15,
              ),
              MyTextField(
                labelText: "Email",
                type: TextInputType.emailAddress,
                controller: _myctrl,
              ),
              if (error != "")
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    error,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: myPrimaryColor),
                  ),
                ),
              SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: (() {}),
                child: Text(
                  "Use phone number ?",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      error = "";
                    });
                    if (!provider.validatEmail(_myctrl.text)) {
                      setState(() {
                        error = "Invalid Email!";
                      });
                    } else {
                      print("Done");
                    }
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
