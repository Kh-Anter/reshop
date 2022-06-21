import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reshop/models/product.dart';
import 'package:http/http.dart' as http;
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

  Future<void> FetchAllProducts() async {
    const url =
        "https://reshop-a42f1-default-rtdb.firebaseio.com/products.json";
    try {
      final result = await http.get(Uri.parse(url));
      final data = json.decode(result.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      data.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData["title"],
          brand: prodData["brand"],
          category: prodData["category"],
          price: prodData["price"],
          description: prodData["description"],
          sellCount: prodData["sellCount"],
          subCat: prodData["subCat"],
          images: List.generate(
              prodData["images"].length, (index) => prodData["images"][index]),

          // images: prodData["images"],
        ));
      });
      myProducts = loadedProducts;
      notifyListeners();
      print('---------------- myproductLenght : ${myProducts.length}');
    } catch (error) {
      throw (error);
    }
  }

  // Future<void> addProduct(
  //     {title, category, price, brand, description, sellCount, images}) async {
  //   const url =
  //       "https://reshop-a42f1-default-rtdb.firebaseio.com/products.json";
  //   var result = await http.post(Uri.parse(url),
  //       body: json.encode({
  //         "title": title,
  //         "category": category,
  //         "price": price,
  //         "brand": brand,
  //         "description": description,
  //         "sellCount": sellCount,
  //         "images": images
  //       }));
  //   print("--- add product result --- : ${json.decode(result.body)}");
  // }

  // void startAdding() {
  //   myProducts.forEach((e) {
  //     addProduct(
  //         title: e.title,
  //         category: e.category.name,
  //         price: e.price,
  //         brand: e.brand,
  //         description: e.description,
  //         sellCount: e.sellCount,
  //         images: e.images);
  //     print("--- for each product run ---");
  //   });
  // }

  void changeFav(id) {
    // myProducts.forEach((element) {
    //   if (element.id == id) {
    //     element.isFav = !element.isFav;
    //   }
    // });
    // notifyListeners();
  }

  void changeBottonNavigationBar({int newValue}) {
    bottomNavigationBar = newValue;
    notifyListeners();
  }

  void changePageview(int newValue) {
    currentPageView = newValue;
    notifyListeners();
  }

  void addToCart({productId, count}) {
    // print("---------------- proID --- : $productId");
    // // print("---------------- count --- : $count");
    // var product = myProducts.firstWhere((element) => element.id == productId);
    // if (cartProducts.length == 0) {
    //   cartProducts.add({"product": product, "count": count});
    // } else {
    //   for (int i = 0; i < cartProducts.length; i++) {
    //     if (cartProducts[i]["product"].id.toString() == productId.toString()) {
    //       isInCart = true;
    //       break;
    //     }
    //   }
    //   if (!isInCart) {
    //     cartProducts.add({"product": product, "count": count});
    //   } else if (isInCart) {
    //     cartProducts.forEach((element) {
    //       if (element["product"].id == productId) {
    //         element["count"] = count;
    //         isInCart = false;
    //         return;
    //       }
    //     });
    //   }
    // }
    // notifyListeners();
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
