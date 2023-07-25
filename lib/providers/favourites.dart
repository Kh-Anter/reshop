import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FavouritesProvider extends ChangeNotifier {
  Future<void> changeFavorite(uid, prodId) async {
    var fs = FirebaseFirestore.instance;
    var product = await fs
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .doc(prodId)
        .get();
    if (!product.exists) {
      fs
          .collection('users')
          .doc(uid)
          .collection('favourites')
          .doc(prodId)
          .set({});
    } else {
      fs
          .collection('users')
          .doc(uid)
          .collection('favourites')
          .doc(prodId)
          .delete();
    }
    notifyListeners();
  }

  Future<bool> isFav(uid, prodId) async {
    var fs = FirebaseFirestore.instance;
    var product = await fs
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
}
