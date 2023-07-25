import 'package:flutter/material.dart';

class OnBoardingScreenModel with ChangeNotifier {
  final String title;
  final String description;
  final String imgUrl;
  OnBoardingScreenModel(
      {required this.title, required this.description, required this.imgUrl});
}
