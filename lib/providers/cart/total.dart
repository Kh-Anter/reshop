import 'package:flutter/material.dart';

class TotalCartProvider with ChangeNotifier {
  int total = 0;

  void calculateTotal(List myCart) {
    int total2 = 0;
    for (int i = 0; i < myCart.length; i++) {
      total2 += int.parse(myCart[i]["product"].price.toString()) *
          int.parse(myCart[i]["count"].toString());
    }
    total = total2;
  }

  void addToTotal(int totalAdding) {
    this.total += totalAdding;
    notifyListeners();
  }

  void subtractTotal(int totalSubtraction) {
    this.total -= totalSubtraction;
    notifyListeners();
  }

  void refreshTotal(myCart) {
    int total2 = 0;
    for (int i = 0; i < myCart.length; i++) {
      total2 += int.parse(myCart[i]["product"].price.toString()) *
          int.parse(myCart[i]["count"].toString());
    }
    total = total2;
    notifyListeners();
  }
}
