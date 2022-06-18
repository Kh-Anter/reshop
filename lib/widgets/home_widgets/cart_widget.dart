import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/models/product.dart';
import 'package:reshop/size_config.dart';

import '../../providers/dummyData.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key key}) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  SizeConfig _size = SizeConfig();
  int total = 0;
  bool isEmpty;

  @override
  Widget build(BuildContext context) {
    var cartProducts = null;
    _size.init(context);
    var _provider = Provider.of<DummyData>(context);
    cartProducts = _provider.cartProducts;
    total = 0;
    for (int i = 0; i < cartProducts.length; i++) {
      total += (int.parse(cartProducts[i]["count"])) *
          (cartProducts[i]["product"].price);
    }
    if (cartProducts.length == 0) {
      isEmpty = true;
    } else {
      isEmpty = false;
    }
    return Padding(
      padding: EdgeInsets.all(10),
      child: Center(
        child: SingleChildScrollView(
            child: isEmpty
                ? Column(children: [
                    Container(
                        height: _size.getHeight / 2.8,
                        width: _size.getWidth,
                        margin: EdgeInsets.only(bottom: 20),
                        child: Image.asset("assets/images/emptycart.png")),
                    Text(
                      "Your cart is empty !",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Add the products you want to add",
                      style: TextStyle(fontSize: 12, color: mySecondTextColor),
                    ),
                    Container(
                      margin: EdgeInsets.all(30),
                      width: _size.getWidth / 3,
                      height: 45,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          onPressed: () =>
                              _provider.changeBottonNavigationBar(newValue: 2),
                          child: Text(
                            "Go to offers",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )),
                    ),
                  ])
                : buildCart(cartProducts: cartProducts, provider: _provider)),
      ),
    );
  }

  Widget buildCart({cartProducts, provider}) {
    TextStyle txtStyle =
        TextStyle(color: Color.fromRGBO(1, 1, 1, 0.5), fontSize: 15);
    return Column(
      children: [
        for (var i = 0; i < cartProducts.length; i++)
          (buildCartProduct(
              cartProducts[i]["product"], cartProducts[i]["count"], provider)),
        Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Items :",
                style: txtStyle,
              ),
              Text(
                total.toString() + " L.E",
                style: txtStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Shipping :", style: txtStyle),
              Text("Free", style: txtStyle)
            ],
          ),
        ),
        Divider(
          color: mySecondTextColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: TextStyle(fontSize: 15),
            ),
            Text(
              total.toString() + " L.E",
              style: TextStyle(
                  color: myPrimaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          width: _size.getWidth,
          height: 45,
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)))),
            child: Text(
              "Check Out",
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  Widget buildCartProduct(Product myproduct, count, provider) {
    TextEditingController countController = TextEditingController(text: count);
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: mySecondTextColor)),
      width: _size.getWidth,
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(right: 10),
              width: _size.getWidth / 4,
              child: Image.asset(myproduct.images[0])),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                child: Text(
                  myproduct.title,
                  maxLines: 1,
                  style: TextStyle(),
                ),
              ),
              Spacer(),
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    myproduct.brand,
                    style: TextStyle(color: Color.fromRGBO(1, 1, 1, 0.5)),
                  )),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: myPrimaryLightColor,
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    child: Text(myproduct.price.toString() + " L.E",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            //fontFamily: 'Varela',
                            fontSize: 14.0))),
              ),
            ]),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    if (!countController.text.isEmpty) {
                      int value = int.parse(countController.value.text);
                      if (value < 999) {
                        value++;
                        countController.text = value.toString();
                        provider.addToCart(
                            productId: myproduct.id,
                            count: countController.text);
                      }
                    }
                  },
                  child: Icon(
                    Icons.keyboard_arrow_up_sharp,
                    color: myPrimaryColor,
                    size: 28,
                  )),
              Container(
                padding: EdgeInsets.all(0),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: mySecondTextColor),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: 30,
                height: 30,
                child: TextField(
                  controller: countController,
                  textAlign: TextAlign.center,
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  //onChanged: ,
                  onSubmitted: (value) {
                    provider.editOnCart(productId: myproduct.id, count: value);
                  },
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: countController.text,
                    counterText: "",
                    border: InputBorder.none,
                  ),
                ),
              ),
              InkWell(
                  onTap: () {
                    if (!countController.text.isEmpty) {
                      int value = int.parse(countController.value.text);
                      if (value != null && value > 1) {
                        value--;
                        countController.text = value.toString();
                        provider.addToCart(
                            productId: myproduct.id,
                            count: countController.text);
                      }
                    }
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: myPrimaryColor,
                    size: 28,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
