import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reshop/consts/enums.dart';
import 'package:reshop/service/connect_firebase.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reshop/providers/dummyData.dart';
import 'package:reshop/screens/authentication/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:reshop/widgets/mySnackBar.dart';
import 'dart:io';

class AuthOther with ChangeNotifier {
  bool isSignIn = true;
  bool forgotState = false;
  bool profilePicState = false;

  changeAuthState(bool isSigin) {
    isSignIn = isSigin;
    notifyListeners();
  }

  changeForgotState(bool newState) {
    forgotState = newState;
    notifyListeners();
  }

  changeProfilePicState(bool newState) {
    profilePicState = newState;
    notifyListeners();
  }

  static Future<bool> isEmailAlreadyRegistered(String email) async {
    var auth = FirebaseAuth.instance;
    try {
      final methods = await auth.fetchSignInMethodsForEmail(email);
      return methods
          .isNotEmpty; // email already registered if methods list is not empty
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isPhoneNumberAlreadyRegistered(String phoneNumber) async {
    final data = await ConnectFirebase.realtimeRead(path: "users");
    if (data == null) return false;
    for (var value in data.values) {
      if (value["phoneNum"] == phoneNumber) {
        return true;
      }
    }
    return false;
  }

  static Future addUserToRealtimeDB(
      {String? name,
      required String email,
      String? phone,
      required uid}) async {
    ConnectFirebase.realtimeWrite(
        path: "users",
        data: {"name": name, "email": email, "phoneNum": phone},
        uid: uid);
  }

  Future<bool> forgotPassword(String email, BuildContext context) async {
    changeForgotState(true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      changeForgotState(false);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        MySnackbar.showSnackBar(context, "user-not-found", SnackBarType.fail);
      } else {
        MySnackbar.showSnackBar(
            context, e.message ?? "an error occured", SnackBarType.fail);
      }
      changeForgotState(false);
      return false;
    } catch (e) {
      MySnackbar.showSnackBar(context, e.toString(), SnackBarType.fail);
      changeForgotState(false);
      return false;
    }
  }

  void logOut(context) async {
    var auth = FirebaseAuth.instance;
    print("---------- the currentUser : ${auth.currentUser}");
    var userProvider = auth.currentUser?.providerData[0].providerId;
    if (userProvider == "google.com") {
      GoogleSignIn().signOut();
      auth.signOut();
    } else if (userProvider == "facebook.com") {
      FacebookAuth.i.logOut();
      FacebookAuth.instance.logOut();
      auth.signOut();
    } else {
      await auth.signOut();
    }
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => AuthScreen()),
        ModalRoute.withName(AuthScreen.routeName));
    Provider.of<DummyData>(context, listen: false).bottomNavigationBar = 0;
    changeAuthState(true);
  }

  Future<bool> changePassword(
      {required String currentPass, required String newPassword}) async {
    var user = FirebaseAuth.instance.currentUser;
    String email = (user?.email!.isEmpty)!
        ? (user?.providerData[0].email)!
        : (user?.email)!;
    try {
      // Create a credential with the current email and password
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPass,
      );

      // Reauthenticate the user with the credential
      await user!.reauthenticateWithCredential(credential);

      // If reauthentication succeeds, update the user's password
      await user.updatePassword(newPassword);
      return true;
      // Password updated successfully
    } catch (e) {
      print("------error while change password: $e");

      // Handle errors here
    }
    return false;
  }

  Future<void> changeProfileImage(BuildContext context, XFile imageFile) async {
    changeProfilePicState(true);
    try {
      final storage = FirebaseStorage.instance;
      final user = FirebaseAuth.instance.currentUser;
      final ref = storage.ref().child("images/${user?.uid}/profile_pic.jpg");
      final uploadTask = ref.putFile(File(imageFile.path));
      final snapshot = await uploadTask.whenComplete(() => null);
      final imgUrl = await snapshot.ref.getDownloadURL();
      await user?.updatePhotoURL(imgUrl);
      changeProfilePicState(false);
    } catch (e) {
      MySnackbar.showSnackBar(context, "An error occurred ", SnackBarType.fail);
      changeProfilePicState(false);
    }
  }
}
