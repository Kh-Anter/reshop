import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/consts/constants.dart';
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
    return Scaffold(
      body: SafeArea(child: buildSplash(rootp)),
    );
  }

  buildSplash(rootp) {
    return StatefulBuilder(
      builder: (BuildContext context, subState) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Spacer(flex: 1),
          SizedBox(
            height: size.getHeight / 2,
            child: Column(children: [
              SizedBox(
                  height: size.getHeight / 2 - 40, child: pageView(subState)),
              SizedBox(height: 20),
              pageIndecator(subState)
            ]),
          ),
          Container(
            width: size.getWidth - 50,
            child: Column(children: [
              Text(Constants.splashScreen[currentIndex]["title"]!,
                  style: TextStyle(fontSize: 22)),
              Text(Constants.splashScreen[currentIndex]["subtitle"]!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: mySecondTextColor)),
            ]),
          ),
          Spacer(flex: 1),
          btn(rootp),
          Spacer(flex: 1)
        ]);
      },
    );
  }

  pageView(subState) {
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
            3,
            (index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(Constants.splashScreen[index]["image"]!),
            ),
          ),
        ));
  }

  pageIndecator(subState) {
    return SmoothPageIndicator(
        controller: pageViewCtrl,
        count: Constants.splashScreen.length,
        effect: ExpandingDotsEffect(
            dotWidth: 8,
            dotHeight: 8,
            spacing: 5,
            radius: 10,
            activeDotColor: myPrimaryColor,
            dotColor: myPrimaryLightColor));
  }

  btn(rootp) {
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
              currentIndex == Constants.splashScreen.length - 1
                  ? "Shop now"
                  : "Next",
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              if (currentIndex != Constants.splashScreen.length - 1) {
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
