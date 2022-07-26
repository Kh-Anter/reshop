import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  bool isLoading = false;
  String _verificationId;
  String otpCode;
  bool signinWithphone = false;
  String _userId;
  String _token;
  String _refreshToken;
  DateTime _expiryDate;
  // Timer _authTimer;

  changeLoadingState(bool newValue) {
    isLoading = newValue;
    notifyListeners();
  }

  bool validatEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  Future<bool> hasNetwork() async {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none ||
        result == ConnectivityResult.bluetooth) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkEmailAndPhone(context) async {
    final auth_signin = Provider.of<Auth_SignIn>(context, listen: false);
    bool network = await hasNetwork();
    if (network) {
      bool isEmailExist = false;
      bool isPhoneExist = false;
      const url = "https://reshop-a42f1-default-rtdb.firebaseio.com/users.json";
      try {
        final result = await http.get(Uri.parse(url));
        final data = json.decode(result.body);
        if (data == "" || data == null) {
          return true;
        } else {
          await data.forEach((userId, userData) {
            if (userData["email"] == auth_signin.email_ctr.text) {
              isEmailExist = true;
            }
            if (userData["phoneNum"] == phone_ctr.text) {
              isPhoneExist = true;
            }
          });
          if (!isEmailExist && !isPhoneExist) {
            return true;
          } else {
            if (isEmailExist && !isPhoneExist) {
              mySnackBar(context, 'This email already exist!');
            } else if (isPhoneExist && !isEmailExist) {
              mySnackBar(context, 'This phone number already exist!');
            } else {
              mySnackBar(context, 'Email and phone number already exist!');
            }
            return false;
          }
        }
      } catch (error) {
        mySnackBar(context, 'Some Error Occured. Try Again Later');
        return false;
      }
    } else {
      mySnackBar(context, 'There is no internet connection !');
      return false;
    }
  }

  Future phoneVerification(BuildContext context) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+2${phone_ctr.value.text}',
          codeSent: (String verificationId, int resendToken) {
            changeLoadingState(false);
            _verificationId = verificationId;
            Navigator.of(context).pushNamed(Verification.routeName);
            print("-------------code sent");
          },
          verificationCompleted: (PhoneAuthCredential credential) {
            if (!signinWithphone) {
              otp_ctr.text = credential.smsCode.toString();
              signUpWithPhoneAuthCred(context);
              print("-----------verification done");
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            changeLoadingState(false);
            mySnackBar(context, 'Some Error Occured. Try Again Later');
          },
          timeout: const Duration(seconds: 60),
          codeAutoRetrievalTimeout: (_) {});
    } catch (_) {
      changeLoadingState(false);
      mySnackBar(context, 'Some Error Occured. Try Again Later');
    }
  }

  void signUpWithPhoneAuthCred(context) async {
    final auth_signin = Provider.of<Auth_SignIn>(context, listen: false);
    signinWithphone = true;
    try {
      var auth = FirebaseAuth.instance;
      AuthCredential _phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: otp_ctr.text);
      UserCredential _userCredential =
          await auth.createUserWithEmailAndPassword(
              email: auth_signin.email_ctr.text,
              password: auth_signin.password_ctr.text);
      await _userCredential.user.updateDisplayName(name_ctr.text);
      _userId = await auth.currentUser.uid;
      _userCredential.user.linkWithCredential(_phoneAuthCredential);
      await auth_signin
          .signIn()
          .then((value) => addUserDataToFirebase(auth_signin.email_ctr.text));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Home()),
          ModalRoute.withName(Home.routeName));
    } on FirebaseAuthException catch (e) {
      mySnackBar(context, 'Some Error Occured. Try Again Later');
      print("------------error : ${e.message}");
    }
    changeLoadingState(false);
  }

  Future<void> addUserDataToFirebase(email) async {
    String url = "https://reshop-a42f1-default-rtdb.firebaseio.com/users.json";
    try {
      var result = await http.post(Uri.parse(url),
          body: json.encode({
            "name": name_ctr.text,
            "uid": _userId,
            "email": email,
            "phoneNum": phone_ctr.text,
          }));
    } catch (e) {
      print(e);
    }
  }

  mySnackBar(BuildContext ctx, String text) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(text)));
  }

  //   Fluttertoast.showToast(
  //       msg: "email verifcation link has sent to your email.");
  // }

}
