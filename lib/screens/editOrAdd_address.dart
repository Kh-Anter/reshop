import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/providers/authentication/auth_readwrite.dart';
import 'package:reshop/consts/size_config.dart';
import 'package:provider/provider.dart';
import 'package:reshop/widgets/mytextfield.dart';
import '../models/validations.dart';

// ignore: must_be_immutable
class EditOrAddAddress extends StatelessWidget {
  final titleCtl = TextEditingController();
  final nameCtl = TextEditingController();
  final addressCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  final globalKey = GlobalKey<FormState>();

  EditOrAddAddress({Key? key}) : super(key: key);
  static const routeName = "/AddNewAddress";
  final size = SizeConfig();
  bool loading = false;
  var titleError = "";
  var nameError = "";
  var addressError = "";
  var phoneError = "";

  @override
  Widget build(BuildContext context) {
    String appBartitle = "Add new address";
    var authReadWrite = Provider.of<AuthReadWrite>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: (() => Navigator.pop(context))),
            title: Text(appBartitle,
                style: TextStyle(color: Colors.black, fontSize: 22))),
        body: Container(
            height: size.getHeight,
            width: size.getWidth,
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: body(authReadWrite)));
  }

  body(authReadWrite) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: (size.getHeight * 0.6) - 100,
      child: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Form(
              key: globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextField(
                      labelText: "Title",
                      maxLength: 10,
                      controller: titleCtl,
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          setState(() => titleError = "enter a title");
                        }
                      }),
                  if (titleError != "") error(titleError),
                  MyTextField(
                      labelText: "Name",
                      maxLength: 20,
                      controller: nameCtl,
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          setState(() => nameError = "enter a name");
                        }
                      }),
                  if (nameError != "") error(nameError),
                  MyTextField(
                      labelText: "Address",
                      controller: addressCtl,
                      validator: (value) {
                        if (value.toString().trim().length < 10) {
                          setState(() => addressError =
                              "address must be at least 10 char.");
                        }
                      }),
                  if (addressError != "") error(addressError),
                  MyTextField(
                      labelText: "Phone number",
                      type: TextInputType.phone,
                      controller: phoneCtl,
                      validator: (value) {
                        if (!Validations.validatePhone(phone: value)) {
                          setState(() => phoneError = "Invalid phone number");
                        }
                      },
                      maxLength: 11,
                      prefex: Text("+2 ", style: TextStyle(fontSize: 14))),
                  if (phoneError != "") error(phoneError),
                  SizedBox(
                    height: 20,
                  ),
                  Row(children: [
                    SizedBox(
                        width: (size.getWidth - 40) / 2,
                        height: size.getProportionateScreenHeight(60),
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel",
                                style: TextStyle(fontSize: 17)))),
                    SizedBox(
                      width: (size.getWidth - 40) / 2,
                      height: size.getProportionateScreenHeight(50),
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
                                loading = true;
                                if (validateForm()) {
                                  print(
                                      "---------validateForm is true -----------");
                                  authReadWrite.addAddress(
                                      title: titleCtl.text,
                                      address: addressCtl.text,
                                      name: nameCtl.text,
                                      phoneNum: phoneCtl.text);
                                  Navigator.of(context).pop();
                                }
                                loading = false;
                              },
                              child: Text(
                                "Add",
                                style: TextStyle(fontSize: 17),
                              )),
                    )
                  ]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget error(String txt) {
    return Padding(
        padding: EdgeInsets.only(left: 15),
        child: Text(
          txt,
          style: TextStyle(color: myPrimaryColor),
        ));
  }

  bool validateForm() {
    titleError = "";
    nameError = "";
    addressError = "";
    phoneError = "";
    globalKey.currentState?.validate();
    return (titleError == "" &&
        nameError == "" &&
        addressError == "" &&
        phoneError == "");
  }
}
