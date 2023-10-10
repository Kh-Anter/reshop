import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:reshop/providers/cart/cart_provider.dart';
import 'package:reshop/providers/cart/total.dart';
import 'package:intl/intl.dart';

class OrderProvider extends ChangeNotifier {
  bool addOrderProgress = false;
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> addNewOrder(
    Map<String, String> address,
    BuildContext ctx,
  ) async {
    List<Map<String, dynamic>> items = [];
    final cartProvider = Provider.of<CartProvider>(ctx, listen: false);
    final totalProvider = Provider.of<TotalCartProvider>(ctx, listen: false);
    for (var element in cartProvider.myCart) {
      items.add({
        "itemId": element["product"].id,
        "itemName": element["product"].title,
        "count": element["count"]
      });
    }
    changeAddOrderProgress();
    await FirebaseFirestore.instance.collection("orders").add({
      "address": address,
      "date": DateTime.now(),
      "items": items,
      "isDeliverd": false,
      "total": totalProvider.total,
      "uid": FirebaseAuth.instance.currentUser?.uid,
    }).then((value) {
      changeAddOrderProgress();
      Provider.of<CartProvider>(ctx, listen: false).emptyingCart();
    });
  }

  void changeAddOrderProgress() {
    addOrderProgress = !addOrderProgress;
    notifyListeners();
  }

  Future getOrders({bool? isDeliverd}) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;

    var listOfOrders = await orders
        .where('uid', isEqualTo: uid)
        .where('isDeliverd', isEqualTo: isDeliverd)
        .get();
    List<Map<String, dynamic>> result = [];
    for (int i = 0; i < listOfOrders.docs.length; i++) {
      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(
          listOfOrders.docs[i].get("date").seconds * 1000);

      var date = DateFormat('yyyy-MM-dd').format(tsdate);
      result.add(
        {
          "address": listOfOrders.docs[i].get("address").toString(),
          "date": date,
          "items": listOfOrders.docs[i].get("items"),
          "total": listOfOrders.docs[i].get("total"),
          "orderId": listOfOrders.docs[i].id
        },
      );
    }
    return result;
  }
}
