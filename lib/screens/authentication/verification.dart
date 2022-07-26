import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/providers/auth_signup.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Verification extends StatefulWidget {
  static const routeName = "/Verification";
  const Verification({Key key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  Timer _timer;
  bool resend = false;
  int count = 59;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth_SignUp>(context);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              })),
      body: ModalProgressHUD(
        inAsyncCall: authProvider.isLoading,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verification",
                      style:
                          TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Enter the code sent to ${authProvider.phone_ctr.text}",
                      style: TextStyle(color: mySecondTextColor),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Pinput(
                      length: 6,
                      keyboardType: TextInputType.number,
                      controller: authProvider.otp_ctr,
                    ),
                    Container(
                      height: 50,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't Receive Code ?",
                              style: TextStyle(color: mySecondTextColor),
                            ),
                            resend
                                ? TextButton(
                                    onPressed: () {
                                      setState(() {
                                        authProvider.phoneVerification(context);
                                        resend = false;
                                      });
                                    },
                                    child: Text(
                                      "Resend",
                                    ),
                                  )
                                : Text("   0:${count.toString()} s"),
                          ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          authProvider.signUpWithPhoneAuthCred(context);
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = new Timer.periodic(oneSecond, (Timer timer) {
      if (count == 0) {
        setState(() {
          timer.cancel();
          resend = true;
        });
      } else if (count >= 1) {
        setState(() {
          count--;
        });
      }
    });
  }
}
