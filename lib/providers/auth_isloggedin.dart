import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth_IsLoggedin with ChangeNotifier {
  String _idToken;
  String _uid;
  DateTime _expiryData;

  Future<bool> isDataExist() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final data =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      _idToken = data['token'];
      _uid = data['userId'];
      _expiryData = DateTime.parse(data['expiryDate']);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    bool _isDataExist = await isDataExist();
    if (_isDataExist) {
      if (_expiryData.isBefore(DateTime.now())) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<bool> isFirstUse() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('Welcome')) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      await prefs.remove('userData');
    }
    notifyListeners();
  }
}
