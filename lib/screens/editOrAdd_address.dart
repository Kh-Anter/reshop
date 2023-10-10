import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/models/address.dart';
import 'package:reshop/providers/address_provider.dart';
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
  var titleError = "";
  var nameError = "";
  var addressError = "";
  var phoneError = "";
  var cominAddress;
  var newAddress;
  String appBartitle = "Add new address";

  @override
  Widget build(BuildContext context) {
    var addressProvider = Provider.of<AddressProvider>(context, listen: false);
    var arg = ModalRoute.of(context)!.settings.arguments;
    if (arg != null) {
      appBartitle = "Edit address";
      cominAddress = arg as AddressModel;
      titleCtl.setText(cominAddress.title);
      nameCtl.setText(cominAddress.name);
      addressCtl.setText(cominAddress.address);
      phoneCtl.setText(cominAddress.phoneNum);
    }

    return Scaffold(
        appBar: appbar(context, appBartitle),
        body: WillPopScope(
          onWillPop: () => onWillPop(context, addressProvider),
          child: Container(
              height: size.getHeight,
              width: size.getWidth,
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: body(addressProvider)),
        ));
  }

  AppBar appbar(BuildContext context, String appBartitle) {
    return AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (() => Navigator.pop(context))),
        title: Text(appBartitle,
            style: TextStyle(color: Colors.black, fontSize: 22)));
  }

  Widget body(addressProvider) {
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    cancelBtn(context),
                    addOrSaveBtn(addressProvider, context)
                  ]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  SizedBox cancelBtn(BuildContext context) {
    return SizedBox(
        width: (size.getWidth - 40) / 2,
        height: size.getProportionateScreenHeight(60),
        child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel", style: TextStyle(fontSize: 17))));
  }

  SizedBox addOrSaveBtn(addressProvider, BuildContext context) {
    return SizedBox(
      width: (size.getWidth - 40) / 2,
      height: size.getProportionateScreenHeight(50),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(myPrimaryColor),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))),
          onPressed: () async {
            if (validateForm()) {
              newAddress = AddressModel(
                  address: addressCtl.text,
                  name: nameCtl.text,
                  title: titleCtl.text,
                  phoneNum: phoneCtl.text);
              if (cominAddress == null) {
                await addressProvider.addAddress(
                    newAddress: newAddress, context: context);
              } else {
                if (cominAddress == newAddress) {
                  return Navigator.of(context).pop();
                } else {
                  cominAddress.update(newAddress);
                  await addressProvider.editAddress(
                      // lastAddress: cominAddress,
                      newAddress: AddressModel(
                          title: titleCtl.text,
                          address: addressCtl.text,
                          name: nameCtl.text,
                          phoneNum: phoneCtl.text),
                      context: context);
                }
              }
            }
          },
          child: Text(
            cominAddress == null ? "Add" : "Save",
            style: TextStyle(fontSize: 17),
          )),
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

  Future<bool> onWillPop(context, provider) async {
    newAddress = AddressModel(
        address: addressCtl.text,
        name: nameCtl.text,
        title: titleCtl.text,
        phoneNum: phoneCtl.text);

    // on edit on an address:
    if (cominAddress != null) {
      print("------------<>>> comming !=null !");
      if (cominAddress == newAddress) {
        return true;
      } else {
        print("---------------<><<><>< comming != new !");
        return await goBackDialog(context, () async {
          cominAddress.update(newAddress);
          await provider
              .editAddress(newAddress: newAddress, context: context)
              .then((_) => Navigator.pop(context, true));
        });
      }
    }

    // if add a new address:
    else if (newAddress.isEmpty()) {
      return true;
    } else {
      return await goBackDialog(context, () {
        provider.addAddress(newAddress: newAddress, context: context);
      });
    }
  }

  Future<bool> goBackDialog(context, Function saveAction) async {
    print("==========>>>>>> in gobackDialog");
    return await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Notic"),
              content: Text("Ignor changes ?"),
              actions: [
                ElevatedButton(
                    onPressed: () => saveAction(), child: Text("Save")),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("ignor")),
              ],
            ));
  }
}
