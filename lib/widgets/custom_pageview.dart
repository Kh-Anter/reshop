// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/consts/size_config.dart';
import 'package:reshop/widgets/hero_images.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class CustomPageView extends StatefulWidget {
  final List<String> productImages;

  const CustomPageView({
    Key? key,
    required this.productImages,
  }) : super(key: key);
  static const routeName = "/productDetails";

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  SizeConfig size = SizeConfig();
  var pageViewCtrl = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    size.init(context);
    return Column(children: [
      pageView(),
      SizedBox(height: 10),
      pageIndecator(),
      SizedBox(height: 20)
    ]);
  }

  pageView() {
    return SizedBox(
        height: size.getProportionateScreenHeight(250),
        width: double.infinity,
        child: PageView(
          controller: pageViewCtrl,
          onPageChanged: (value) => setState(() {
            currentIndex = value;
          }),
          children: List.generate(
              widget.productImages.length,
              (index) => InkWell(
                    onTap: () => Navigator.of(context)
                        .pushNamed(HeroImages.routeName, arguments: {
                      "images": widget.productImages,
                      "startIndex": index
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FancyShimmerImage(
                        imageUrl: widget.productImages[index],
                        boxFit: BoxFit.contain,
                      ),
                    ),
                  )),
        ));
  }

  pageIndecator() {
    return SmoothPageIndicator(
        controller: pageViewCtrl,
        count: widget.productImages.length,
        effect: ExpandingDotsEffect(
            dotWidth: 8,
            dotHeight: 8,
            spacing: 5,
            radius: 10,
            activeDotColor: myPrimaryColor,
            dotColor: myPrimaryLightColor));
  }
}
