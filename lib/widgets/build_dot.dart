import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:reshop/constants.dart';
import '../providers/dummyData.dart';

class BuildDot extends StatefulWidget {
  int length;
  BuildDot({this.length, key}) : super(key: key);

  @override
  State<BuildDot> createState() => _BuildDotState();
}

class _BuildDotState extends State<BuildDot> {
  @override
  Widget build(BuildContext context) {
    var _dummyData = Provider.of<DummyData>(context);

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.length, (index) {
          return AnimatedContainer(
              duration: myAnimationDuration,
              margin: EdgeInsets.only(right: 3),
              width: _dummyData.currentPageView == index ? 22 : 10,
              height: 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _dummyData.currentPageView == index
                      ? myPrimaryColor
                      : myPrimaryLightColor));
        }));
  }
}
