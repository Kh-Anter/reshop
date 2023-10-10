import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reshop/consts/enums.dart';
import 'package:reshop/providers/authentication/auth_other.dart';
import 'package:reshop/providers/authentication/auth_signin.dart';
import 'package:reshop/providers/loading_provider.dart';
import 'package:reshop/screens/authentication/verification.dart';
import 'package:reshop/screens/home.dart';
import 'package:reshop/service/connect_firebase.dart';
import 'package:reshop/widgets/mySnackBar.dart';

class AuthSignUp with ChangeNotifier {
  TextEditingController rePasswordCtr = TextEditingController();
  TextEditingController nameCtr = TextEditingController();
  TextEditingController phoneCtr = TextEditingController();
  TextEditingController otpCtr = TextEditingController();

  late String _verificationId;
  late String otpCode;

  void signUpWithEmailAndPhone(context) async {
    var loading = Provider.of<LoadingProvider>(context, listen: false);
    final authSignin = Provider.of<AuthSignIn>(context, listen: false);
    loading.changeAuthLoading(true);
    otpCtr.text = "";
    bool emailRegistered = await AuthOther.isEmailAlreadyRegistered(
        authSignin.emailCtr.text.toString());
    print("--------->> is email registered : $emailRegistered");
    if (emailRegistered) {
      MySnackbar.showSnackBar(context,
          "Email address already registere before !", SnackBarType.fail);
      loading.changeAuthLoading(false);
      return;
    }
    bool phoneRegistered = await AuthOther.isPhoneNumberAlreadyRegistered(
        phoneCtr.text.toString());
    print("--------->> is phone registered : $phoneRegistered");
    if (phoneRegistered) {
      MySnackbar.showSnackBar(context,
          "Phone number already registere before !", SnackBarType.fail);
      loading.changeAuthLoading(false);
      return;
    }
    await phoneVerification(context);
  }

  Future phoneVerification(BuildContext context) async {
    var loading = Provider.of<LoadingProvider>(context, listen: false);
    print("----- enter verification");
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+2${phoneCtr.value.text}',
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
            Navigator.of(context).pushNamed(Verification.routeName);
            loading.changeAuthLoading(false);
          },
          verificationCompleted: (PhoneAuthCredential credential) {
            otpCtr.text = credential.smsCode.toString();
          },
          verificationFailed: (FirebaseAuthException e) {
            MySnackbar.showSnackBar(context, e.code, SnackBarType.fail);
            loading.changeAuthLoading(false);
          },
          timeout: const Duration(seconds: 120),
          codeAutoRetrievalTimeout: (verificationId) {});
    } catch (e) {
      MySnackbar.showSnackBar(context, e.toString(), SnackBarType.fail);
      loading.changeAuthLoading(false);
    }
  }

  // signup with email , then link email with phone credintial .
  void submitOtpCode(context) async {
    var loading = Provider.of<LoadingProvider>(context, listen: false);
    final authSignin = Provider.of<AuthSignIn>(context, listen: false);
    loading.changeAuthLoading(true);
    var auth = FirebaseAuth.instance;
    try {
      var phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: otpCtr.text);
      await auth.createUserWithEmailAndPassword(
          email: authSignin.emailCtr.text,
          password: authSignin.passwordCtr.text);
      await auth.currentUser!.linkWithCredential(phoneAuthCredential);
      await auth.signInWithEmailAndPassword(
          email: authSignin.emailCtr.text,
          password: authSignin.passwordCtr.text);
      await auth.currentUser!.updateDisplayName(nameCtr.text);
      ConnectFirebase.realtimeWrite(
        path: "users",
        uid: auth.currentUser!.uid,
        data: {
          "name": nameCtr.text.toString(),
          "email": authSignin.emailCtr.text.toString(),
          "phoneNum": phoneCtr.text.toString()
        },
      );
      loading.changeAuthLoading(false);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Home()),
          ModalRoute.withName(Home.routeName));
    } catch (e) {
      loading.changeAuthLoading(false);
      MySnackbar.showSnackBar(context, e.toString(), SnackBarType.fail);
    }
  }
}
