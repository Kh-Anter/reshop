import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/providers/auth_readwrite.dart';
import '../providers/dummyData.dart';
import '../widgets/build_dot.dart';

import '../size_config.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = "/productDetails";
  var product;
  ProductDetails({this.product, Key key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  SizeConfig _size = SizeConfig();
  PageController _pageController = PageController(initialPage: 0);
  TextEditingController countController = TextEditingController(text: "1");
  var _auth_readWrite;
  var uid = FirebaseAuth.instance.currentUser.uid;
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    _size.init(context);
    var _dummyData = Provider.of<DummyData>(context);
    _auth_readWrite = Provider.of<Auth_ReadWrite>(context);
    isFav = widget.product.isFav;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
      ),
      bottomNavigationBar: bottomWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              height: _size.getProportionateScreenHeight(250),
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  return Image.network(widget.product.images[index]);
                },
                itemCount: widget.product.images.length,
                onPageChanged: (value) {
                  _dummyData.changePageview(value);
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            BuildDot(length: widget.product.images.length),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.product.title,
              maxLines: 1,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              widget.product.brand,
              style:
                  TextStyle(fontSize: 16, color: Color.fromRGBO(1, 1, 1, 0.5)),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 7),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: myPrimaryLightColor,
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        child: Text(widget.product.price.toString() + " L.E",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                //fontFamily: 'Varela',
                                fontSize: 20))),
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      if (!countController.text.isEmpty) {
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
                    textAlign: TextAlign.center,
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (!countController.text.isEmpty) {
                        int value = int.parse(countController.value.text);
                        if (value != null && value > 1) {
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
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: const [
                Icon(Icons.star, color: myPrimaryColor),
                Text(
                  "  4.5",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 200,
              // width: 100,
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: <Widget>[
                    Container(
                      //  constraints: BoxConstraints.expand(height: 50),
                      child: TabBar(
                          labelColor: myPrimaryColor,
                          unselectedLabelColor: Colors.black45,
                          indicatorPadding: EdgeInsets.all(10),
                          labelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          unselectedLabelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          tabs: [
                            Tab(text: "Description"),
                            Tab(text: "Reviews"),
                            Tab(text: "Specfications"),
                          ]),
                    ),
                    Expanded(
                      child: Container(
                        child: TabBarView(children: [
                          Container(
                            child: Text(
                              widget.product.description,
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Reviews",
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Specfications",
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  bottomWidget() {
    var _dummyData = Provider.of<DummyData>(context);
    var _auth_readwrite = Provider.of<Auth_ReadWrite>(context, listen: false);

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
                    _auth_readWrite.changeFavorite(uid, widget.product.id);
                    setState(() {
                      isFav = !isFav;
                    });
                    _dummyData.changeFavInMyproduct(
                        ProductId: widget.product.id);
                    _auth_readWrite.changeFavorite(uid, widget.product.id);
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
            width: _size.getWidth - 100,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                _auth_readWrite.addToCart(
                    widget.product.id, countController.text, context);
              },
              child: Text(
                "Add to Cart",
                style: TextStyle(fontSize: 18),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.red))),
              ),
            ))
      ],
    );
  }
}
