// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/providers/address_provider.dart';
// import 'package:reshop/providers/favourites.dart';
import 'package:reshop/widgets/product_card.dart';
import '../providers/dummyData.dart';
import '../consts/size_config.dart';

class FavouritesScreen extends StatefulWidget {
  static const routeName = "/favouritesScreen";
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  SizeConfig size = SizeConfig();

  @override
  Widget build(BuildContext context) {
    final authReadwrite = Provider.of<AddressProvider>(context);
    final dummyData = Provider.of<DummyData>(context, listen: false);
    // final favouritesProvider = Provider.of<FavouritesProvider>(context);
    size.init(context);
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
      body: Padding(
          padding: EdgeInsets.all(10),
          child: getFavourites(authReadwrite, dummyData)),
    );
  }

  Widget getFavourites(authReadwrite, dummyData) {
    return FutureBuilder(
      future: dummyData.getFavProduct(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.length == 0) {
            return buildEmptyFav(dummyData);
          } else {
            return buildFav(snapshot.data);
          }
        } else {
          return Text("Something went wrong");
        }
      },
    );
  }

  Widget buildFav(myFav) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: myFav.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.8,
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8),
        itemBuilder: (BuildContext context, int index) {
          return ProductCart(
            product: myFav[index],
          );
        });
  }

  Widget buildEmptyFav(dummyData) {
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
            children: const [
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
            width: size.getWidth / 2,
            height: 45,
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                onPressed: () {
                  Navigator.of(context).pop();
                  dummyData.changeBottonNavigationBar(newValue: 0);
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
}
