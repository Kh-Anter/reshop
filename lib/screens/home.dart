import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/enums.dart';
import 'package:reshop/providers/add_products.dart';
import 'package:reshop/screens/search_screen.dart';
import 'package:reshop/size_config.dart';
import 'package:reshop/widgets/home_widgets/cart_widget.dart';
import 'package:reshop/widgets/home_widgets/categories_widget.dart';
import 'package:reshop/widgets/home_widgets/profile_widget.dart';
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
  bool _isloading = false;
  bool init = true;
  @override
  void initState() {
    // DummyData.getAllProducts();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (init) {
      setState(() {
        _isloading = true;
      });
      await Provider.of<DummyData>(context).FetchAllProducts();
      setState(() {
        _isloading = false;
      });
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var customAppbar = appBarCreator(
        title: Container(
            width: 100,
            height: 50,
            child: Image.asset("assets/images/splash.png")),
        action: [
          TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => SearchScreen())));
              },
              label: Text("Search",
                  style: TextStyle(
                      color: mySecondTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.normal)),
              icon: Icon(Icons.search, size: 24))
        ]);

    var homeAppbar = appBarCreator(
        title: Container(
            width: 100,
            height: 50,
            child: Image.asset("assets/images/splash.png")),
        action: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) => SearchScreen())));
            },
            label: Text(
              "Search",
              style: TextStyle(
                  color: mySecondTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
            icon: Icon(Icons.search, size: 24),
          ),
        ]);

    var categoriesAppbar = appBarCreator(
        title: Text("Categories",
            style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.w500)));

    var offersAppbar = appBarCreator();

    var cartAppbar = appBarCreator(
        title: Text("My Cart",
            style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold)));
    var profileAppbar = appBarCreator(
        title: Text("My Profile",
            style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold)));

    final provider = Provider.of<DummyData>(context);
    int _currentIndex = provider.bottomNavigationBar;
    SizeConfig _size = SizeConfig();
    _size.init(context);
    var _oriantation = _size.getOriantation;

    switch (_currentIndex) {
      case 0:
        {
          customAppbar = homeAppbar;
        }
        break;
      case 1:
        {
          customAppbar = categoriesAppbar;
        }
        break;
      case 2:
        {
          customAppbar = offersAppbar;
        }
        break;
      case 3:
        {
          customAppbar = cartAppbar;
        }
        break;
      case 4:
        {
          customAppbar = profileAppbar;
        }
        break;
    }

    return Scaffold(
      appBar: customAppbar,
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
        onTap: (index) => provider.changeBottonNavigationBar(newValue: index),
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
          child: _isloading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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

  AppBar appBarCreator({title, action}) {
    return AppBar(
      title: title,
      actions: action,
      elevation: 0,
    );
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
        break;
      case 2:
        {
          return;
        }
        break;
      case 3:
        {
          return CartWidget();
        }
        break;
      case 4:
        {
          return ProfileWidget();
        }
        break;
    }
  }
}
