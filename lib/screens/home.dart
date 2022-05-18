import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/enums.dart';
import 'package:reshop/size_config.dart';
import 'package:reshop/widgets/product_card.dart';
import '../providers/dummyData.dart';

class Home extends StatefulWidget {
  static String routeName = "/Home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentPage = 0;
  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DummyData>(context);
    SizeConfig _size = SizeConfig();
    _size.init(context);
    var _oriantation = _size.getOriantation;
    return Scaffold(
      appBar: AppBar(
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
      ),
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
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              activeIcon: Icon(Icons.home)),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: _size.getWidth - 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  width: _size.getWidth,
                  height: _size.getProportionateScreenHeight(195),
                  child: PageView.builder(
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return Image.asset(provider.homePageView[index],
                          width: _size.getWidth - 100,
                          height:
                              SizeConfig().getProportionateScreenHeight(150));
                    },
                    itemCount: 3,
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: _size.getProportionateScreenHeight(15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => buildDot(index)),
                ),
                seeMore(text: "Categories"),
                Container(
                    height: 90,
                    alignment: Alignment.center,
                    child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: 1.2,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                          provider.categories.length,
                          (index) => buildCategories(
                              image: provider.categories[index]["image"]
                                  .toString(),
                              text: provider.categories[index]["text"])),
                    )),
                seeMore(text: "Best Sellers"),
                homeProducts(category: provider.getBestSellers().toList()),
                seeMore(text: "LifeStyle Products"),
                homeProducts(category: provider.getLifeStyle()),
              ],
            ),
          ),
          //),
        ),
      )),
    );
  }

  Container seeMore({text}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 21, color: Colors.black),
          ),
          TextButton(
            child: Text(
              "See more",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                  color: myPrimaryColor),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot(int index) {
    return AnimatedContainer(
      duration: myAnimationDuration,
      margin: EdgeInsets.only(right: 3),
      width: currentPage == index ? 22 : 10,
      height: 8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: currentPage == index ? myPrimaryColor : myPrimaryLightColor),
    );
  }

  Column buildCategories({image, text}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          child: Image.asset(image),
          height: 50,
          width: 50,
        ),
        SizedBox(
          height: 1,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.black),
        )
      ],
    );
  }

  Container homeProducts({category}) {
    return Container(
        height: SizeConfig().getProportionateScreenHeight(250),
        alignment: Alignment.center,
        child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 2.6 / 2,
          padding: EdgeInsets.all(2),
          scrollDirection: Axis.horizontal,
          children: List.generate(
            category.length,
            (index) => ProductCart(
              product: category[index],
            ),
          ),
        ));
  }
}
