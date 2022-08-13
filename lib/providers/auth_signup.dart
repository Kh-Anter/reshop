import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reshop/providers/auth_other.dart';
import 'package:reshop/providers/auth_readwrite.dart';
import 'package:reshop/providers/auth_signin.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:reshop/screens/authentication/verification.dart';
import 'package:reshop/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth_SignUp with ChangeNotifier {
  TextEditingController rePassword_ctr = TextEditingController();
  TextEditingController name_ctr = TextEditingController();
  TextEditingController phone_ctr = TextEditingController();
  TextEditingController otp_ctr = TextEditingController();

  String _verificationId;
  String otpCode;
  bool signinWithphone = false;

  bool validatEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  void signUp(email, context) async {
    final auth_other = Provider.of<Auth_other>(context, listen: false);
    bool hasInternet = await auth_other.hasNetwork();
    if (hasInternet) {
      // final auth = FirebaseAuth.instance;
      // final List<String> otherMethod =
      //     await auth.fetchSignInMethodsForEmail(email);
      //  //   auth.
      // if (otherMethod == null) {
      //   phoneVerification(context);
      // } else {
      //   mySnackBar(context, "Email address already exist!");
      // }
      bool isExist =
          await auth_other.IsEmailAndPhoneExist(email, phone_ctr.text, context);

      if (!isExist) phoneVerification(context);
    } else {
      mySnackBar(context, "No internet connection !");
    }
  }
  // Future<bool> checkEmailAndPhone(context) async {
  //   final auth_signin = Provider.of<Auth_SignIn>(context, listen: false);
  //   bool network = await Auth_other().hasNetwork();
  //   if (network) {
  //     bool isEmailExist = false;
  //     bool isPhoneExist = false;
  //     const url = "https://reshop-a42f1-default-rtdb.firebaseio.com/users.json";
  //     try {
  //       final result = await http.get(Uri.parse(url));
  //       final data = json.decode(result.body);
  //       if (data == "" || data == null) {
  //         return true;
  //       } else {
  //         await data.forEach((userId, userData) {
  //           if (userData["email"] == auth_signin.email_ctr.text) {
  //             isEmailExist = true;
  //           }
  //           if (userData["phoneNum"] == phone_ctr.text) {
  //             isPhoneExist = true;
  //           }
  //         });
  //         if (!isEmailExist && !isPhoneExist) {
  //           return true;
  //         } else {
  //           if (isEmailExist && !isPhoneExist) {
  //             mySnackBar(context, 'This email already exist!');
  //           } else if (isPhoneExist && !isEmailExist) {
  //             mySnackBar(context, 'This phone number already exist!');
  //           } else {
  //             mySnackBar(context, 'Email and phone number already exist!');
  //           }
  //           return false;
  //         }
  //       }
  //     } catch (error) {
  //       mySnackBar(context, 'Some Error Occured. Try Again Later');
  //       return false;
  //     }
  //   } else {
  //     mySnackBar(context, 'There is no internet connection !');
  //     return false;
  //   }
  // }

  Future phoneVerification(BuildContext context) async {
    final auth_other = Provider.of<Auth_other>(context, listen: false);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+2${phone_ctr.value.text}',
          codeSent: (String verificationId, int resendToken) {
            auth_other.changeLoadingState(false);
            _verificationId = verificationId;
            Navigator.of(context).pushNamed(Verification.routeName);
            print("-------------code sent");
          },
          verificationCompleted: (PhoneAuthCredential credential) {
            otp_ctr.text = credential.smsCode.toString();
            print("-----------verification done");
          },
          verificationFailed: (FirebaseAuthException e) {
            auth_other.changeLoadingState(false);
            mySnackBar(context, 'Some Error Occured. Try Again Later');
          },
          timeout: const Duration(seconds: 60),
          codeAutoRetrievalTimeout: (_) {});
    } catch (_) {
      auth_other.changeLoadingState(false);
      mySnackBar(context, 'Some Error Occured. Try Again Later');
    }
  }

  void signUpWithPhoneAuthCred(context) async {
    final auth_signin = Provider.of<Auth_SignIn>(context, listen: false);
    final auth_other = Provider.of<Auth_other>(context, listen: false);
    signinWithphone = true;
    try {
      var auth = FirebaseAuth.instance;
      AuthCredential _phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: otp_ctr.text);

      UserCredential _userCredential =
          await auth.createUserWithEmailAndPassword(
              email: auth_signin.email_ctr.text,
              password: auth_signin.password_ctr.text);
      await auth.signInWithEmailAndPassword(
          email: auth_signin.email_ctr.text,
          password: auth_signin.password_ctr.text);
      await _userCredential.user.updateDisplayName(name_ctr.text);
      await _userCredential.user.updatePhoneNumber(_phoneAuthCredential);
      await Auth_ReadWrite().addUserDataToFirebase(phone_ctr.text);
      await Auth_ReadWrite().addUserToFirestore(
          auth.currentUser.uid, name_ctr.text, auth.currentUser.email);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Home()),
          ModalRoute.withName(Home.routeName));
    } on FirebaseAuthException catch (e) {
      print("--------the error : $e");
      mySnackBar(context, 'Some Error Occured. Try Again Later');
      print("------------error : ${e.message}");
      auth_other.changeLoadingState(false);
    }
    auth_other.changeLoadingState(false);
  }

  mySnackBar(BuildContext ctx, String text) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(text)));
  }
}
