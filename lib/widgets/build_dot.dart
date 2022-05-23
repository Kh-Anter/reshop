import 'package:flutter/material.dart';

import 'package:reshop/constants.dart';

class BuildDot {
  Widget buildDot(int currentPage) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedContainer(
              duration: myAnimationDuration,
              margin: EdgeInsets.only(right: 3),
              width: currentPage == index ? 22 : 10,
              height: 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: currentPage == index
                      ? myPrimaryColor
                      : myPrimaryLightColor));
        }));
  }
}
