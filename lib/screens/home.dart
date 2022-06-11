import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/enums.dart';
import 'package:reshop/size_config.dart';
import 'package:reshop/widgets/home_widgets/categories_widget.dart';
import 'package:reshop/widgets/product_card.dart';
import '../providers/dummyData.dart';
import '../widgets/build_dot.dart';
import '../widgets/home_widgets/home_widget.dart';

class Home extends StatefulWidget {
  static String routeName = "/Home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AppBar homeAppbar = AppBar(
    title: Container(
      width: 100,
      height: 50,
      child: Image.asset(
        "assets/images/splash.png",
      ),
    ),
    actions: [
      TextButton.icon(
        onPressed: () {},
        label: Text(
          "Search",
          style: TextStyle(
              color: mySecondTextColor,
              fontSize: 14,
              fontWeight: FontWeight.normal),
        ),
        icon: Icon(Icons.search, size: 20),
      ),
    ],
    elevation: 0,
  );
  AppBar customAppBar = AppBar(
    title: Container(
      width: 100,
      height: 50,
      child: Image.asset(
        "assets/images/splash.png",
      ),
    ),
    actions: [
      TextButton.icon(
        onPressed: () {},
        label: Text(
          "Search",
          style: TextStyle(
              color: mySecondTextColor,
              fontSize: 14,
              fontWeight: FontWeight.normal),
        ),
        icon: Icon(Icons.search, size: 20),
      ),
    ],
    elevation: 0,
  );
  AppBar categoriesAppbar = AppBar(
    title: Text(
      "Categories",
      style: TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    ),
    elevation: 0,
  );

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DummyData>(context);
    int _currentIndex = provider.bottomNavigationBar;
    SizeConfig _size = SizeConfig();
    _size.init(context);
    var _oriantation = _size.getOriantation;

    switch (_currentIndex) {
      case 0:
        {
          customAppBar = homeAppbar;
        }
        break;
      case 1:
        {
          customAppBar = categoriesAppbar;
        }
        break;
      case 2:
        {
          customAppBar = null;
        }
    }

    onTap(index) {
      provider.changeBottonNavigationBar(newValue: index);
    }

    return Scaffold(
      appBar: customAppBar,
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 28,
        selectedIconTheme: IconThemeData(color: myPrimaryColor),
        unselectedIconTheme: IconThemeData(color: unselectedNavigationBar),
        selectedLabelStyle: TextStyle(color: Colors.black),
        unselectedLabelStyle: TextStyle(color: unselectedNavigationBar),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        fixedColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        currentIndex: _currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: 'Categories',
              activeIcon: Icon(Icons.category)),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              label: 'Offers',
              activeIcon: Icon(Icons.local_offer)),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Cart',
              activeIcon: Icon(Icons.shopping_cart)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
              activeIcon: Icon(Icons.person)),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: _size.getWidth - 20,
            child: _homeBody(_currentIndex),
          ),
          //),
        ),
      )),
    );
  }
}

_homeBody(num) {
  switch (num) {
    case 0:
      {
        return HomeWidget();
      }
      break;
    case 1:
      {
        return CategoriesWidget();
      }
  }
}
