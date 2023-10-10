import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/providers/dummyData.dart';

class EmptyOrders extends StatelessWidget {
  const EmptyOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DummyData>(context, listen: false);
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset("assets/images/emptycart.png"),
      ),
      Text(
        "No Orders yet",
        style: TextStyle(fontSize: 20),
      ),
      Text(
        "Add products and  fill required info ",
        style: TextStyle(fontSize: 12, color: mySecondTextColor),
      ),
      Text(
        "Delivery fees is free for your first order",
        style: TextStyle(fontSize: 12, color: mySecondTextColor),
      ),
      Container(
        margin: EdgeInsets.all(30),
        height: 45,
        child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
            onPressed: () {
              provider.changeBottonNavigationBar(newValue: 2);
              Navigator.of(context).pop();
            },
            child: Text(
              "Go to offers",
              style: TextStyle(
                fontSize: 16,
              ),
            )),
      ),
    ]);
  }
}
