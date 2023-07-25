import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class DummyData with ChangeNotifier {
  List bestSeller = [];
  List lifeStyle = [];
  int currentPageView = 0;
  int bottomNavigationBar = 0;
  List<Map<String, dynamic>> cartProducts = [];
  bool isInCart = false;
  List<Product> myProducts = [];
  List<String> myFavIds = [];
  List<Product> myFavProducts = [];
  List<Product> offers = [];

  Future<void> fetchAllProducts(context) async {
    print("------  enter fetch data ----------");
    offers = [];
    const url =
        "https://reshop-a42f1-default-rtdb.firebaseio.com/products.json";
    try {
      final result = await http.get(Uri.parse(url));
      final data = json.decode(result.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      final List<Product> loadedOffers = [];
      await fetchAllFav();

      data.forEach((prodId, prodData) {
        var prod = Product(
            id: prodData["id"],
            title: prodData["title"],
            brand: prodData["brand"],
            category: prodData["category"],
            price: prodData["price"],
            description: prodData["description"],
            sellCount: prodData["sellCount"],
            subCat: prodData["subCat"],
            images: List.generate(prodData["images"].length,
                (index) => prodData["images"][index]),
            isFav: myFavIds.contains(prodData["id"]),
            off: prodData["off"]);
        loadedProducts.add(prod);
        if (prodData["off"] != null) {
          loadedOffers.add(prod);
        }
      });
      myProducts = loadedProducts;
      offers = loadedOffers;
      notifyListeners();
    } on SocketException catch (error) {
      if (error.message == "Connection timed out") {
        print("conneciton time out -----------------");
      }
    } catch (e) {
      print("----- fetch data error ----- : ${e}");
    }
  }

  Future<void> fetchAllFav() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        myFavIds.add(doc.id);
      }
    });
  }

  Future<List<Product>> getFavProduct() async {
    myFavProducts = [];
    for (var element in myProducts) {
      if (element.isFav) {
        myFavProducts.add(element);
      }
    }
    return myFavProducts;
  }

  Future<void> changeFavInMyproduct({productId}) async {
    //for (var element in myProducts) {
    myProducts.forEach((element) {
      if (element.id == productId) {
        element.isFav = !element.isFav;
      }
    });
    //myFavProducts.removeWhere((element) => element.id == productId);
    // notifyListeners();
  }

  void changeBottonNavigationBar({required int newValue}) {
    bottomNavigationBar = newValue;
    notifyListeners();
  }

  // void changePageview(int newValue) {
  //   currentPageView = newValue;
  //   notifyListeners();
  // }

  // void editOnCart({productId, count}) {
  //   for (var element in cartProducts) {
  //     if (element["product"].id == productId) {
  //       element["count"] = count;
  //       continue;
  //     }
  //   }
  //   notifyListeners();
  // }

  getBestSellers() {
    myProducts.sort(((a, b) => a.sellCount.compareTo(b.sellCount)));
    int lengthOfBestSellers = (myProducts.length / 3).ceil();
    int index = myProducts.length - lengthOfBestSellers;
    bestSeller = [];
    lifeStyle = [];
    for (int i = 0; i < index; i++) {
      lifeStyle.add(myProducts[i]);
    }
    for (index; index < myProducts.length; index++) {
      bestSeller.add(myProducts[index]);
    }
    return bestSeller;
  }

  getLifeStyle() {
    return lifeStyle;
  }

  getByCategory(String category) {
    List<Product> productByCat = [];
    for (int i = 0; i < myProducts.length; i++) {
      if (myProducts[i].category == category) {
        productByCat.add(myProducts[i]);
      }
    }
    return productByCat;
  }

  getById(id) {
    return myProducts.firstWhere((element) => element.id == id);
  }

  getBySubCat(String subCategor) {
    List<Product> productBySubCat = [];
    for (int i = 0; i < myProducts.length; i++) {
      if (myProducts[i].subCat == subCategor) {
        productBySubCat.add(myProducts[i]);
      }
    }
    return productBySubCat;
  }
}
