// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// / import 'package:provider/provider.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/consts/size_config.dart';
// import '../providers/auth_signup.dart';

class MyTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final TextInputType? type;
  final int? maxLength;
  final Widget? prefex;
  final dynamic validator;
  final dynamic parentState;
  final bool? isEnabled;
  final List<TextInputFormatter>? inputFormatters;

  const MyTextField({
    Key? key,
    this.controller,
    required this.labelText,
    this.type,
    this.maxLength,
    this.prefex,
    this.validator,
    this.parentState,
    this.inputFormatters,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();

  initstate() {}
}

class _MyTextFieldState extends State<MyTextField> {
  bool isHidden = true;
  bool isPass = false;
  SizeConfig sizeConfig = SizeConfig();
  FocusNode focusNode = FocusNode();
  //String _controller = hint;
  bool isTaped = false;
  Color borderColor = Color.fromRGBO(239, 239, 239, 1);

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {
        borderColor = Color.fromRGBO(239, 239, 239, 1);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.labelText.contains("Password")) {
      isPass = true;
    } else {
      isPass = false;
    }
    sizeConfig.init(context);
    return Container(
        height: 55,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.only(left: 17, right: 10),
        decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 0.4),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color.fromRGBO(239, 239, 239, 1)),
        child: TextFormField(
          enabled: widget.isEnabled,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          controller: widget.controller,
          keyboardType: widget.type,
          obscureText: isPass ? (isHidden ? true : false) : false,
          validator: widget.validator,
          decoration: InputDecoration(
              counterText: "",
              prefix: widget.prefex,
              fillColor: myTextFieldBackgroundColor,
              filled: true,
              labelText: widget.labelText,
              labelStyle: TextStyle(color: Colors.black45, fontSize: 14),
              border: InputBorder.none,
              suffix: isPass
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          isHidden = !isHidden;
                        });
                      },
                      child: Icon(isHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined))
                  : null),
        ));
  }
}
