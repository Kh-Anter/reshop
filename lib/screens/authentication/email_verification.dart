import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:reshop/constants.dart';

class EmailVerification extends StatefulWidget {
  static const routeName = "/emailVerification";
  const EmailVerification({Key key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  TextEditingController _ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                "Email Verification",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Enter the code sent to your email",
                style: TextStyle(color: mySecondTextColor),
              ),
              SizedBox(
                height: 15,
              ),
              Pinput(
                keyboardType: TextInputType.number,
                onCompleted: (value) {
                  print("-----complete value : $value");
                },
                controller: _ctrl,
              ),
              Row(children: [
                Text(
                  "Didn't Receive Code ?",
                  style: TextStyle(color: mySecondTextColor),
                ),
                TextButton(
                  onPressed: (() {}),
                  child: Text(
                    "Resend",
                  ),
                )
              ]),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    print(_ctrl.value.text);
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
    );
  }
}
