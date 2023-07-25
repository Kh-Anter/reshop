// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AuthReadWrite with ChangeNotifier {
  late double total;
  List<Map<String, String>> userAddress = [];

  Future<void> readAddress() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    userAddress = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('address')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                userAddress.add({
                  "title": doc.get("title"),
                  "address": doc.get("address"),
                  "name": doc.get("name"),
                  "phoneNum": doc.get("phoneNum")
                });
              })
            });
  }

  Future<bool> addAddress(
      {String? title, String? address, String? name, String? phoneNum}) async {
    for (var element in userAddress) {
      if (element["address"] == address) {
        return false;
      }
    }
    userAddress.add({
      "title": title!,
      "address": address!,
      "name": name!,
      "phoneNum": phoneNum!
    });
    final uid = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('address')
        .add({
      "title": title,
      "address": address,
      "name": name,
      "phoneNum": phoneNum
    });
    return true;
  }
}
