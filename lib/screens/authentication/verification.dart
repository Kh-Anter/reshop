import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:reshop/consts/constants.dart';
import 'package:provider/provider.dart';
import 'package:reshop/providers/authentication/auth_signup.dart';
import 'package:reshop/providers/loading_provider.dart';
import 'package:reshop/widgets/loading_widget.dart';

class Verification extends StatefulWidget {
  static const routeName = "/Verification";
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthSignUp>(context);
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: Selector<LoadingProvider, bool>(
            selector: (context, loadingProvider) => loadingProvider.authLoading,
            builder: (context, value, child) => LoadingWidget(
                  isLoading: value,
                  child: SafeArea(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Verification",
                                style: TextStyle(
                                    fontSize: 34, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Enter the code sent to ${authProvider.phoneCtr.text}",
                                style: TextStyle(color: mySecondTextColor),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Pinput(
                                length: 6,
                                keyboardType: TextInputType.number,
                                controller: authProvider.otpCtr,
                              ),
                              SizedBox(
                                height: 50,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Didn't Receive Code ?",
                                        style:
                                            TextStyle(color: mySecondTextColor),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            authProvider
                                                .phoneVerification(context);
                                          });
                                        },
                                        child: Text(
                                          "Resend",
                                        ),
                                      )
                                    ]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    authProvider.submitOtpCode(context);
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
                )));
  }
}
