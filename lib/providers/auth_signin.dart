import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:reshop/providers/auth_other.dart';
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

  Future<void> signIn(contex) async {
    try {
      var x = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email_ctr.text, password: password_ctr.text);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          mySnackBar(contex, "Wrong password!");
          break;
        case 'user-not-found':
          mySnackBar(contex, "User not found");
          break;
        case 'user-disabled':
          mySnackBar(contex, "User disabled");
          break;
        case 'too-many-requests':
          mySnackBar(contex, "An error occured , try again later");
      }
    }
  }

  Future<void> signInWithGoogle(context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    bool hasInternet = await Auth_other().hasNetwork();
    if (hasInternet) {
      try {
        final GoogleSignIn _googleSignIn = GoogleSignIn();
        GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        print("------------- the email selected: ${googleSignInAccount.email}");
        List<String> userSignInMethods =
            await auth.fetchSignInMethodsForEmail(googleSignInAccount.email);
        if (userSignInMethods.isEmpty) {
          await auth.signInWithCredential(authCredential);
          await Auth_ReadWrite().addUserToFirestore(auth.currentUser.uid,
              auth.currentUser.displayName, auth.currentUser.email);
        } else {
          await linkWithOtherCredential(
              googleSignInAccount.email, authCredential, userSignInMethods);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          List<String> userSignInMethods =
              await auth.fetchSignInMethodsForEmail(e.email);
          await linkWithOtherCredential(
              e.email, e.credential, userSignInMethods);
        }
      } catch (e) {
        print("-------------------:$e");
        mySnackBar(context, "An error occured , try again later");
      }
    } else {
      mySnackBar(context, "No internet connection !");
    }
  }

  Future<void> signInWithFacebook(context) async {
    bool hasInternet = await Auth_other().hasNetwork();
    //  bool isExist = await checkEmailAndPhone(email);
    if (hasInternet) {
      FirebaseAuth auth = FirebaseAuth.instance;
      try {
        final LoginResult loginResult = await FacebookAuth.i.login();
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken.token);
        await auth.signInWithCredential(facebookAuthCredential);
        await Auth_ReadWrite().addUserToFirestore(auth.currentUser.uid,
            auth.currentUser.displayName, auth.currentUser.email);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          List<String> userSignInMethods =
              await auth.fetchSignInMethodsForEmail(e.email);
          await linkWithOtherCredential(
              e.email, e.credential, userSignInMethods);
        }
      } catch (e) {
        print("-------------------errror : $e");
      }
    } else {
      mySnackBar(context, "No internet connection !");
    }
  }

  // Future<bool> checkEmailAndPhone(email) async {
  //   const url = "https://reshop-a42f1-default-rtdb.firebaseio.com/users.json";
  //   bool emailExist = false;
  //   try {
  //     final result = await http.get(Uri.parse(url));
  //     final data = json.decode(result.body);
  //     if (data != null) {
  //       await data.forEach((userId, userData) {
  //         if (userData["email"] == email) {
  //           emailExist = true;
  //         }
  //       });
  //     }
  //     return emailExist;
  //   } catch (error) {
  //     print("-eeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrorrrrrrrrr");
  //     return emailExist;
  //   }
  // }

  Future<void> linkWithOtherCredential(
      email, credential, userSignInMethods) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (userSignInMethods.first == 'password') {
      print("--------- now should make user enter the password !");
      String password = '123456';
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user.linkWithCredential(credential);
    }

    if (userSignInMethods.first == 'facebook.com') {
      final LoginResult loginResult = await FacebookAuth.i.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken.token);

      UserCredential userCredential =
          await auth.signInWithCredential(facebookAuthCredential);
      await userCredential.user.linkWithCredential(credential);
    }
    if (userSignInMethods.first == 'google.com') {
      print("---------google credential=----------");
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      UserCredential userCredential =
          await auth.signInWithCredential(authCredential);
      await userCredential.user.linkWithCredential(credential);
    }
  }

  mySnackBar(BuildContext ctx, String text) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(text)));
  }
}
