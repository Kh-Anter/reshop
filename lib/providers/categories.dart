import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reshop/models/categories.dart';

class CategoriesProvider with ChangeNotifier {
  List<Categories> allCategories = [];
  Future<void> init() async {
    allCategories = await fetchOnboardingScreens();
  }

  Future<List<Categories>> fetchOnboardingScreens() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.docs
        .map((doc) => Categories(
              name: doc['name'],
              imgUrl: doc['imgUrl'],
            ))
        .toList();
  }
}
