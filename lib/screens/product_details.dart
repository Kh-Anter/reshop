import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/constants.dart';
import '../providers/dummyData.dart';
import '../widgets/build_dot.dart';

import '../size_config.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = "/productDetails";
  var productId;
  ProductDetails({this.productId, Key key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  SizeConfig _size = SizeConfig();
  PageController _pageController = PageController(initialPage: 0);
  TextEditingController countController = TextEditingController(text: "1");
  var currentProduct;
  var imagesLength;

  @override
  Widget build(BuildContext context) {
    _size.init(context);
    var _dummyData = Provider.of<DummyData>(context);
    _dummyData.myProducts.forEach((element) {
      if (element.id == widget.productId) {
        currentProduct = element;
        imagesLength = element.images.length;
        return;
      }
      ;
    });

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
                  return Image.asset(currentProduct.images[index]);
                },
                itemCount: imagesLength,
                onPageChanged: (value) {
                  _dummyData.changePageview(value);
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            BuildDot(length: imagesLength),
            SizedBox(
              height: 15,
            ),
            Text(
              currentProduct.title,
              maxLines: 1,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              currentProduct.brand,
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
                        child: Text(currentProduct.price.toString() + " L.E",
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
                              currentProduct.description,
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
    return Row(
      children: [
        Container(
            margin: EdgeInsets.all(10),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: myPrimaryColor, width: 1),
                borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              onPressed: (() {
                //  _dummyData.changeFav(currentProduct.id);
              }),
              icon:
                  //  currentProduct.isFav
                  //     ? Icon(
                  //         Icons.favorite,
                  //         color: myPrimaryColor,
                  //         size: 30,
                  //       )
                  //     :
                  Icon(
                Icons.favorite_border,
                color: myPrimaryColor,
                size: 30,
              ),
            )),
        Container(
            decoration: BoxDecoration(
                //  border: Border.all(color: myPrimaryColor, width: 1),
                borderRadius: BorderRadius.circular(12)),
            width: _size.getWidth - 100,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                _dummyData.addToCart(
                    productId: currentProduct.id,
                    count: countController.value.text);
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
