import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/models/product.dart';
import 'package:reshop/providers/dummyData.dart';
import 'package:reshop/consts/size_config.dart';
import 'package:reshop/widgets/product_card.dart';

class Offers extends StatelessWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig size = SizeConfig();
    size.init(context);
    final dummyData = Provider.of<DummyData>(context, listen: false);
    List<Product> offers = dummyData.offers;

    return Center(
        child: offers.isEmpty
            ? Text("")
            : SizedBox(
                height: size.getHeight - 100,
                child: buildOffers(offers, context)));
  }

  Widget buildOffers(offers, context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: offers.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.8,
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8),
        itemBuilder: (BuildContext context, int index) {
          return ProductCart(
            product: offers[index],
          );
        });
  }
}
