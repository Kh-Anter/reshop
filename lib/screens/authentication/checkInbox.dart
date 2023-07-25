import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/screens/authentication/auth_screen.dart';

class CheckInbox extends StatelessWidget {
  static const routeName = "/checkInbox";
  final String email;
  const CheckInbox({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          closeBtn(context),
          Spacer(flex: 1),
          Flexible(
            flex: 4,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
              child: Image.asset("assets/images/inbox2.png"),
            ),
          ),
          Text("Check your inbox",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 10),
          Text('We send a link to \n $email',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: myTextFieldBorderColor)),
          Spacer(flex: 2)
        ],
      ),
    );
  }

  Row closeBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AuthScreen()),
                (route) => false);
          },
        )
      ],
    );
  }
}
