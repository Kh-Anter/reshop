import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth_ReadWrite {
  Future<void> localWrite(
      {token, userId, email, userName, expiryDate, refreshToken}) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'token': token,
        'userId': userId,
        'email': email,
        'userName': userName,
        'expiryDate': expiryDate.toIso8601String(),
        'refreshToken': refreshToken
      },
    );
    prefs.setString('userData', userData);
    if (!prefs.containsKey('Welcome')) {
      prefs.setString('Welcome', 'true');
    }
  }

  Future<String> localReadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var data = json.decode(prefs.getString('userData'));
      return data["userName"].toString();
    } catch (e) {
      return "";
    }
  }
}
