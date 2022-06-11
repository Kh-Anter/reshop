import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reshop/models/product.dart';

import '../models/product.dart';
import '../enums.dart';

class DummyData with ChangeNotifier {
  List bestSeller = [];
  List lifeStyle = [];
  int currentPageView = 0;
  int bottomNavigationBar = 0;
  //AppBar customAppBar=null;

  void changeFav(id) {
    myProducts.forEach((element) {
      if (element.id == id) {
        element.isFav = !element.isFav;
      }
    });
    notifyListeners();
  }

  void changeBottonNavigationBar({int newValue}) {
    bottomNavigationBar = newValue;
    notifyListeners();
  }

  void changePageview(int newValue) {
    currentPageView = newValue;
    notifyListeners();
  }

  List<Product> myProducts = [
    Product(
        id: 1,
        sellCount: 0,
        title: "ADIDAS DEO BODY SPY 150ML CHAMPIONS LEAGUS",
        category: Categories.Beauty,
        price: 100,
        isFav: true,
        images: [
          "assets/images/products/Categories/beauty/adidas/adidas1.jpg",
          "assets/images/products/Categories/beauty/adidas/adidas2.jpg",
          "assets/images/products/Categories/beauty/adidas/adidas3.jpg"
        ],
        brand: "Adidas",
        description:
            "Dare Edition Deo Body Spray – The Dare Edition captures the courage and nerve strength of the players, who believe that everything is possible in the game. You will not be afraid of any risk and press your own personal stamp on each game. With every spraying, the dare edition inspires to take risks of inner size and courage to seize chances and to provide exceptional results. Spicy and aromatic at the same time, the dare Edition captures the tension-charged tingling of game-decisive moments. Dare to achieve exceptional results."),
    Product(
        id: 2,
        sellCount: 1,
        title: "Dove Intensive Softening Cream, 250 ml",
        category: Categories.Beauty,
        price: 120,
        isFav: true,
        images: [
          "assets/images/products/Categories/beauty/dove/Dove1.jpg",
          "assets/images/products/Categories/beauty/dove/Dove2.jpg"
        ],
        brand: "Dove",
        description: """Brand: Dove
          Category Type: Face
          Suitable Skin Type: Dry
          Size: 250 ml
          Type: Moisturizers
          Texture: Cream
          Recommended Use: Softening & Rejuvenation
          EAN-13: 8886467020148
          Details: An extra rich, fast absorbing cream that softens, smoothest and intensively moistures dry skin. Designed to bring moisture back to patches of dry skin. It is a great all-purpose product and an ideal solution for your dry skin woes."""),
    Product(
        id: 3,
        sellCount: 2,
        title: "Ever Beauty Makeup Studio Eyeshadow Palette",
        category: Categories.Beauty,
        price: 200,
        isFav: false,
        images: [
          "assets/images/products/Categories/beauty/makeup/Makeup1.jpg",
          "assets/images/products/Categories/beauty/makeup/Makeup2.jpg",
          "assets/images/products/Categories/beauty/makeup/Makeup3.jpg"
        ],
        brand: "Ever beauty",
        description: """Ever Beauty Makeup Studio Eyeshadow Palette
Brand: Ever beauty
Item type: Eyeshadow palette
Suitable for all skin types
Long-lasting
Fit for everyday use
Easy to blend
Lightweight texture"""),
    Product(
        id: 4,
        sellCount: 3,
        title: "Nivea Deo Pearl & Beauty Spray for Women 150ml",
        category: Categories.Beauty,
        price: 100,
        isFav: false,
        images: [
          "assets/images/products/Categories/beauty/nivea/Nivea1.jpg",
          "assets/images/products/Categories/beauty/nivea/Nivea2.jpg",
          "assets/images/products/Categories/beauty/nivea/Nivea3.jpg",
          "assets/images/products/Categories/beauty/nivea/Nivea4.jpg",
          "assets/images/products/Categories/beauty/nivea/Nivea5.jpg",
        ],
        brand: "Nivea",
        description: """Pearl & Beauty Anti-perspirant Deodorant Spray
IVEA Pearl & Beauty anti-perspirant deodorant with precious pearl extracts evens out your skin tone and offers you velvety smooth & beautiful underarms. The deodorant combines 48 hours reliable protection against sweat and body odour with care for your underarm skin. A modern airy accord infused with a sparkling berry cocktail in the top notes gives instant freshness to this creation before juicy peach and a delicate floral bouquet of violet, jasmin, freesia and muguet unveil in the heart. Base notes of creamy sandalwood, warm vanilla and soft musk give a caring and powdery beauty facet to this creation."""),
    Product(
        id: 5,
        sellCount: 32,
        title: "POND'S Bright Beauty Spot Less Glow Serum Facial Foam 100gm",
        category: Categories.Beauty,
        price: 150,
        isFav: true,
        images: [
          "assets/images/products/Categories/beauty/pond's/POND'S1.jpg",
          "assets/images/products/Categories/beauty/pond's/POND'S2.jpg",
          "assets/images/products/Categories/beauty/pond's/POND'S3.jpg",
          "assets/images/products/Categories/beauty/pond's/POND'S4.jpg"
        ],
        brand: "Pond's",
        description: """Brand: POND'S
Type: Facial Foam
Size: 100 grams
Deeply cleanses the face and reduces dullness while boosting the radiance of your skin.
Reduces dark spots and lightens the skin."""),
    Product(
        id: 6,
        sellCount: 5,
        title: "Galaxy Z Fold 3 , 128 GB , Phantom Black",
        category: Categories.Electronics,
        subCat: "Smart Phones",
        price: 7000,
        isFav: false,
        images: [
          "assets/images/products/Categories/electronics/galaxy/galaxy.png",
          "assets/images/products/Categories/electronics/galaxy/galaxy2.png",
          "assets/images/products/Categories/electronics/galaxy/galaxy3.jpg"
        ],
        brand: "Samsung",
        description:
            """Expansive Screen: See more and do more with the ultimate folding mobile phone screen that puts a super slim tablet right in your pocket
Nearly Invisible Camera: Take in an incredible uninterrupted view with a true edge-to-edge viewing experience thanks to our first-ever Under Display Camera
120Hz AMOLED 2X Screen: Everything looks brilliant on this big, beautiful, clear display, offering a mesmerizing and dynamic viewing experience
Multiple Windows Get More Done: Start working smarter not harder with three multi-windows tha"""),
    Product(
        id: 7,
        sellCount: 6,
        title: "beats solo 3 wireless , Black",
        category: Categories.Electronics,
        subCat: "Accessories",
        price: 599,
        isFav: true,
        images: [
          "assets/images/products/Categories/electronics/headphone/headphone.png",
          "assets/images/products/Categories/electronics/headphone/headphone2.jpg",
          "assets/images/products/Categories/electronics/headphone/headphone3.jpeg"
        ],
        brand: "Beats",
        description: ""),
    Product(
        id: 8,
        sellCount: 19,
        title: "Apple iPhone 12 128GB Blue",
        category: Categories.Electronics,
        subCat: "Smart Phones",
        price: 14000,
        isFav: true,
        images: [
          "assets/images/products/Categories/electronics/iphone12/Apple iPhone 12_1.jpg",
          "assets/images/products/Categories/electronics/iphone12/Apple iPhone 12_2.jpg",
          "assets/images/products/Categories/electronics/iphone12/Apple iPhone 12_3.jpg"
        ],
        brand: "Apple",
        description: """6.1-inch Super Retina XDR display
Ceramic Shield, tougher than any smartphone glass
A14 Bionic chip, the fastest chip ever in a smartphone
Advanced dual-camera system with 12MP Ultra Wide and Wide cameras; Night mode, Deep Fusion, Smart HDR 3, 4K Dolby Vision HDR recording
12MP TrueDepth front camera with Night mode, 4K Dolby Vision HDR recording"""),
    Product(
        id: 9,
        sellCount: 24,
        title:
            "Apple iPhone 13 Pro Max with FaceTime - 256GB, 6GB RAM, 4G LTE, Sierra Blue, Single SIM & E-SIM",
        category: Categories.Electronics,
        subCat: "Smart Phones",
        price: 23000,
        isFav: false,
        images: [
          "assets/images/products/Categories/electronics/iphone13 pro/Apple iPhone 13 Pro1.jpg",
          "assets/images/products/Categories/electronics/iphone13 pro/Apple iPhone 13 Pro2.jpg",
          "assets/images/products/Categories/electronics/iphone13 pro/Apple iPhone 13 Pro3.jpg",
          "assets/images/products/Categories/electronics/iphone13 pro/Apple iPhone 13 Pro4.jpg",
          "assets/images/products/Categories/electronics/iphone13 pro/Apple iPhone 13 Pro5.jpg"
        ],
        brand: "Apple",
        description:
            """6.7-inch Super Retina XDR display with ProMotion for a faster, more responsive feel
Cinematic mode adds shallow depth of field and shifts focus automatically in your videos
Pro camera system with new 12MP Telephoto, Wide, and Ultra Wide cameras; LiDAR Scanner; 6x optical zoom range; macro photography; Photographic Styles, ProRes video, Smart HDR 4, Night mode, Apple ProRAW, 4K Dolby Vision HDR recording
12MP TrueDepth front camera with Night mode, 4K Dolby Vision HDR recording
A15 Bionic chip for lightning-fast performance"""),
    Product(
        id: 10,
        sellCount: 12,
        title: "Fashion Slip On Casual Shoes For Women",
        category: Categories.Fashion,
        price: 180,
        isFav: true,
        images: [
          "assets/images/products/Categories/Fashion/Fashion Slip/Slip1.jpg",
          "assets/images/products/Categories/Fashion/Fashion Slip/Slip2.jpg",
          "assets/images/products/Categories/Fashion/Fashion Slip/Slip3.jpg",
          "assets/images/products/Categories/Fashion/Fashion Slip/Slip4.jpg"
        ],
        brand: "Fashion",
        description: """Brand: Fashion
Color: Cafe
Material: Canvas
Targeted Group: Women
Size: 38 EU"""),
    Product(
        id: 11,
        sellCount: 40,
        title:
            "Squadra Textile Contrast Collar Mid-Top Lace-Up Fashion Sneakers for Men",
        category: Categories.Fashion,
        price: 200,
        isFav: true,
        images: [
          "assets/images/products/Categories/Fashion/Fashion Sneakers/Squadra1.jpg",
          "assets/images/products/Categories/Fashion/Fashion Sneakers/Squadra2.jpg",
          "assets/images/products/Categories/Fashion/Fashion Sneakers/Squadra3.jpg",
          "assets/images/products/Categories/Fashion/Fashion Sneakers/Squadra4.jpg",
          "assets/images/products/Categories/Fashion/Fashion Sneakers/Squadra5.jpg",
        ],
        brand: "Squadra",
        description: """Brand: Squadra
Type: Fashion Sneakers
Material: Textile
Size: 41 EU
Color: Black"""),
    Product(
        id: 12,
        sellCount: 45,
        title:
            "My Home Wooden Coasters - Set of 4 Pieces, Multi Shapes - 2724746499598",
        category: Categories.Home,
        price: 80,
        isFav: false,
        images: [
          "assets/images/products/Categories/homee/Home Wooden Coasters/Home Wooden Coasters.jpg"
        ],
        brand: "My Home",
        description:
            """Item :My Home Wooden Coasters - Set of 4 Pieces, Multi Shapes
Specifications:-
Brand: My Home
Type:Coasters
Material: Wood"""),
    Product(
        id: 13,
        sellCount: 32,
        title: "Home Wooden Coasters 5 Blade Kitchen Scissors",
        category: Categories.Home,
        price: 100,
        isFav: false,
        images: [
          "assets/images/products/Categories/homee/Kitchen Scissors/Kitchen Scissors.jpg"
        ],
        brand: "My Home",
        description:
            "This Home Stainless Steel 5 Blade Kitchen Scissors is the right tool for cutting packets of ingredients like spices, while cooking. The scissor is made from premium quality material and can cut through materials like paper and plastic with ease."),
    Product(
        id: 14,
        sellCount: 2,
        title:
            "SHOWAY Egg cooker Frying Pan, 4-Cups non-stick cookware Aluminium Alloy Fried Egg Cooker,Pancake,omelette pan,egg poacher",
        category: Categories.Kitchen,
        price: 300,
        isFav: false,
        images: [
          "assets/images/products/Categories/kitchen/SHOWAY Egg cooker/SHOWAY Egg cooker1.jpg",
          "assets/images/products/Categories/kitchen/SHOWAY Egg cooker/SHOWAY Egg cooker2.jpg",
          "assets/images/products/Categories/kitchen/SHOWAY Egg cooker/SHOWAY Egg cooker3.jpg",
          "assets/images/products/Categories/kitchen/SHOWAY Egg cooker/SHOWAY Egg cooker4.jpg"
        ],
        brand: "",
        description:
            """The pan features the optimal material, which is featured by the non-stick coating of Maifan stone,, and the pan is non-stick, abrasion-resistant and durable, and the pan featrues the beautiful, and the pan features the heat insulation and anti-scalding, comfortable grip.
Fine Craft: The pan features the thick pot body design, which is featrued by the large-capacity, thus making cooking easier.
Fine Design: The pan features the stainless steel anti-burning ring, which is also featured by the anti-scalding design, and the pan is heat-resistant.
Practical to Use: The pan features the intelligent temperature control and the premium bottom, which is featured by the fine shape to achieve the even heat conduction, and the bottom of it is not sticky and it is practical for most stoves.
Multiple Purpose: The pan can be used to make omelette, burger and the like, and the pan features 4 compartments to make cooking quick and easy."""),
    Product(
        id: 15,
        sellCount: 32,
        title: "Trueval Rectangular Oven tray set 2 pieces, sizes 25-35",
        category: Categories.Kitchen,
        price: 800,
        isFav: false,
        images: [
          "assets/images/products/Categories/kitchen/Trueval Rectangular/Trueval Rectangular1.jpg",
          "assets/images/products/Categories/kitchen/Trueval Rectangular/Trueval Rectangular2.jpg",
          "assets/images/products/Categories/kitchen/Trueval Rectangular/Trueval Rectangular3.jpg"
        ],
        brand: "Trueval",
        description: """Essential Bakeware
The oven tray set is specially designed for baking a variety of sweet and savory dishes. With its aluminum build, the bake tray withstands the oven environment and supports long-term use.

Convenient for User

The bake tray is designed with Teflon-coated surfaces that ensure non-stick protection. This facilitates residue-free food removal and effortless cleaning. You can stack the trays and store them in tight spaces easily."""),
    Product(
        id: 16,
        sellCount: 21,
        title:
            "11 Pcs Resistance Fitness Band Set with Stackable Exercise Bands Legs Ankle Straps Multi-function Professional Fitness Equipment",
        category: Categories.Sport,
        price: 1200,
        isFav: false,
        images: [
          "assets/images/products/Categories/Sport/11 Pcs Resistance Fitness Band Set/11 Pcs Resistance Fitness Band Set1.jpg",
          "assets/images/products/Categories/Sport/11 Pcs Resistance Fitness Band Set/11 Pcs Resistance Fitness Band Set2.jpg",
          "assets/images/products/Categories/Sport/11 Pcs Resistance Fitness Band Set/11 Pcs Resistance Fitness Band Set3.jpg",
          "assets/images/products/Categories/Sport/11 Pcs Resistance Fitness Band Set/11 Pcs Resistance Fitness Band Set4.jpg",
          "assets/images/products/Categories/Sport/11 Pcs Resistance Fitness Band Set/11 Pcs Resistance Fitness Band Set5.jpg",
          "assets/images/products/Categories/Sport/11 Pcs Resistance Fitness Band Set/11 Pcs Resistance Fitness Band Set6.jpg",
          "assets/images/products/Categories/Sport/11 Pcs Resistance Fitness Band Set/11 Pcs Resistance Fitness Band Set7.jpg",
          "assets/images/products/Categories/Sport/11 Pcs Resistance Fitness Band Set/11 Pcs Resistance Fitness Band Set8.jpg",
          "assets/images/products/Categories/Sport/11 Pcs Resistance Fitness Band Set/11 Pcs Resistance Fitness Band Set9.jpg"
        ],
        brand: "Adidas",
        description: """Features:
Resistance bands are made of latex tubing with great elasticity and good durability.
They are light weight, portable and space saving exercise equipment.
Designed to effectively building muscle strength and tone the body.
Strong cushioned foam handles with Zinc alloy clips and D-Ring
Perfect for Yoga, ABS, P90X workout.
Different resistance level from 5kg to 20kg to accommodate for progressive strength training levels
These tubes have 5 levels of resistance and can be used 1, 2, 3, 4 or all 5 at a time.

Specifications:
Color: Red, green, blue, yellow, black
Material: Latex
Band length: 1.2m
Package size: 19 * 16 * 11cm
Total weight: 455g

Package Included:
5 * Resistant Bands
1 * Door Anchor
2 * Ankle Straps
2 * Foam Handles
1 * Travel Pouch"""),
    Product(
        id: 17,
        sellCount: 14,
        title:
            "Sport Cycling Fitness GYM Weightlifting Exercise Half Finger Sport Gloves for Women",
        category: Categories.Sport,
        price: 270,
        isFav: false,
        images: [
          "assets/images/products/Categories/Sport/Sport Gloves/Sport Gloves1.jpg",
          "assets/images/products/Categories/Sport/Sport Gloves/Sport Gloves2.jpg",
          "assets/images/products/Categories/Sport/Sport Gloves/Sport Gloves3.jpg"
        ],
        brand: "Adidas",
        description:
            "High quality material ensures maximum comfort Suitable for various sports activities Antimicrobial treatment fights offensive odors and bacterial growth."),
  ];

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
    {"text": "Beauty", "image": "assets/images/categories/beauty_icon2.png"},
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
      "Other sports"
    ],
    "Kitchen": ["All", "Water coolers", "Filters", "Glasses", "Accessories"]
  };

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
      if (myProducts[i].category.name == category) {
        productByCat.add(myProducts[i]);
      }
    }
    return productByCat;
  }

  getBySubCat(List all, String subCategor) {
    List<Product> other = [];
    var myAll = all;
    for (int i = 0; i < all.length; i++) {
      print("subcat ${myAll[i].subCat}");
      if (all[i].subCat == subCategor) {
        other.add(all[i]);
      }
    }
    print("--------------hhhhhhh other length ${other.length}");
    return other;
  }
}
