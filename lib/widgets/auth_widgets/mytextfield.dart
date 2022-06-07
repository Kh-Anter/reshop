import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/size_config.dart';
import '../../providers/auth.dart';

class MyTextField extends StatefulWidget {
  TextEditingController controller;
  String labelText;
  TextInputType type;
  var validator;

  MyTextField(
      {Key key, this.controller, this.labelText, this.type, this.validator})
      : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();

  initstate() {}
}

class _MyTextFieldState extends State<MyTextField> {
  bool isHidden = true;
  bool isPass = false;
  SizeConfig _sizeConfig = SizeConfig();
  FocusNode _focusNode = FocusNode();
  //String _controller = hint;
  bool isTaped = false;
  Color borderColor = Color.fromRGBO(239, 239, 239, 1);

  @override
  void initState() {
    // TODO: implement initState
    _focusNode.addListener(() {
      print('focusNode updated: hasFocus: ${_focusNode.hasFocus}');
      //_focusNode.dispose();
      setState(() {
        // isTaped = false;
        borderColor = Color.fromRGBO(239, 239, 239, 1);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context);
    if (widget.labelText == "Password" ||
        widget.labelText == "Repeat Password") {
      isPass = true;
    } else {
      isPass = false;
    }

    _sizeConfig.init(context);

    return Container(
        height: 60,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.only(left: 20, right: 10),
        decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 0.4),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color.fromRGBO(239, 239, 239, 1)),
        child: TextFormField(
          controller: widget.controller,
//autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: widget.type,
          obscureText: isPass ? (isHidden ? true : false) : false,
          validator: widget.validator,
          decoration: InputDecoration(
            fillColor: myTextFieldBackgroundColor,
            filled: true,
            labelText: widget.labelText,
            labelStyle: TextStyle(color: Colors.black45),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            suffix: isPass
                ? InkWell(
                    onTap: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                    child: Icon(isHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                  )
                : null,
          ),
          onTap: () {
            setState(() {
              borderColor = Color.fromRGBO(112, 112, 112, 1);
            });
          },
          onFieldSubmitted: (_) {
            setState(() {
              borderColor = Color.fromRGBO(239, 239, 239, 1);
              FocusManager.instance.primaryFocus?.unfocus();
            });
          },
          onChanged: (_) {
            setState(() {
              borderColor = Color.fromRGBO(112, 112, 112, 1);
            });
          },
          focusNode: _focusNode,
        ));
    ;
  }
}
