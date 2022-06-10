import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  int _index = 0;
  String _btnText = "Next";
  @override
  Widget build(BuildContext context) {
    var _dummyData = Provider.of<DummyData>(context);
    switch (_currentPage) {
      case 0:
        {
          setState(() {
            _btnText = "Next";
          });
        }
        break;
      case 1:
        {
          setState(() {
            _btnText = "Next";
          });
        }
        break;
      case 2:
        {
          setState(() {
            _btnText = "Shop now";
          });
        }
        break;
    }

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
                        _dummyData.changePageview(value);
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                BuildDot(length: 3),
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
                width: _size.getProportionateScreenWidth(170),
                height: _size.getProportionateScreenHeight(60),
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(myPrimaryColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                    child: Text(
                      _btnText,
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      if (_currentPage < 2) {
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
