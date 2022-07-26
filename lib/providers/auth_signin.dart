import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:reshop/providers/auth_readwrite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth_SignIn with ChangeNotifier {
  TextEditingController email_ctr = TextEditingController();
  TextEditingController password_ctr = TextEditingController();
  String userId;
  String userName;
  String token;
  String refreshToken;
  DateTime expiryDate;

  Future<String> signIn() async {
    String url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyC6PUwz2SGMQXHbRsvZV5zTyiIssqKXEJI";
    try {
      final respons = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email_ctr.text,
            'password': password_ctr.text,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(respons.body);
      if (responseData['error'] != null) {
        print("------error : ${responseData['error']}");
        return responseData['error']['message'];
      }
      token = responseData['idToken'];
      userId = responseData['localId'];
      userName = responseData['displayName'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      refreshToken = responseData['refreshToken'];
      await Auth_ReadWrite().localWrite(
          email: email_ctr.text,
          userName: userName,
          userId: userId,
          token: token,
          expiryDate: expiryDate,
          refreshToken: refreshToken);
      return '';
    } catch (e) {
      print("---------- error can't login");
      return 'Some Error Occured. Try Again Later';
    }
  }
}
