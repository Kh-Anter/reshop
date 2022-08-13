import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reshop/constants.dart';
import 'package:provider/provider.dart';
import 'package:reshop/providers/auth_isloggedin.dart';
import 'package:reshop/providers/auth_other.dart';
import 'package:reshop/providers/auth_readwrite.dart';
import 'package:reshop/providers/auth_signup.dart';
import 'package:reshop/providers/dummyData.dart';
import 'package:reshop/screens/authentication/auth_screen.dart';
import 'package:reshop/screens/favourites.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  Icon arrowIcon = Icon(Icons.arrow_forward_ios_outlined, size: 18);
  TextStyle listTiteStyle =
      TextStyle(color: myTextFieldBorderColor, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<Auth_IsLoggedin>(context, listen: false);
    final auth_signup = Provider.of<Auth_SignUp>(context, listen: false);
    final auth_other = Provider.of<Auth_other>(context, listen: false);
    var auth = FirebaseAuth.instance;
    String imgUrl;
    String userName;
    var userProvider =
        FirebaseAuth.instance.currentUser.providerData[0].providerId;
    if (userProvider == 'google.com' || userProvider == 'facebook.com') {
      imgUrl = auth.currentUser.providerData[0].photoURL;
      userName = auth.currentUser.providerData[0].displayName;
    } else if (userProvider != null) {
      imgUrl = auth.currentUser.photoURL;
      userName = auth.currentUser.displayName;
    }
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: ClipOval(
                    // clipBehavior: Clip.hardEdge,
                    child: imgUrl != null
                        ? Image.network(imgUrl)
                        : Image.asset("assets/images/profile.png"))),
            SizedBox(
              width: 15,
            ),
            Text(userName != null ? userName : "",
                style: TextStyle(fontSize: 22))
          ],
        ),
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(Icons.add_reaction_sharp),
          title: Text("Orders", style: listTiteStyle),
          trailing: arrowIcon,
          onTap: () {},
        ),
        Divider(thickness: 2),
        ListTile(
          leading: Icon(Icons.favorite_outline),
          title: Text("Favourites", style: listTiteStyle),
          trailing: arrowIcon,
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => FavouritesScreen())));
          },
        ),
        Divider(thickness: 2),
        ListTile(
          leading: Icon(Icons.home_outlined),
          title: Text("Addresses", style: listTiteStyle),
          trailing: arrowIcon,
          onTap: () {},
        ),
        Divider(thickness: 2),
        ListTile(
          leading: Icon(Icons.settings_outlined),
          title: Text("Setting", style: listTiteStyle),
          trailing: arrowIcon,
          onTap: () {},
        ),
        Divider(thickness: 2),
        ListTile(
          leading: Icon(Icons.logout_outlined),
          title: Text("Logout", style: listTiteStyle),
          trailing: arrowIcon,
          onTap: () {
            isLoggedIn.logOut(context, auth_other);
          },
        )
      ]),
    );
  }
}
