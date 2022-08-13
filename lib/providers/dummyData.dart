import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reshop/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:reshop/providers/auth_readwrite.dart';
import 'dart:convert';

import '../models/product.dart';
import '../enums.dart';

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

  Future<void> FetchAllProducts(context) async {
    offers = [];
    const url =
        "https://reshop-a42f1-default-rtdb.firebaseio.com/products.json";
    try {
      final result = await http.get(Uri.parse(url));
      final data = json.decode(result.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      await FetchAllFav();
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
            isFav: myFavIds.contains(prodData["id"]));
        loadedProducts.add(prod);
        if (prodData["off"] != null) {
          offers.add(prod);
          print("--------off data: ${prodData["off"]}");
        }
        ;
      });
      myProducts = loadedProducts;
      notifyListeners();
      print('---------------- myproductLenght : ${myProducts.length}');
    } on SocketException catch (error) {
      if (error.message == "Connection timed out") {
        print("conneciton time out -----------------");
      }
    } catch (e) {}
  }

  Future<void> FetchAllFav() async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        myFavIds.add(doc.id);
      });
    });
  }

  Future<List<Product>> getFavProduct() async {
    myFavProducts = [];
    myProducts.forEach((element) {
      if (element.isFav) {
        myFavProducts.add(element);
      }
    });
    return myFavProducts;
  }

  Future<void> changeFavInMyproduct({ProductId}) async {
    myProducts.forEach((element) {
      if (element.id == ProductId) {
        element.isFav = !element.isFav;
      }
    });
    var p = myProducts.firstWhere((element) => element.id == ProductId);
    print("----------product fav= ${p.isFav}");
  }

  void changeBottonNavigationBar({int newValue}) {
    bottomNavigationBar = newValue;
    notifyListeners();
  }

  void changePageview(int newValue) {
    currentPageView = newValue;
    notifyListeners();
  }

  void editOnCart({productId, count}) {
    cartProducts.forEach((element) {
      if (element["product"].id == productId) {
        element["count"] = count;
        return;
      }
    });
    notifyListeners();
  }

  List<Map<String, String>> splashScreen = [
    {
      "image": "assets/images/onboarding/onboarding1.png",
      "title": "Buy whatever you want ",
      "subtitle":
          " The biggest online shop so you can find what are you looking for "
    },
    {
      "image": "assets/images/onboarding/onboarding2.png",
      "title": "Fastest Delivery service",
      "subtitle":
          " A wide country branches to give you the best delivery service "
    },
    {
      "image": "assets/images/onboarding/onboarding3.png",
      "title": "Find Your Perfect Offers",
      "subtitle":
          "The biggest online shop so you can find what are you looking for"
    }
  ];

  List homePageView = [
    "assets/images/carousel_card1.png",
    "assets/images/carousel_card2.png",
    "assets/images/carousel_card1.png"
  ];

  List<Map> categories = [
    {
      "text": "Electronics",
      "image": "assets/images/categories/electronics_icon.png"
    },
    {"text": "Beauty", "image": "assets/images/categories/beauty_icon1.png"},
    {"text": "Home", "image": "assets/images/categories/home_icon1.png"},
    {"text": "Fashion", "image": "assets/images/categories/fashion_icon1.png"},
    {"text": "Sport", "image": "assets/images/categories/sport_icon.png"},
    {"text": "Kitchen", "image": "assets/images/categories/kitchen_icon1.png"},
  ];

  Map<String, List> subCategories = {
    "Electronics": [
      "All",
      "Smart Phones",
      "Tablets",
      "Televisions",
      "Labtops",
      "Accessories"
    ],
    "Beauty": ["All", "Makeup", "Skin care", "Hair care"],
    "Home": ["All", "Home decore", "Wall art", "Lighting", "Fans"],
    "Fashion": [
      "All",
      "Man's fashion",
      "Woman's fashion",
      "Boy's fashion",
      "Girl's fashion"
    ],
    "Sport": [
      "All",
      "Running",
      "Water sport",
      "Tennis sports",
      "Golf",
      "Winter sport",
    ],
    "Kitchen": ["All", "Water coolers", "Filters", "Glasses", "Accessories"]
  };

  List brands = ["Adidas", "Squadra", "MyHome"];

  getBestSellers() {
    myProducts.sort(((a, b) => a.sellCount.compareTo(b.sellCount)));
    int lengthOfBestSellers = (myProducts.length / 3).ceil();
    int index = myProducts.length - lengthOfBestSellers;
    bestSeller = [];
    lifeStyle = [];
    int maxSellCounter = 0;
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
