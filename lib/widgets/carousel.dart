import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:reshop/consts/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:reshop/providers/dummyData.dart';

class Carousel extends StatefulWidget {
  Carousel({Key? key}) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  var pageViewCtrl = PageController();
  int currentIndex = 0;
  Timer? changeCarusel;

  @override
  void initState() {
    changeCarusel = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentIndex < Constants.homeCarousel.length - 1) {
        currentIndex++;
        pageViewCtrl.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      } else {
        currentIndex = 0;
        pageViewCtrl.animateToPage(currentIndex,
            duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    changeCarusel!.cancel();
    pageViewCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pageView(),
        pageIndicator(),
      ],
    );
  }

  pageView() {
    return SizedBox(
        height: 200,
        width: double.infinity,
        child: PageView(
          controller: pageViewCtrl,
          onPageChanged: (value) => setState(() {
            currentIndex = value;
          }),
          children: List.generate(
              Constants.homeCarousel.length,
              (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(Constants.homeCarousel[index]),
                  )),
        ));
  }

  pageIndicator() {
    return SmoothPageIndicator(
        controller: pageViewCtrl,
        count: Constants.homeCarousel.length,
        effect: ExpandingDotsEffect(
            dotWidth: 8,
            dotHeight: 8,
            spacing: 5,
            radius: 10,
            activeDotColor: myPrimaryColor,
            dotColor: myPrimaryLightColor));
  }
}
