import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/providers/orders_provider.dart';
import 'package:reshop/consts/size_config.dart';
import 'package:provider/provider.dart';
// import 'package:reshop/widgets/orders_widgets/empty_orders.dart';
import 'package:reshop/inner_screens/orders/order_widget.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);
  static const routeName = "/Orders";
  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  SizeConfig size = SizeConfig();
  late var ordersProvider;
  bool isDeliverd = false;
  @override
  Widget build(BuildContext context) {
    ordersProvider = Provider.of<OrderProvider>(context);
    size.init(context);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (() => Navigator.pop(context))),
          title: Text("Orders",
              style: TextStyle(color: Colors.black, fontSize: 22))),
      body: Container(
        height: size.getHeight,
        width: size.getWidth,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              height: 40,
              child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: TabBar(
                    onTap: ((value) {
                      setState(() {
                        if (value == 0) {
                          isDeliverd = false;
                        } else {
                          isDeliverd = true;
                        }
                      });
                    }),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    unselectedLabelColor: mySecondTextColor,
                    labelColor: Colors.black,
                    tabs: const [
                      Text(
                        "Upcoming orders",
                      ),
                      Text(
                        "Past orders",
                      )
                    ]),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: size.getHeight - 150,
                  child: OrderWidget(isDeliverd),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
