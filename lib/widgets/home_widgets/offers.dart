import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/models/product.dart';
import 'package:reshop/providers/auth_readwrite.dart';
import 'package:reshop/providers/dummyData.dart';
import 'package:reshop/size_config.dart';
import 'package:reshop/widgets/product_card.dart';

class Offers extends StatelessWidget {
  const Offers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig _size = SizeConfig();
    _size.init(context);
    final _dummyData = Provider.of<DummyData>(context, listen: false);
    List<Product> offers = _dummyData.offers;
    print("------------- offers : $offers");

    return Center(
        child: SingleChildScrollView(
            child: offers.isEmpty
                ? Text("")
                : Container(
                    //  width: _size.getWidth,
                    height: _size.getHeight - 220,
                    child: buildOffers(offers, context))));
  }

  Widget buildOffers(Offers, context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: Offers.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.8,
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8),
        itemBuilder: (BuildContext context, int index) {
          return ProductCart(
            product: Offers[index],
          );
        });
  }
}
