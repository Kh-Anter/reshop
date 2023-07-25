import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  String? id;
  int sellCount = 0;
  String? title;
  String? category;
  String? subCat;
  int price;
  List<String> images;
  String? brand;
  String? description;
  bool isFav;
  int? off;

  Product(
      {this.id,
      required this.sellCount,
      this.title,
      this.category,
      this.subCat,
      required this.price,
      required this.images,
      this.brand,
      this.description,
      required this.isFav,
      this.off});

/*
  Product operator +(Product p) {
     Product p2 =  Product();
    p2.price = p.price + price;
    return p2;
  }

  static List<Product> filter(){
  }
*/
}
