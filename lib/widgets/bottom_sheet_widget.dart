import 'package:flutter/material.dart';
import '../constants.dart';
import '../size_config.dart';

class BottomSheetWidget extends StatefulWidget {
  static const routeName = "/BottomSheet";
  const BottomSheetWidget({Key key}) : super(key: key);

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  SizeConfig _size = SizeConfig();

  @override
  Widget build(BuildContext context) {
    print("---------------here");
    _size.init(context);
    return showBottomSheet();
  }

  showBottomSheet() {
    return;
  }
}
