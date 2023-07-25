import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reshop/consts/enums.dart';
import 'package:reshop/providers/authentication/auth_other.dart';
import 'package:reshop/providers/loading_provider.dart';
import 'package:reshop/screens/home.dart';
import 'package:reshop/widgets/mySnackBar.dart';

class AuthSignIn with ChangeNotifier {
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();

  Future<void> signIn(context) async {
    var loading = Provider.of<LoadingProvider>(context, listen: false);
    loading.changeAuthLoading(true);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailCtr.text, password: passwordCtr.text)
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => Home()),
            ModalRoute.withName(Home.routeName));
      });
    } on FirebaseAuthException catch (e) {
      String? snackBarMessage;
      switch (e.code) {
        case 'user-not-found':
          snackBarMessage = "User not found";
          break;
        case 'user-disabled':
          snackBarMessage = "User disabled";
          break;
        case 'wrong-password':
          snackBarMessage = "Wrong password";
          break;
        case 'too-many-requests':
          snackBarMessage = "Too many requests, try again later";
          break;
      }
      MySnackbar.showSnackBar(
          context, snackBarMessage ?? "an error occured", SnackBarType.fail);
    } catch (e) {
      MySnackbar.showSnackBar(context, e.toString(), SnackBarType.fail);
    }
    loading.changeAuthLoading(false);
  }

  Future<void> signInWithGoogle(context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var loading = Provider.of<LoadingProvider>(context, listen: false);
    loading.changeAuthLoading(true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      await auth.signInWithCredential(credential);

      await AuthOther.addUserToRealtimeDB(
          name: auth.currentUser!.displayName,
          email: auth.currentUser!.providerData[0].email!, //googleUser.email,
          phone: auth.currentUser!.phoneNumber,
          uid: auth.currentUser!.uid);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Home()),
          ModalRoute.withName(Home.routeName));
      loading.changeAuthLoading(false);
    } catch (e) {
      MySnackbar.showSnackBar(context, e.toString(), SnackBarType.fail);
    }
    loading.changeAuthLoading(false);
  }

  Future<void> signInWithFacebook(context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var loading = Provider.of<LoadingProvider>(context, listen: false);
    loading.changeAuthLoading(true);
    try {
      final LoginResult facebookUser = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(facebookUser.accessToken!.token);
      await auth.signInWithCredential(facebookAuthCredential);
      await AuthOther.addUserToRealtimeDB(
          name: auth.currentUser!.displayName,
          email: auth.currentUser!.providerData[0].email!,
          phone: auth.currentUser!.phoneNumber,
          uid: auth.currentUser!.uid);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Home()),
          ModalRoute.withName(Home.routeName));
      loading.changeAuthLoading(false);
    } catch (e) {
      MySnackbar.showSnackBar(context, e.toString(), SnackBarType.fail);
    }
    loading.changeAuthLoading(false);
  }
}
