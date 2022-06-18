import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dummyData.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/models/product.dart';
import 'package:reshop/screens/product_details.dart';

class ProductCart extends StatelessWidget {
  final Product product;
  const ProductCart({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _dummyData = Provider.of<DummyData>(context);

    return Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetails(
                            productId: product.id,
                          )));
            },
            child: Container(
                // constraints: BoxConstraints(minWidth: 200, minHeight: 300),
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
                              child: Image.asset(product.images[0]),
                            ),
                            Positioned(
                              right: 7,
                              top: 7,
                              child: InkWell(
                                  onTap: () {
                                    _dummyData.changeFav(product.id);
                                  },
                                  child: product.isFav
                                      ? const Icon(
                                          Icons.favorite,
                                          color: myPrimaryColor,
                                        )
                                      : const Icon(
                                          Icons.favorite_border_outlined,
                                          color: Color.fromARGB(
                                              156, 120, 117, 117))),
                            )
                          ],
                        ),
                      ),
                      // Expanded(
                      //   flex: 5,
                      //   child: Container(
                      //     alignment: Alignment.topRight,
                      //     decoration: BoxDecoration(
                      //         image: DecorationImage(
                      //       image: AssetImage(product.images[0]),
                      //     )),
                      //     child: IconButton(
                      //         onPressed: () {
                      //           _dummyData.changeFav(product.id);
                      //         },
                      //         icon: product.isFav
                      //             ? const Icon(
                      //                 Icons.favorite,
                      //                 color: myPrimaryColor,
                      //               )
                      //             : const Icon(Icons.favorite_border_outlined,
                      //                 color:
                      //                     Color.fromARGB(156, 120, 117, 117))),
                      //   ),
                      // ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 7, right: 7, bottom: 7),
                          child: Text(product.title,
                              maxLines: 1, style: TextStyle(fontSize: 14.0)),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 7),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: myPrimaryLightColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 4),
                                child: Text(product.price.toString() + " L.E",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        //fontFamily: 'Varela',
                                        fontSize: 14.0))),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 7, right: 7, bottom: 7, top: 3),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              child: Text(
                                "Add To Cart",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    backgroundColor: myPrimaryColor),
                              ),
                              onPressed: () {
                                _dummyData.addToCart(
                                    productId: product.id, count: "1");
                              },
                            ),
                          ),
                        ),
                      ),
                    ]))));
  }
}
