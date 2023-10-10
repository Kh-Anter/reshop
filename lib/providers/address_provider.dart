// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:reshop/consts/enums.dart';
import 'package:reshop/models/address.dart';

import 'package:reshop/widgets/mySnackBar.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AddressProvider with ChangeNotifier {
  late double total;
  bool isFirst = true;
  List<AddressModel> userAddress = [];

  Future<List<AddressModel>> readAddress() async {
    if (isFirst) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      userAddress = [];
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('address')
            .get()
            .then((QuerySnapshot querySnapshot) => {
                  querySnapshot.docs.forEach((doc) {
                    userAddress.add(AddressModel(
                        title: doc.get("title"),
                        address: doc.get("address"),
                        name: doc.get("name"),
                        phoneNum: doc.get("phoneNum")));
                  })
                });
        isFirst = false;
      } catch (_) {}
    }
    return userAddress;
  }

  Future addAddress(
      {required AddressModel newAddress, required BuildContext context}) async {
    for (var element in userAddress) {
      if (element.address == newAddress.address) {
        MySnackbar.showSnackBar(
            context, "This address already exist!", SnackBarType.fail);
        return;
      }
    }
    userAddress.add(newAddress);
    notifyListeners();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('address')
        .add({
      "title": newAddress.title,
      "address": newAddress.address,
      "name": newAddress.name,
      "phoneNum": newAddress.phoneNum
    });
    Navigator.of(context).pop();
  }

  Future deleteAddress(
      {required String address, required BuildContext context}) async {
    userAddress.removeWhere((element) => element.address == address);

    notifyListeners();
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      CollectionReference addressCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('address');
      // Query the collection to find documents with the specified address
      QuerySnapshot snapshot =
          await addressCollection.where('address', isEqualTo: address).get();
      // Check if there is any document that matches the address
      if (snapshot.size > 0) {
        // Get the reference to the first matching document (Assuming you only want to delete the first match)
        DocumentReference documentReference = snapshot.docs[0].reference;
        // Delete the document
        await documentReference.delete();
      }
    } catch (_) {
      MySnackbar.showSnackBar(
          context, "some thing whent wrong!", SnackBarType.fail);
    }
  }

  Future editAddress(
      {
      // required AddressModel oldAddress,
      required AddressModel newAddress,
      required BuildContext context}) async {
    // userAddress.remove(oldAddress);
    // userAddress.add(newAddress);
    // int index =
    //     userAddress.indexWhere((element) => element.address == lastAddress);
    // if (index != -1) {
    //   userAddress[index].title = title;
    //   userAddress[index].address = address;
    //   userAddress[index].name = name;
    //   userAddress[index].phoneNum = phoneNum;
    notifyListeners();
    // }
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      CollectionReference addressCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('address');
      QuerySnapshot snapshot = await addressCollection
          .where('address', isEqualTo: newAddress.address)
          .get();
      if (snapshot.size > 0) {
        DocumentReference documentReference = snapshot.docs[0].reference;
        await documentReference.update({
          "title": newAddress.title,
          "address": newAddress.address,
          "name": newAddress.name,
          "phone": newAddress.phoneNum
        }).then((value) => Navigator.of(context).pop());
      }
      ;
    } catch (_) {
      MySnackbar.showSnackBar(
          context, "some thing whent wrong!", SnackBarType.fail);
    }
  }
}
