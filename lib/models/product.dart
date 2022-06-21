import 'package:flutter/cupertino.dart';

class Product {
  String id;
  int sellCount = 0;
  String title;
  String category;
  String subCat;
  int price;
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
      this.images,
      this.brand,
      this.description});
}
