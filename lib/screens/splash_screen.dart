import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/providers/onboarding.dart';
import 'package:reshop/providers/root_provider.dart';
import 'package:reshop/screens/authentication/auth_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import '../providers/dummyData.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../consts/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static String routeName = "/splashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SizeConfig size = SizeConfig();
  var pageViewCtrl = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    size.init(context);
    var rootp = Provider.of<RootProvider>(context, listen: false);
    var onboarding = Provider.of<OnBoardingProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: FutureBuilder(
              future: onboarding.init(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return buildSplash(onboarding, rootp);
                }
              }),
        ),
      ),
    );
  }

  buildSplash(onboarding, rootp) {
    return StatefulBuilder(
      builder: (BuildContext context, subState) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Spacer(flex: 1),
          SizedBox(
            height: size.getHeight / 2,
            child: Column(children: [
              SizedBox(
                  height: size.getHeight / 2 - 40,
                  child: pageView(onboarding, subState)),
              SizedBox(height: 20),
              pageIndecator(onboarding, subState)
            ]),
          ),
          Container(
            width: size.getWidth - 50,
            child: Column(children: [
              Text(onboarding.allScreens[currentIndex].title,
                  style: TextStyle(fontSize: 22)),
              Text(onboarding.allScreens[currentIndex].description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: mySecondTextColor)),
            ]),
          ),
          Spacer(flex: 1),
          btn(onboarding, rootp),
          Spacer(flex: 1)
        ]);
      },
    );
  }

  pageView(onboarding, subState) {
    return SizedBox(
        height: size.getHeight / 2,
        width: double.infinity,
        child: PageView(
          controller: pageViewCtrl,
          onPageChanged: (value) => subState(() {
            currentIndex = value;
            pageViewCtrl.jumpToPage(value);
          }),
          children: List.generate(
            onboarding.allScreens.length,
            (index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: FancyShimmerImage(
                // shimmerDuration: Duration(milliseconds: 15),
                imageUrl: onboarding.allScreens[index].imgUrl,
                boxFit: BoxFit.contain,
              ),
            ),
          ),
        ));
  }

  pageIndecator(onboarding, subState) {
    return SmoothPageIndicator(
        controller: pageViewCtrl,
        count: onboarding.allScreens.length,
        effect: ExpandingDotsEffect(
            dotWidth: 8,
            dotHeight: 8,
            spacing: 5,
            radius: 10,
            activeDotColor: myPrimaryColor,
            dotColor: myPrimaryLightColor));
  }

  btn(onboarding, rootp) {
    return SizedBox(
        width: size.getProportionateScreenWidth(170),
        height: size.getProportionateScreenHeight(60),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(myPrimaryColor),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
            ),
            child: Text(
              currentIndex == onboarding.allScreens.length - 1
                  ? "Shop now"
                  : "Next",
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              if (currentIndex != onboarding.allScreens.length - 1) {
                pageViewCtrl.jumpToPage(currentIndex + 1);
              } else {
                rootp.localWriteAboutSplash();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                    ModalRoute.withName("/"));
              }
            }));
  }
}
