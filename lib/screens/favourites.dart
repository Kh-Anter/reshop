import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/models/product.dart';
import 'package:reshop/widgets/product_card.dart';

import '../providers/dummyData.dart';
import '../size_config.dart';

class FavouritesScreen extends StatefulWidget {
  static const routeName = "/favouritesScreen";
  const FavouritesScreen({Key key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  SizeConfig _size = SizeConfig();
  @override
  Widget build(BuildContext context) {
    _size.init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Favourites",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: Padding(padding: EdgeInsets.all(10), child: myFavourites()),
    );
  }

  Widget myFavourites() {
    /*
    var provider = Provider.of<DummyData>(context);
    List<Product> favList = [];
    provider.myProducts.forEach(
      (element) {
        if (element.isFav) {
          favList.add(element);
        }
      },
    );
    if (favList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.heart_broken_outlined,
              color: mySecondTextColor,
              size: 200,
            ),
            Text(
              "No favourites yet !",
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "press ",
                  style: TextStyle(fontSize: 12, color: mySecondTextColor),
                ),
                Icon(
                  Icons.favorite_border,
                  size: 16,
                  color: mySecondTextColor,
                ),
                Text(
                  " to add items in favourites",
                  style: TextStyle(fontSize: 12, color: mySecondTextColor),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(30),
              width: _size.getWidth / 2,
              height: 45,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  onPressed: () {
                    Navigator.of(context).pop();
                    provider.changeBottonNavigationBar(newValue: 0);
                  },
                  child: Text(
                    "Continue Shopping",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: favList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.8,
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8),
        itemBuilder: (BuildContext context, int index) {
          return ProductCart(
            product: favList[index],
          );
        });
        */
  }
}
