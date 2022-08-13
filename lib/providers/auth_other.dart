import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class Auth_other with ChangeNotifier {
  bool isSignIn = true;
  bool isLoading = false;

  changeAuthState(bool isSigIn) {
    this.isSignIn = isSigIn;
    notifyListeners();
  }

  changeLoadingState(bool newValue) {
    isLoading = newValue;
    notifyListeners();
  }

  Future<bool> hasNetwork() async {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none ||
        result == ConnectivityResult.bluetooth) {
      changeLoadingState(false);
      return false;
    } else {
      return true;
    }
  }

  Future<bool> IsEmailAndPhoneExist(email, phone, context) async {
    const url = "https://reshop-a42f1-default-rtdb.firebaseio.com/users.json";
    final auth = FirebaseAuth.instance;
    bool isPhoneExist = false;
    final List<String> otherMethod =
        await auth.fetchSignInMethodsForEmail(email);
    if (otherMethod.isEmpty) {
      try {
        final result = await http.get(Uri.parse(url));
        final data = json.decode(result.body);
        if (data == "" || data == null) {
          return false;
        } else {
          await data.forEach((userId, userData) {
            if (userData["phoneNum"] == phone) {
              mySnackBar(context, 'This phone number already exist!');
              changeLoadingState(false);
              isPhoneExist = true;
            }
          });
          return isPhoneExist;
        }
      } catch (error) {
        mySnackBar(context, 'Some Error Occured. Try Again Later');
        changeLoadingState(false);
        return true;
      }
    } else {
      mySnackBar(context, "Email address already exist !");
      changeLoadingState(false);
      return true;
    }
  }

  mySnackBar(BuildContext ctx, String text) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(text)));
  }
}
