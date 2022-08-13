import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reshop/providers/dummyData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class Auth_IsLoggedin with ChangeNotifier {
  String _idToken;
  String _uid;
  DateTime _expiryData;

  // Future<bool> isDataExist() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (prefs.containsKey('userData')) {
  //     final data =
  //         json.decode(prefs.getString('userData')) as Map<String, Object>;
  //     _idToken = data['token'];
  //     _uid = data['userId'];
  //     _expiryData = DateTime.parse(data['expiryDate']);
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // Future<bool> isLoggedIn() async {
  //   bool _isDataExist = await isDataExist();
  //   if (_isDataExist) {
  //     if (_expiryData.isBefore(DateTime.now())) {
  //       return false;
  //     } else {
  //       return true;
  //     }
  //   } else {
  //     return false;
  //   }
  // }

  void logOut(context, auth_other) {
    var auth = FirebaseAuth.instance;
    print("---------- the currentUser : ${auth.currentUser}");
    print(
        "---------- the currentUser.providerData : ${auth.currentUser.providerData[0]}");
    var userProvider = auth.currentUser.providerData[0].providerId;
    print("------ $userProvider");
    if (userProvider == "google.com") {
      GoogleSignIn().signOut();
      auth.signOut();
    } else if (userProvider == "facebook.com") {
      FacebookAuth.i.logOut();
      FacebookAuth.instance.logOut();
      auth.signOut();
    } else {
      FirebaseAuth.instance.signOut();
    }
    Provider.of<DummyData>(context, listen: false).bottomNavigationBar = 0;
  }
}
