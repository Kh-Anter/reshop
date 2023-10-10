import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/models/product.dart';
import 'package:reshop/providers/address_provider.dart';
import 'package:reshop/providers/cart/cart_provider.dart';
import 'package:reshop/providers/favourites.dart';
import 'package:reshop/widgets/custom_pageview.dart';
import '../providers/dummyData.dart';
import '../consts/size_config.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({required this.product, Key? key}) : super(key: key);

  static const routeName = "/productDetails";

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  SizeConfig size = SizeConfig();
  PageController pageController = PageController(initialPage: 0);
  TextEditingController countController = TextEditingController(text: "1");
  late dynamic authReadWrite;
  late dynamic cartProvider;
  var uid = FirebaseAuth.instance.currentUser?.uid;
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    size.init(context);
    // var dummyData = Provider.of<DummyData>(context);
    authReadWrite = Provider.of<AddressProvider>(context);
    cartProvider = Provider.of<CartProvider>(context);
    isFav = widget.product.isFav;
    return Scaffold(
      appBar: appBar(),
      bottomNavigationBar: bottomWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomPageView(productImages: widget.product.images),
            Text(
              widget.product.title!,
              maxLines: 1,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              widget.product.brand!,
              style:
                  TextStyle(fontSize: 16, color: Color.fromRGBO(1, 1, 1, 0.5)),
            ),
            SizedBox(height: 15),
            Row(children: [productPrice(), Spacer(), productCount()]),
            SizedBox(height: 5),
            productRate(),
            SizedBox(height: 5),
            productDetails(),
          ]),
        ),
      ),
    );
  }

  appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: (() {
          Navigator.pop(context);
        }),
      ),
    );
  }

  productPrice() {
    return Padding(
      padding: EdgeInsets.only(left: 7),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: myPrimaryLightColor,
            borderRadius: BorderRadius.all(Radius.circular(7))),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Text("${widget.product.price} L.E",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    //fontFamily: 'Varela',
                    fontSize: 20))),
      ),
    );
  }

  productCount() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              if (countController.text.isNotEmpty) {
                int value = int.parse(countController.value.text);
                if (value < 999) {
                  value++;
                  countController.text = value.toString();
                }
              }
            },
            icon: Icon(
              Icons.keyboard_arrow_up_sharp,
              color: myPrimaryColor,
              size: 35,
            )),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: mySecondTextColor),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          width: 40,
          height: 40,
          child: TextField(
            controller: countController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9]"))
            ],
            textAlign: TextAlign.center,
            maxLength: 3,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: "1",
              counterText: "",
              border: InputBorder.none,
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              if (countController.text.isNotEmpty) {
                int value = int.parse(countController.value.text);
                if (value > 1) {
                  value--;
                  countController.text = value.toString();
                }
              }
            },
            icon: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: myPrimaryColor,
              size: 35,
            ))
      ],
    );
  }

  productRate() {
    return Row(
      children: const [
        Icon(Icons.star, color: myPrimaryColor),
        Text(
          "  4.5",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  productDetails() {
    return SizedBox(
      height: 200,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            TabBar(
                labelColor: myPrimaryColor,
                unselectedLabelColor: Colors.black45,
                indicatorPadding: EdgeInsets.all(10),
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: "Description"),
                  Tab(text: "Reviews"),
                  Tab(text: "Specfications"),
                ]),
            Expanded(
              child: TabBarView(children: [
                Text(
                  widget.product.description ?? "",
                  style: TextStyle(color: Colors.black45),
                ),
                Text(
                  "Reviews",
                  style: TextStyle(color: Colors.black45),
                ),
                Text(
                  "Specfications",
                  style: TextStyle(color: Colors.black45),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  bottomWidget() {
    var dummyData = Provider.of<DummyData>(context);
    var favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);

    return Row(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: myPrimaryColor, width: 1),
              borderRadius: BorderRadius.circular(12)),
          child: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return IconButton(
                  onPressed: () {
                    // _favourites_provider.changeFavorite(uid, widget.product.id);
                    setState(() {
                      isFav = !isFav;
                    });
                    dummyData.changeFavInMyproduct(
                        productId: widget.product.id);
                    favouritesProvider.changeFavorite(uid, widget.product.id);
                  },
                  icon: isFav
                      ? Icon(Icons.favorite, color: myPrimaryColor)
                      : Icon(Icons.favorite_border_outlined,
                          color: Color.fromARGB(156, 120, 117, 117)));
            },
          ),
        ),
        Container(
            decoration: BoxDecoration(
                //  border: Border.all(color: myPrimaryColor, width: 1),
                borderRadius: BorderRadius.circular(12)),
            width: size.getWidth - 100,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                cartProvider.addToCart(widget.product, context,
                    count: int.parse(countController.text));
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.red))),
              ),
              child: Text(
                "Add to Cart",
                style: TextStyle(fontSize: 18),
              ),
            ))
      ],
    );
  }
}
