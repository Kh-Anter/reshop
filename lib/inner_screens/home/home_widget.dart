import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/carousel.dart';
import '../../consts/constants.dart';
import '../../screens/category_screen/category_screen.dart';
import '../../widgets/product_card.dart';
import '../../consts/size_config.dart';
import '../../providers/dummyData.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  SizeConfig size = SizeConfig();
  PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DummyData>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Carousel(),
          SizedBox(
            height: size.getProportionateScreenHeight(15),
          ),
          seeMore(text: "Categories"),
          Container(
              height: 70,
              alignment: Alignment.center,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                    Constants.categories.length,
                    (index) => Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: buildCategories(
                              image: Constants.categories[index]["image"]
                                  .toString(),
                              text: Constants.categories[index]["text"]),
                        )),
              )),
          seeMore(text: "Best Sellers"),
          homeProducts(category: provider.getBestSellers()),
          seeMore(text: "LifeStyle Products"),
          homeProducts(category: provider.getLifeStyle()),
        ],
      ),
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
            height: 50,
            width: 50,
            child: Image.asset(image),
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
                    Provider.of<DummyData>(context, listen: false)
                        .changeBottonNavigationBar(newValue: 1);
                  }
                  break;
                case "Best Sellers":
                  Navigator.pushNamed(context, CategoryScreen.routeName,
                      arguments: text);
                  break;
                case "LifeStyle Products":
                  Navigator.pushNamed(context, CategoryScreen.routeName,
                      arguments: text);
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
