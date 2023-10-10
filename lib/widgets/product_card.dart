// import 'package:fancy_shimmer_image/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/providers/cart/cart_provider.dart';
import 'package:reshop/providers/favourites.dart';
import '../providers/dummyData.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/models/product.dart';
import 'package:reshop/screens/product_details.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class ProductCart extends StatefulWidget {
  final Product product;
  const ProductCart({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    var dummyData = Provider.of<DummyData>(context);
    var favouritesProvider = Provider.of<FavouritesProvider>(context);
    var cartProvider = Provider.of<CartProvider>(context);
    var uid = FirebaseAuth.instance.currentUser?.uid;
    isFav = widget.product.isFav;

    return Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetails(
                            product: widget.product,
                          )));
            },
            child: Container(
                //constraints: BoxConstraints(minWidth: 200, minHeight: 300),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(7),
                              alignment: Alignment.center,
                              child: FancyShimmerImage(
                                imageUrl: widget.product.images[0],
                                boxFit: BoxFit.contain,
                              ),
                            ),
                            favBtn(dummyData, favouritesProvider, uid)
                          ],
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 7, right: 7, bottom: 7),
                          child: Text(widget.product.title ?? "",
                              maxLines: 1, style: TextStyle(fontSize: 14.0)),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      price(),
                      addToCartBtn(cartProvider),
                    ]))));
  }

  Widget addToCartBtn(cartProvider) {
    bool isInCart = cartProvider.isInCart(widget.product.id, context);
    return Flexible(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.only(left: 7, right: 7, bottom: 7, top: 3),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(),
            child: Text(
              isInCart ? "In Cart" : "Add To Cart",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  backgroundColor: myPrimaryColor),
            ),
            onPressed: () {
              if (!isInCart) {
                cartProvider.addToCart(widget.product, context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget price() {
    return Padding(
      padding: EdgeInsets.only(left: 7),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
                color: myPrimaryLightColor,
                borderRadius: BorderRadius.all(Radius.circular(7))),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                child: Text(
                    widget.product.off == null
                        ? "${widget.product.price} L.E"
                        : "${widget.product.price - (widget.product.off! / widget.product.price) * 100} L.E",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        //fontFamily: 'Varela',
                        fontSize: 14.0))),
          ),
          if (widget.product.off != null)
            Flexible(
              child: Text(
                " ${widget.product.price.toString()} L.E",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: mySecondTextColor,
                    decoration: TextDecoration.lineThrough,
                    fontSize: 14.0),
              ),
              //),
            ) //),
        ],
      ),
    );
  }

  Widget favBtn(dummyData, favouritesProvider, uid) {
    return Positioned(
      right: 7,
      top: 7,
      child: StatefulBuilder(
          builder: (context, setState) => Padding(
                padding: EdgeInsets.all(5),
                child: InkWell(
                    onTap: () {
                      setState(() {
                        isFav = !isFav;
                      });
                      dummyData.changeFavInMyproduct(
                          productId: widget.product.id);
                      favouritesProvider.changeFavorite(uid, widget.product.id);
                    },
                    child: isFav
                        ? Icon(Icons.favorite, color: myPrimaryColor)
                        : Icon(Icons.favorite_border_outlined,
                            color: Color.fromARGB(156, 120, 117, 117))),
              )),
    );
  }
}
