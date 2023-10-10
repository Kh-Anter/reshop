import 'package:flutter/material.dart';

class SizeConfig {
  late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }

  get getWidth {
    if (orientation == Orientation.portrait) {
      return screenWidth;
    } else {
      return screenWidth / 1.5;
    }
  }

  get getHeight {
    return screenHeight;
  }

  get isLandscape {
    return orientation == Orientation.landscape;
  }

  get isTablete {
    return screenWidth > 800;
  }

  get getOriantation {
    return orientation;
  }

// Get the proportionate height as per screen size
  double getProportionateScreenHeight(double inputHeight) {
    double? screenHeight = SizeConfig.screenHeight;
    // 812 is the layout height that designer use
    return (inputHeight / 812.0) * screenHeight;
  }

// Get the proportionate height as per screen size
  double getProportionateScreenWidth(double inputWidth) {
    double screenWidth = SizeConfig.screenWidth;
    // 375 is the layout width that designer use
    return (inputWidth / 375.0) * screenWidth;
  }
}
