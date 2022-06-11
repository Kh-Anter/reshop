import 'package:flutter/cupertino.dart';

class Product {
  int id;
  int sellCount = 0;
  String title;
  Enum category;
  String subCat;
  int price;
  bool isFav;
  List<String> images;
  String brand;
  String description;

  Product(
      {this.id,
      this.sellCount,
      this.title,
      this.category,
      this.subCat,
      this.price,
      this.isFav,
      this.images,
      this.brand,
      this.description});
}
