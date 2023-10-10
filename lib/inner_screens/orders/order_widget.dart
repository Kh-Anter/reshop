import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/providers/orders_provider.dart';
import 'package:reshop/consts/size_config.dart';
import 'package:reshop/inner_screens/orders/empty_orders.dart';

class OrderWidget extends StatefulWidget {
  final bool isDeliverd;
  const OrderWidget(this.isDeliverd, {Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  SizeConfig size = SizeConfig();
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<OrderProvider>(context);
    size.init(context);
    return FutureBuilder(
        future: controller.getOrders(isDeliverd: widget.isDeliverd),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            List? data = snapshot.data as List;
            if (data.isNotEmpty) {
              return buildBody(snapshot.data, size, controller);
            } else {
              return EmptyOrders();
            }
          } else
            return SizedBox();
        });
  }

  buildBody(result, size, controller) {
    return ListView.builder(
      itemBuilder: (ctx, i) {
        return Container(
          // height: _size.getHeight - 300,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
          child: Column(children: [
            SizedBox(
                child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (rCtx, rI) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        child: Row(
                          children: [
                            const Icon(Icons.circle,
                                color: myPrimaryColor, size: 10),
                            const SizedBox(width: 10),
                            Flexible(
                              child: SizedBox(
                                child: Text(
                                  result[i]["items"][rI]["itemName"],
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 15,
                                      color: mySecondTextColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text("X${result[i]["items"][rI]["count"]}",
                        style: const TextStyle(fontSize: 15))
                  ],
                );
              },
              itemCount: result[i]["items"].length,
            )),
            Divider(thickness: 1),
            Container(
              padding: EdgeInsets.only(left: 22, right: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: mySecondTextColor)),
                      Text(result[i]["date"].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: mySecondTextColor)),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: mySecondTextColor)),
                      Text("${result[i]["total"]} LE ",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: myPrimaryColor)),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        );
      },
      itemCount: result.length,
    );
  }

  // Widget myAlertDialog(onpress_continue) {
  //   String txt = "";
  //   // if (controller.role == 0)
  //   txt = "Are you sure , you want to cancel order ?";
  //   return AlertDialog(
  //     content: Text(txt),
  //     actions: [
  //       TextButton(
  //           child: Text("Cancel"),
  //           onPressed: () => Navigator.of(context).pop()),
  //       TextButton(
  //         child: Text("Continue"),
  //         onPressed: onpress_continue,
  //       )
  //     ],
  //   );
  // }
}
