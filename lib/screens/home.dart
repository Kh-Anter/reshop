import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/consts/constants.dart';
import '../widgets/loading_widget.dart';
import 'package:reshop/providers/chart/cart_provider.dart';
import 'package:reshop/screens/search_screen.dart';
import 'package:reshop/consts/size_config.dart';
import 'package:reshop/inner_screens/home/cart_widget.dart';
import 'package:reshop/inner_screens/home/categories_widget.dart';
import 'package:reshop/inner_screens/home/offers.dart';
import 'package:reshop/inner_screens/home/profile_widget.dart';
import '../providers/dummyData.dart';
import '../inner_screens/home/home_widget.dart';
import 'package:badges/badges.dart' as badges;

class Home extends StatefulWidget {
  static String routeName = "/Home";
  const Home({Key? key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool isloading = false;
  bool init = true;
  List<Map<String, dynamic>>? pages;

  @override
  void initState() {
    var homeAppbar = appBarCreator(
        titleWidget: SizedBox(
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
    var categoriesAppbar = appBarCreator(titleTxt: "Categories");
    var offersAppbar = appBarCreator(titleTxt: "Offers");
    var cartAppbar = appBarCreator(titleTxt: "My Cart");
    var profileAppbar = appBarCreator(titleTxt: "My Profile");
    pages = [
      {"page": HomeWidget(), "appbar": homeAppbar},
      {"page": CategoriesWidget(), "appbar": categoriesAppbar},
      {"page": Offers(), "appbar": offersAppbar},
      {"page": CartWidget(), "appbar": cartAppbar},
      {"page": ProfileWidget(), "appbar": profileAppbar},
    ];
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (init) {
      setState(() {
        isloading = true;
      });

      await Provider.of<DummyData>(context).fetchAllProducts(context);

      setState(() {
        isloading = false;
      });
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DummyData>(context, listen: true);
    Provider.of<CartProvider>(context).readCart(context);
    SizeConfig size = SizeConfig();
    size.init(context);
    int currentIndex = provider.bottomNavigationBar;

    return LoadingWidget(
      isLoading: isloading,
      child: Scaffold(
        appBar: pages![currentIndex]["appbar"],
        bottomNavigationBar: myBottomNavBar(currentIndex, provider),
        body: SafeArea(
          child: child(currentIndex),
        ),
      ),
    );
  }

  Widget child(currentIndex) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: SizeConfig.screenWidth - 20,
        child: pages![currentIndex]["page"],
      ),
    );
  }

  AppBar appBarCreator(
      {String? titleTxt, List<Widget>? action, Widget? titleWidget}) {
    return AppBar(
      title: titleTxt != null
          ? Text(titleTxt,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold))
          : titleWidget,
      actions: action,
      elevation: 0,
    );
  }

  BottomNavigationBar myBottomNavBar(int currentIndex, provider) {
    return BottomNavigationBar(
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
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          provider.bottomNavigationBar = index;
        });
      },
      items: [
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
          label: 'Cart',
          activeIcon: Icon(Icons.shopping_cart),
          icon: Consumer<CartProvider>(builder: (context, value, child) {
            print("-------------->--${value.myCart}");
            if (value.myCart.isNotEmpty) {
              return badges.Badge(
                badgeContent: Text(
                  value.myCart.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: Icon(Icons.shopping_cart_outlined),
              );
            } else {
              return Icon(Icons.shopping_cart_outlined);
            }
          }),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
            activeIcon: Icon(Icons.person)),
      ],
    );
  }
}
