import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/providers/auth_readwrite.dart';
import '../providers/dummyData.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/models/product.dart';
import 'package:reshop/screens/product_details.dart';

class ProductCart extends StatefulWidget {
  final Product product;
  const ProductCart({Key key, @required this.product}) : super(key: key);

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    var _dummyData = Provider.of<DummyData>(context);
    var _auth_readWrite = Provider.of<Auth_ReadWrite>(context);
    var uid = FirebaseAuth.instance.currentUser.uid;
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
                              child: Image.network(widget.product.images[0]),
                            ),
                            Positioned(
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
                                              _dummyData.changeFavInMyproduct(
                                                  ProductId: widget.product.id);
                                              _auth_readWrite.changeFavorite(
                                                  uid, widget.product.id);
                                            },
                                            child: isFav
                                                ? Icon(Icons.favorite,
                                                    color: myPrimaryColor)
                                                : Icon(
                                                    Icons
                                                        .favorite_border_outlined,
                                                    color: Color.fromARGB(
                                                        156, 120, 117, 117))),
                                      )),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 7, right: 7, bottom: 7),
                          child: Text(widget.product.title,
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
                                child: Text(
                                    widget.product.price.toString() + " L.E",
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
                                _auth_readWrite.addToCart(
                                    widget.product.id.toString(), "1", context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ]))));
  }
}
