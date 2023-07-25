import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:reshop/consts/constants.dart';
// import 'package:reshop/providers/dummyData.dart';
import 'package:reshop/consts/size_config.dart';

class EmptyOrders extends StatelessWidget {
//  EmptyOrders({Key? key}) : super(key: key);
  final SizeConfig size = SizeConfig();

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<DummyData>(context, listen: false);
    size.init(context);
    return Container(
      //   alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              height: (size.getHeight) / 2.8,
              width: size.getWidth,
              margin: EdgeInsets.only(bottom: 20),
              child: Image.asset("assets/images/emptycart.png")),
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
            width: size.getWidth / 3,
            height: 45,
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                onPressed: () {
                  // provider.changeBottonNavigationBar(newValue: 2);
                  // Navigator.of(context).pop();
                },
                child: Text(
                  "Go to offers",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
          ),
        ]),
      ),
    );
  }
}
