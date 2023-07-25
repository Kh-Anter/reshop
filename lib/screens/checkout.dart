import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/consts/enums.dart';
import 'package:reshop/models/validations.dart';
import 'package:reshop/providers/authentication/auth_readwrite.dart';
import 'package:reshop/providers/orders_provider.dart';
import 'package:reshop/screens/home.dart';
import 'package:reshop/consts/size_config.dart';
import 'package:provider/provider.dart';
import 'package:reshop/widgets/mytextfield.dart';

class CheckOut extends StatefulWidget {
  static const routeName = "checkout";

  const CheckOut({Key? key}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final titleCtl = TextEditingController();
  final nameCtl = TextEditingController();
  final addressCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  var globalKey = GlobalKey<FormState>();
  bool loading = false;
  String titleError = "";
  String nameError = "";
  String addressError = "";
  String phoneError = "";
  Payment payMethodVal = Payment.onReceived;
  int addressVal = 0;
  final SizeConfig _size = SizeConfig();
  late dynamic authReadWrite;

  @override
  void initState() {
    callSizeConfig();
    super.initState();
    authReadWrite = Provider.of<AuthReadWrite>(context, listen: false);
  }

  void callSizeConfig() async {
    await Future.delayed(Duration(seconds: 1), () => _size.init(context));
  }

  late final Future readAddress = authReadWrite.readAddress();
  @override
  Widget build(BuildContext context) {
    ElevatedButton(
      child: Text("go to home"),
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Home(),
      )),
    );
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: (() => Navigator.pop(context))),
            title: Text("Check out",
                style: TextStyle(color: Colors.black, fontSize: 22))),
        body: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              child: FutureBuilder(
                  future: readAddress,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                          height: SizeConfig.screenHeight - 100,
                          child: Center(child: CircularProgressIndicator()));
                    } else {
                      return theBody();
                    }
                  }),
            )));
  }

  Widget theBody() {
    TextStyle ts = TextStyle(fontSize: 16, color: mySecondTextColor);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 20),
      Text("Choose your address", style: ts),
      StatefulBuilder(
        builder: (context, setState) => Column(
            children: List.generate(
                authReadWrite.userAddress.length,
                ((index) => buildAddress(
                    authReadWrite.userAddress[index]["title"],
                    authReadWrite.userAddress[index]["address"],
                    authReadWrite.userAddress[index]["name"],
                    authReadWrite.userAddress[index]["phoneNum"],
                    index,
                    setState)))),
      ),
      addAddressBtn(),
      Text("Payment method", style: ts),
      paymentMethod(),
      confirmBtn(),
      SizedBox(height: 50)
    ]);
  }

  Widget addAddressBtn() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextButton(
          onPressed: () => showModalBottomSheet(
              context: context,
              // useRootNavigator: fa,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              builder: (context) => StatefulBuilder(
                  builder: (context, setModalState) =>
                      myBottomSheet(setModalState))),
          child: Text("Add new address",
              style: TextStyle(fontSize: 16, color: myPrimaryColor)))
    ]);
  }

  Widget confirmBtn() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: _size.getWidth,
      height: 50,
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))),
          onPressed: () => showDialog(
              context: context,
              builder: (context) => authReadWrite.userAddress.length == 0
                  ? AlertDialog(title: Text("add your address!"), actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("ok"))
                    ])
                  : AlertDialog(
                      elevation: 100.2,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      content: SizedBox(
                        height: 30,
                        // width: 300,
                        child: Text("Are you sure to confirm ?"),
                      ),
                      actions: [
                          StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              final orderProvider =
                                  Provider.of<OrderProvider>(context);
                              return orderProvider.addOrderProgress
                                  ? SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      onPressed: () => orderProvider
                                          .addNewOrder(
                                              authReadWrite
                                                  .userAddress[addressVal],
                                              context)
                                          .then((_) => AlertDialog(
                                                title: Text(
                                                    "Done, order in processing "),
                                                actions: [
                                                  SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child: ElevatedButton(
                                                          child: Text(
                                                              "Containue shopping"),
                                                          onPressed: () => Navigator
                                                                  .of(context)
                                                              .pushNamedAndRemoveUntil(
                                                                  Home
                                                                      .routeName,
                                                                  (route) =>
                                                                      false))),
                                                  TextButton(
                                                      onPressed: () {},
                                                      // Navigator.of(context)
                                                      //     .pushAndRemoveUntil(Home.routeName, (route) => false),
                                                      child: Text("See Orders"))
                                                ],
                                              )),
                                      child: Text("Confirm"));
                            },
                          ),
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Cancel"))
                        ])),
          child: Text(
            "Confirm",
            style: TextStyle(fontSize: 16),
          )),
    );
  }

  Widget buildAddress(String title, String address, String userName,
      String phone, int value, setState) {
    return Container(
        height: 90,
        padding: EdgeInsets.only(top: 9, bottom: 9, left: 30, right: 15),
        margin: EdgeInsets.only(top: 10, bottom: 5),
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
                  width: _size.getWidth - 150,
                  child: Text(address,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: mySecondTextColor)),
                )
              ]),
              Row(children: [
                Icon(Icons.person_outline_outlined, size: 22),
                SizedBox(width: 5),
                SizedBox(
                  width: _size.getWidth - 150,
                  child: Text("$userName - $phone",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: mySecondTextColor)),
                )
              ])
            ],
          ),
          Spacer(),
          Radio(
              value: value,
              groupValue: addressVal,
              onChanged: (int? newVal) {
                setState(() {
                  addressVal = newVal!;
                });
              })
        ]));
  }

  Widget paymentMethod() {
    return StatefulBuilder(
      builder: (context, setState) => Column(children: [
        paymentMethodRow(true, "assets/images/checkout/visa.jpeg", "Visa",
            Payment.visa, setState),
        paymentMethodRow(true, "assets/images/checkout/master.png",
            "Master card", Payment.master, setState),
        paymentMethodRow(true, "assets/images/checkout/PayPal.png", "PayPal",
            Payment.paypal, setState),
        paymentMethodRow(false, "", "On Received", Payment.onReceived, setState)
      ]),
    );
  }

  Widget paymentMethodRow(bool hasImage, imgurl, text, value, setState) {
    return Container(
      height: 50,
      padding: EdgeInsets.all(9),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: myTextFieldBorderColor),
          borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        if (hasImage) SizedBox(width: 15),
        if (hasImage) Image.asset(imgurl, width: 50, height: 50),
        SizedBox(width: 15),
        Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
        Spacer(),
        Radio<Payment>(
            value: value,
            groupValue: payMethodVal,
            onChanged: (newVal) {
              setState(() {
                payMethodVal = newVal!;
              });
            })
      ]),
    );
  }

  Widget myBottomSheet(setModalState) {
    validateForm();
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
      height: _size.getHeight * 0.6,
      child: Column(children: [
        Stack(alignment: Alignment.topCenter, children: [
          Container(
              alignment: Alignment.topCenter,
              child: Text("Add new address",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300))),
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.close_rounded,
                  size: 25,
                  color: Colors.black,
                )),
          )
        ]),
        Container(
          padding: EdgeInsets.only(top: 20),
          height: (_size.getHeight * 0.6) - 100,
          child: SingleChildScrollView(
            child: Form(
              key: globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextField(
                      labelText: "Title",
                      maxLength: 10,
                      controller: titleCtl,
                      parentState: setModalState,
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          setModalState(() => titleError = "enter a title");
                        }
                      }),
                  if (titleError.isNotEmpty) error(titleError),
                  MyTextField(
                      labelText: "Name",
                      maxLength: 20,
                      controller: nameCtl,
                      parentState: setModalState,
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          setModalState(() => nameError = "enter a name");
                        }
                      }),
                  if (nameError.isNotEmpty) error(nameError),
                  MyTextField(
                      labelText: "Address",
                      controller: addressCtl,
                      parentState: setModalState,
                      validator: (value) {
                        if (value.toString().trim().length < 10) {
                          setModalState(() => addressError =
                              "address must be at least 10 char.");
                        }
                      }),
                  if (addressError.isNotEmpty) error(addressError),
                  MyTextField(
                      labelText: "Phone number",
                      type: TextInputType.phone,
                      controller: phoneCtl,
                      parentState: setModalState,
                      validator: (value) {
                        if (!Validations.validatePhone(phone: value)) {
                          setModalState(
                              () => phoneError = "Invalid phone number");
                        }
                      },
                      maxLength: 11,
                      prefex: Text("+2 ", style: TextStyle(fontSize: 14))),
                  if (phoneError.isNotEmpty) error(phoneError),
                  SizedBox(
                    height: 20,
                  ),
                  Row(children: [
                    SizedBox(
                        width: (_size.getWidth - 40) / 2,
                        height: _size.getProportionateScreenHeight(60),
                        child: TextButton(
                            onPressed: () {
                              zeroError();
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel",
                                style: TextStyle(fontSize: 17)))),
                    SizedBox(
                      width: (_size.getWidth - 40) / 2,
                      height: _size.getProportionateScreenHeight(50),
                      child: loading
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(myPrimaryColor),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                              onPressed: () {
                                // setState(() => loading = true);
                                loading = true;
                                setModalState(() {
                                  if (validateForm()) {
                                    authReadWrite.addAddress(
                                        title: titleCtl.text,
                                        address: addressCtl.text,
                                        name: nameCtl.text,
                                        phoneNum: phoneCtl.text);
                                    Navigator.of(context).pop();
                                    zeroError();
                                    setState(() {});
                                  }
                                  loading = false;
                                });
                              },
                              child: Text(
                                "Add",
                                style: TextStyle(fontSize: 17),
                              )),
                    )
                  ]),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  bool validateForm() {
    titleError = "";
    nameError = "";
    addressError = "";
    phoneError = "";
    globalKey.currentState?.validate();
    if (titleError == "" &&
        nameError == "" &&
        addressError == "" &&
        phoneError == "") {
      return true;
    } else {
      return false;
    }
  }

  void zeroError() {
    titleError = "";
    nameError = "";
    addressError = "";
    phoneError = "";
    titleCtl.text = "";
    nameCtl.text = "";
    addressCtl.text = "";
    phoneCtl.text = "";
  }

  Widget error(txt) {
    return Padding(
        padding: EdgeInsets.only(left: 15),
        child: Text(
          txt,
          style: TextStyle(color: myPrimaryColor),
        ));
  }
}
