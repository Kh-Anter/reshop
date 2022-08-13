import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:reshop/models/product.dart';
import 'package:reshop/providers/dummyData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class Auth_ReadWrite with ChangeNotifier {
  List<Map<String, dynamic>> myCart = [];
  double total;

  Future<void> addUserDataToFirebase(phone) async {
    String url = "https://reshop-a42f1-default-rtdb.firebaseio.com/users.json";
    try {
      var result = await http.post(Uri.parse(url),
          body: json.encode({
            "phoneNum": phone,
          }));
    } catch (e) {
      print(e);
    }
  }

  Future<void> addUserToFirestore(uid, name, email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(uid).set({
      'name': name,
      'email': email,
    }).then((value) => print("User Added"));
  }

  Future<void> changeFavorite(uid, prodId) async {
    var FS = FirebaseFirestore.instance;
    var product = await FS
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .doc(prodId)
        .get();
    if (!product.exists) {
      await FS
          .collection('users')
          .doc(uid)
          .collection('favourites')
          .doc(prodId)
          .set({});
    } else {
      FS
          .collection('users')
          .doc(uid)
          .collection('favourites')
          .doc(prodId)
          .delete();
    }
    notifyListeners();
  }

  Future<bool> isFav(uid, prodId) async {
    var FS = FirebaseFirestore.instance;
    var product = await FS
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .doc(prodId)
        .get();

    if (!product.exists) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> addToCart(prodId, count, ctx) async {
    // var _dummyData = Provider.of<DummyData>(ctx, listen: false);
    final uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(prodId)
        .set({"count": count});
    //notifyListeners();
    await readCart(ctx);
  }

  Future<List<Map<String, dynamic>>> readCart(ctx) async {
    var _dummyData = Provider.of<DummyData>(ctx, listen: false);
    final uid = FirebaseAuth.instance.currentUser.uid;
    List<Map<String, dynamic>> myCart2 = [];
    var product = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();
    for (int i = 0; i < product.docs.length; i++) {
      var prodId = product.docs[i].id.toString();
      var count = await product.docs[i].data()["count"];
      var theproduct = await _dummyData.getById(prodId);
      myCart2.add({"product": theproduct, "count": count});
    }
    myCart = myCart2;
    calculateTotal();
    return myCart;
  }

  Future<void> removeFromCart(prodId) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(prodId)
        .delete();

    myCart.removeWhere((node) => node["product"].id == prodId);
    calculateTotal();
  }

  Future<void> calculateTotal() async {
    double total2 = 0;
    for (int i = 0; i < myCart.length; i++) {
      total2 += myCart[i]["product"].price * int.parse(myCart[i]["count"]);
    }
    total = total2;
    notifyListeners();
  }

  Future<void> localWriteAboutSplash() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstUse', false);
  }

  Future<bool> isFirstUse() async {
    final prefs = await SharedPreferences.getInstance();
    var result = prefs.getBool("firstUse");
    if (result != null) {
      return result;
    } else {
      return true;
    }
  }
}
// Future<String> localReadUserName() async {
//   final prefs = await SharedPreferences.getInstance();
//   try {
//     var data = json.decode(prefs.getString('userData'));
//     return data["userName"].toString();
//   } catch (e) {
//     return "";
//   }
// }
