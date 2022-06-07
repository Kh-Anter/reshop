import 'package:flutter/material.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/screens/authentication/auth_screen.dart';
import '../providers/dummyData.dart';
import '../widgets/build_dot.dart';
import '../size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);
  static String routeName = "/splashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  SizeConfig _size = SizeConfig();
  DummyData _dummyData = DummyData();
  int _index = 0;
  String _btnText = "Next";
  @override
  Widget build(BuildContext context) {
    _size.init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Spacer(flex: 1),
            Container(
              height: _size.getHeight / 2,
              child: Column(children: [
                Container(
                  height: _size.getHeight / 2 - 40,
                  child: PageView.builder(
                    itemBuilder: (context, index) {
                      _index = index;
                      return Image.asset(
                          _dummyData.splashScreen[index]["image"]);
                    },
                    itemCount: 3,
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        _currentPage = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                BuildDot().buildDot(_currentPage)
              ]),
            ),
            Container(
              width: _size.getWidth - 50,
              child: Column(children: [
                Text(_dummyData.splashScreen[_index]["title"],
                    style: TextStyle(fontSize: 22)),
                Text(_dummyData.splashScreen[_index]["subtitle"],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: mySecondTextColor)),
              ]),
            ),
            Spacer(flex: 1),
            Container(
                width: _size.getProportionateScreenWidth(120),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: myPrimaryColor),
                    child: Text(_btnText),
                    onPressed: () {
                      if (_pageController.page < 2) {
                        if (_pageController.page == 1 && _btnText == "Next") {
                          setState(() {
                            _btnText = "Shop now";
                          });
                        }
                        _pageController.nextPage(
                            duration: myAnimationDuration,
                            curve: Curves.decelerate);
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthScreen()),
                            ModalRoute.withName("/"));
                      }

                      //  System.out.printIn("");
                    })),
            Spacer(
              flex: 1,
            )
          ]),
        ),
      ),
    );
  }
}
