import 'package:flutter/material.dart';

const myPrimaryColor = Color.fromRGBO(227, 52, 52, 1);
const myPrimaryLightColor = Color.fromRGBO(227, 52, 52, 0.10);
const myAnimationDuration = Duration(milliseconds: 400);
const mySecondTextColor = Color.fromRGBO(0, 0, 0, 0.30);
const myTextFieldBorderColor = Color.fromRGBO(112, 112, 112, 1);
const myTextFieldBackgroundColor = Color.fromRGBO(239, 239, 239, 1);
const elevatedBtnColor = Color.fromRGBO(208, 208, 208, 1);
const unselectedNavigationBar = Color.fromRGBO(0, 0, 0, 0.20);
const TextStyle selectedTitleStyle = TextStyle(
    color: Colors.black,
    fontSize: 34,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline);
const TextStyle unselectedTitleStyle = TextStyle(
  color: mySecondTextColor,
  fontSize: 28,
  fontWeight: FontWeight.bold,
);

class Constants {
  static Map<String, List> subCategories = {
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

  static List brands = ["Adidas", "Squadra", "MyHome"];
  static List<Map> categories = [
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
  static List<Map<String, String>> splashScreen = [
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
  static List homeCarousel = [
    "assets/images/carousel_card1.png",
    "assets/images/carousel_card2.png",
    "assets/images/carousel_card1.png"
  ];
}
