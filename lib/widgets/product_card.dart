import 'package:flutter/material.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/models/product.dart';

class ProductCart extends StatelessWidget {
  final Product product;
  const ProductCart({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: InkWell(
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ProductDetails(id)));
            },
            child: Container(
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
                        child: Container(
                          alignment: Alignment.topRight,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(product.images[0]),
                          )),
                          child: IconButton(
                              onPressed: () {
                                // provider2.changeFav(id);
                              },
                              icon: product.isFav
                                  ? const Icon(
                                      Icons.favorite,
                                      color: myPrimaryColor,
                                    )
                                  : const Icon(Icons.favorite_border_outlined,
                                      color:
                                          Color.fromARGB(156, 120, 117, 117))),
                        ),
                      ),
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
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ]))));
  }
}
