import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:reshop/models/product.dart';
import 'package:reshop/providers/cart/total.dart';
import 'package:reshop/providers/dummyData.dart';

class CartProvider with ChangeNotifier {
  // mycart is a list of map ,, each map contain the product and the count
  List<Map<String, dynamic>> myCart = [];
  bool isFirst = true;

  Future<void> addToCart(Product product, BuildContext ctx,
      {int count = 1}) async {
    if (!isInCart(product.id, ctx)) {
      myCart.add({"product": product, "count": count});
      notifyListeners();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('cart')
            .doc(product.id)
            .set({"count": count});
      } catch (e) {
        print("---------exception------ $e");
      }
      // await readCart(ctx);
      // notifyListeners();
    }
  }

  bool isInCart(productId, ctx) {
    if (myCart.isNotEmpty) {
      for (int i = 0; i < myCart.length; i++) {
        if (myCart[i]["product"].id == productId) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  Future<List> readCart(ctx) async {
    var dummyData = Provider.of<DummyData>(ctx, listen: false);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (isFirst) {
      List<Map<String, dynamic>> myCart2 = [];
      var product = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart')
          .get();

      for (int i = 0; i < product.docs.length; i++) {
        var prodId = product.docs[i].id.toString();
        var count = await product.docs[i].data()["count"];
        var theproduct = await dummyData.getById(prodId);
        myCart2.add({"product": theproduct, "count": count});
      }
      myCart = myCart2;
      isFirst = false;
    }
    return myCart;
  }

  Future<void> editItemCount(prodId, newCount, price, processType, ctx) async {
    var totalProvider = Provider.of<TotalCartProvider>(ctx, listen: false);
    if (processType == 's') {
      totalProvider.subtractTotal(price);
    } else if (processType == 'a') {
      totalProvider.addToTotal(price);
    }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(prodId)
          .set({"count": newCount});
    } catch (e) {
      print("---------exception------");
      print(e);
    }
  }

  Future<void> removeFromCart(productId, ctx) async {
    var totalProvider = Provider.of<TotalCartProvider>(ctx, listen: false);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    myCart.removeWhere((element) {
      return element["product"].id == productId;
    });
    totalProvider.refreshTotal(myCart);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .delete();
  }

  Future emptyingCart() async {
    myCart = [];
    final uid = FirebaseAuth.instance.currentUser?.uid;
    CollectionReference collectionReference = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart');
    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      await docSnapshot.reference.delete();
    }
  }
}
