import 'package:flutter/cupertino.dart';

class Product {
  int id;
  int sellCount = 0;
  String title;
  Enum category;
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
      this.price,
      this.isFav,
      this.images,
      this.brand,
      this.description});
}
