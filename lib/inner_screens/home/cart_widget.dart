import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/models/product.dart';
// import 'package:reshop/providers/auth_readwrite.dart';
import 'package:reshop/providers/chart/cart_provider.dart';
import 'package:reshop/providers/chart/total.dart';
import 'package:reshop/screens/checkout.dart';
import 'package:reshop/consts/size_config.dart';

import '../../providers/dummyData.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key}) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  SizeConfig size = SizeConfig();
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DummyData>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    // final authPeadWrite = Provider.of<AuthReadWrite>(context, listen: false);
    size.init(context);
    return FutureBuilder(
        future: cartProvider.readCart(context),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                height: size.getHeight - 140,
                alignment: Alignment.center,
                child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data.length != 0) {
            return buildCart(
                provider: cartProvider, ctx: context, refresh: refresh);
          } else {
            return emptyCard(provider);
          }
        });
  }

  Widget buildCart({provider, ctx, refresh}) {
    var totalProvider = Provider.of<TotalCartProvider>(context, listen: false);
    totalProvider.calculateTotal(provider.myCart);

    TextStyle txtStyle =
        TextStyle(color: Color.fromRGBO(1, 1, 1, 0.5), fontSize: 15);
    return StatefulBuilder(
      builder: ((context, setState) {
        var cartProducts = provider.myCart;
        return SizedBox(
          height: size.getHeight - 140,
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var i = 0; i < cartProducts.length; i++)
                  Dismissible(
                    secondaryBackground: Container(
                        color: myPrimaryLightColor,
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 50),
                          child: Icon(
                            Icons.delete,
                            size: 35,
                          ),
                        )),
                    background: Container(
                        color: myPrimaryLightColor,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: Icon(
                            Icons.delete,
                            size: 35,
                          ),
                        )),
                    key: Key(cartProducts[i]["product"].id),
                    child: buildCartProduct(cartProducts[i]["product"],
                        cartProducts[i]["count"], provider, ctx),
                    onDismissed: (_) async {
                      if (cartProducts.length == 1) {
                        provider.removeFromCart(
                            cartProducts[i]["product"].id, ctx);
                        refresh();
                      } else {
                        setState(() {
                          provider.removeFromCart(
                              cartProducts[i]["product"].id, ctx);
                        });
                      }
                    },
                  ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Items :",
                        style: txtStyle,
                      ),
                      Consumer<TotalCartProvider>(builder: (context, value, _) {
                        return Text("${value.total} L.E", style: txtStyle);
                      })
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
                    Text("Total", style: TextStyle(fontSize: 15)),
                    Consumer<TotalCartProvider>(builder: (context, value, _) {
                      return Text("${value.total} L.E", style: txtStyle);
                    })
                  ],
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: size.getWidth,
                  height: 45,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)))),
                    child: Text(
                      "Check Out",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, CheckOut.routeName);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildCartProduct(Product myproduct, count, provider, ctx) {
    // total += int.parse(myproduct.price.toString()) * int.parse(count);
    TextEditingController countController =
        TextEditingController(text: count.toString());
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: mySecondTextColor)),
      width: size.getWidth,
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(right: 10),
              width: size.getWidth / 4,
              child: Image.network(myproduct.images[0])),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                child: Text(
                  myproduct.title ?? "",
                  maxLines: 1,
                  style: TextStyle(),
                ),
              ),
              Spacer(),
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    myproduct.brand ?? "",
                    style: TextStyle(color: Color.fromRGBO(1, 1, 1, 0.5)),
                  )),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: myPrimaryLightColor,
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    child: Text("${myproduct.price} L.E",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            //fontFamily: 'Varela',
                            fontSize: 14.0))),
              ),
            ]),
          ),
          StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      if (countController.text.isNotEmpty) {
                        int value = int.parse(countController.value.text);
                        if (value < 999) {
                          setState(() {
                            value++;
                            countController.text = value.toString();
                          });
                          provider.editItemCount(
                              myproduct.id,
                              countController.text.toString(),
                              myproduct.price,
                              'a',
                              ctx);
                        }
                      }
                    },
                    child: Icon(Icons.keyboard_arrow_up_sharp,
                        color: myPrimaryColor, size: 28)),
                Container(
                    padding: EdgeInsets.all(0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: mySecondTextColor),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    width: 30,
                    height: 30,
                    child: Text(countController.text.toString())),
                InkWell(
                    onTap: () {
                      if (countController.text.isNotEmpty) {
                        int value = int.parse(countController.value.text);
                        if (value > 1) {
                          setState(() {
                            value--;
                            countController.text = value.toString();
                          });
                          provider.editItemCount(
                              myproduct.id,
                              countController.text.toString(),
                              myproduct.price,
                              's',
                              ctx);
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
          ),
        ],
      ),
    );
  }

  Widget emptyCard(provider) {
    print(size.getHeight);
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            height: size.getHeight / 2.8,
            width: size.getWidth,
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
          width: size.getWidth / 3,
          height: 45,
          child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))),
              onPressed: () {
                provider.changeBottonNavigationBar(newValue: 2);
              },
              child: Text(
                "Go to offers",
                style: TextStyle(
                  fontSize: 16,
                ),
              )),
        ),
      ]),
    );
  }
}
