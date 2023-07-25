import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/models/validations.dart';
import 'package:reshop/providers/authentication/auth_other.dart';
// import 'package:reshop/providers/auth_signup.dart';
import 'package:provider/provider.dart';
import 'package:reshop/providers/loading_provider.dart';
import 'package:reshop/screens/authentication/checkInbox.dart';
import 'package:reshop/widgets/loading_widget.dart';
import 'package:reshop/widgets/mytextfield.dart';

class ForgetPassword extends StatefulWidget {
  static const routeName = "/forgetPassword";
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController myctrl = TextEditingController();
  String error = "";
  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<AuthSignUp>(context);
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
                                "Forgot Password",
                                style: TextStyle(
                                    fontSize: 34, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 30),
                              Text(
                                "Please enter your email",
                                style: TextStyle(color: mySecondTextColor),
                              ),
                              SizedBox(height: 10),
                              MyTextField(
                                labelText: "Email",
                                type: TextInputType.emailAddress,
                                controller: myctrl,
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
                              SizedBox(height: 25),
                              nextBtn(context)
                            ]),
                      ),
                    ),
                  ),
                )));
  }

  SizedBox nextBtn(BuildContext context) {
    final loading = Provider.of<LoadingProvider>(context, listen: false);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Selector<AuthOther, bool>(
          selector: (context, authother) => authother.forgotState,
          builder: (ctx, value, _) {
            return ElevatedButton(
              onPressed: value
                  ? () {}
                  : () async {
                      if (!Validations.validateEmail(myctrl.text)) {
                        setState(() {
                          error = "Invalid Email!";
                        });
                      } else {
                        setState(() {
                          error = "";
                        });
                        loading.changeAuthLoading(true);
                        await context
                            .read<AuthOther>()
                            .forgotPassword(myctrl.text, context)
                            .then((value) {
                          if (value) {
                            loading.changeAuthLoading(false);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CheckInbox(email: myctrl.text)),
                                (route) => false);
                          }
                        });
                      }
                    },
              child: value
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Next",
                      style: TextStyle(fontSize: 17),
                    ),
            );
          }),
    );
  }
}
