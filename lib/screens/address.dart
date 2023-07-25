import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/providers/authentication/auth_readwrite.dart';
import 'package:reshop/consts/size_config.dart';
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
  var authReadWrite;
  var size = SizeConfig();

  @override
  void initState() {
    callSizeConfig();
    super.initState();
  }

  void callSizeConfig() async {
    authReadWrite = Provider.of<AuthReadWrite>(context, listen: false);
    await Future.delayed(Duration(seconds: 1), () => size.init(context));
  }

  @override
  Widget build(BuildContext context) {
    print("-------address screen build-------");

    // size.init(context);
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: (() => Navigator.pop(context))),
            title: Text("Address",
                style: TextStyle(color: Colors.black, fontSize: 22))),
        body: SingleChildScrollView(
            child: Container(
          height: size.getHeight,
          width: size.getWidth,
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          //   child: SingleChildScrollView(
          child: FutureBuilder(
            future: authReadWrite.readAddress(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (authReadWrite.userAddress == []) {
                  return noAddressFound();
                } else {
                  print(authReadWrite.userAddress.length);
                  return theBody(context);
                }
              } else {
                return Container(
                    height: size.getHeight,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator());
              }
            },
          ),
        ) //),
            ));
  }

  noAddressFound() {
    return Container(
      height: size.getHeight - 100,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.not_listed_location_outlined,
            size: 250,
            color: mySecondTextColor,
          ),
          Text("No address yet", style: TextStyle(fontSize: 20)),
          Text("Please add your address",
              style: TextStyle(fontSize: 12, color: mySecondTextColor)),
        ],
      ),
    );
  }

  Widget theBody(BuildContext ctx) {
    return Column(
      children: [
        SizedBox(
          height: size.getHeight - 150,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: authReadWrite.userAddress.length,
              itemBuilder: (ctx, index) => Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: Slidable(
                        startActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) => print("delete"),
                              backgroundColor: Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) => print("dds"),
                              backgroundColor: Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.edit_location_alt_outlined,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        child: buildAddress(
                            authReadWrite.userAddress[index]["title"],
                            authReadWrite.userAddress[index]["address"],
                            authReadWrite.userAddress[index]["name"],
                            authReadWrite.userAddress[index]["phoneNum"],
                            index)),
                  )),
        ),
        //  Spacer(),
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size.getWidth,
          height: 50,
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
        ),
      ],
    );
  }

  Widget buildAddress(
      String title, String address, String userName, String phone, int value) {
    return Container(
        height: 90,
        padding: EdgeInsets.only(top: 9, bottom: 9, left: 30, right: 15),
        // margin: EdgeInsets.only(top: 5, bottom: 5),
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
                  width: size.getWidth - 150,
                  child: Text(address,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: mySecondTextColor)),
                )
              ]),
              Row(children: [
                Icon(Icons.person_outline_outlined, size: 22),
                SizedBox(width: 5),
                SizedBox(
                  width: size.getWidth - 150,
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
