import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/screens/category_screen/category_screen.dart';

import '../product_card.dart';
import '../build_dot.dart';
import '../../size_config.dart';
import '../../providers/dummyData.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  SizeConfig _size = SizeConfig();
  PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DummyData>(context);
    var currentPage = 0;
    return Column(
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
                  height: SizeConfig().getProportionateScreenHeight(150));
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
        BuildDot(
          length: 3,
        ),
        seeMore(text: "Categories"),
        Container(
            height: 70,
            alignment: Alignment.center,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                  provider.categories.length,
                  (index) => Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: buildCategories(
                            image:
                                provider.categories[index]["image"].toString(),
                            text: provider.categories[index]["text"]),
                      )),
            )),
        seeMore(text: "Best Sellers"),
        homeProducts(category: provider.getBestSellers()),
        seeMore(text: "LifeStyle Products"),
        homeProducts(category: provider.getLifeStyle()),
      ],
    );
  }

  Container homeProducts({category}) {
    if (category.isEmpty) {
      return Container();
    } else {
      return Container(
          constraints: BoxConstraints(
              maxHeight: 250,
              minHeight: SizeConfig().getProportionateScreenHeight(200)),
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

  Widget buildCategories({image, text}) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoryScreen.routeName, arguments: text);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(7),
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
      ),
    );
  }

  Container seeMore({text}) {
    final provider = Provider.of<DummyData>(context);
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
            onPressed: () {
              switch (text) {
                case "Categories":
                  {
                    provider.changeBottonNavigationBar(newValue: 1);
                  }
              }
            },
          ),
        ],
      ),
    );
  }
}
