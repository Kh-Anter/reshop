import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/providers/address_provider.dart';
import 'package:provider/provider.dart';

import 'package:reshop/screens/editOrAdd_address.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);
  static const routeName = "/Address";
  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  var addressProvider;

  @override
  Widget build(BuildContext context) {
    addressProvider = Provider.of<AddressProvider>(context);
    print("-------address screen build-------");
    return Scaffold(
        appBar: myAppbar(context),
        body: FutureBuilder(
          future: addressProvider.readAddress(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (addressProvider.userAddress.length == 0) {
                return noAddressFound();
              } else {
                print(addressProvider.userAddress.length);
                return theBody(context);
              }
            } else {
              return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            }
          },
        ));
  }

  AppBar myAppbar(BuildContext context) {
    return AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (() => Navigator.pop(context))),
        title: Text("Address",
            style: TextStyle(color: Colors.black, fontSize: 22)));
  }

  Widget noAddressFound() {
    return Padding(
      padding: EdgeInsets.all(10),
      // alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.not_listed_location_outlined,
            size: 250,
            color: mySecondTextColor,
          ),
          Text("No address yet", style: TextStyle(fontSize: 22)),
          SizedBox(height: 5),
          Text("Please add your address",
              style: TextStyle(fontSize: 14, color: mySecondTextColor)),
          SizedBox(height: 15),
          addAdressBtn(context)
        ],
      ),
    );
  }

  Widget theBody(BuildContext context) {
    print(
        "------->>>>>> address length : ${addressProvider.userAddress.length}");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: addressProvider.userAddress.length,
                itemBuilder: (ctx, index) => Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: Slidable(
                          startActionPane: deleteAddress(index),
                          endActionPane: editAddress(context, index),
                          child: buildAddress(
                              addressProvider.userAddress[index].title,
                              addressProvider.userAddress[index].address,
                              addressProvider.userAddress[index].name,
                              addressProvider.userAddress[index].phoneNum,
                              index)),
                    )),
          ),
          addAdressBtn(context),
        ],
      ),
    );
  }

  ActionPane editAddress(BuildContext context, int index) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) {
            Navigator.of(context).pushNamed(EditOrAddAddress.routeName,
                arguments: addressProvider.userAddress[index]);
          },
          backgroundColor: Color(0xFF7BC043),
          foregroundColor: Colors.white,
          icon: Icons.edit_location_alt_outlined,
          label: 'Edit',
        ),
      ],
    );
  }

  ActionPane deleteAddress(int index) {
    return ActionPane(
      motion: ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) async {
            await addressProvider.deleteAddress(
              address: addressProvider.userAddress[index].address,
              context: ctx,
            );
          },
          backgroundColor: Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    );
  }

  Container addAdressBtn(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))),
          onPressed: () =>
              Navigator.of(ctx).pushNamed(EditOrAddAddress.routeName),
          child: Text(
            "Add new address",
            style: TextStyle(fontSize: 16),
          )),
    );
  }

  Widget buildAddress(
      String title, String address, String userName, String phone, int value) {
    return Container(
        height: 90,
        padding: EdgeInsets.only(top: 9, bottom: 9, left: 30, right: 15),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: myTextFieldBorderColor),
            borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text(title, style: TextStyle(fontSize: 18))),
              Spacer(),
              Row(children: [
                Icon(Icons.location_on_outlined, size: 22),
                SizedBox(width: 5),
                SizedBox(
                  child: Text(address,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: mySecondTextColor)),
                )
              ]),
              Row(children: [
                Icon(Icons.person_outline_outlined, size: 22),
                SizedBox(width: 5),
                SizedBox(
                  child: Text("$userName - $phone",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: mySecondTextColor)),
                )
              ])
            ],
          ),
        ]));
  }
}
