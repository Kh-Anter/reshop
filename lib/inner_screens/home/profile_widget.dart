import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:provider/provider.dart';
import 'package:reshop/providers/authentication/auth_other.dart';
import 'package:reshop/screens/address.dart';
import 'package:reshop/screens/favourites.dart';
import 'package:reshop/screens/orders.dart';
import 'package:reshop/consts/size_config.dart';
import 'package:reshop/screens/setting_screen.dart';
import 'package:reshop/widgets/hero_images.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  Icon arrowIcon = Icon(Icons.arrow_forward_ios_outlined, size: 18);
  TextStyle listTiteStyle =
      TextStyle(color: myTextFieldBorderColor, fontSize: 16);
  SizeConfig size = SizeConfig();
  var authOther, auth;

  @override
  void initState() {
    callSizeConfig();
    super.initState();
  }

  void callSizeConfig() async {
    authOther = Provider.of<AuthOther>(context, listen: false);
    auth = FirebaseAuth.instance;
    await Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        size.init(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("------------profile rebuild-------------");
    size.init(context);
    var user = FirebaseAuth.instance.currentUser;
    return SizedBox(
      height: size.getHeight,
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          profiePic(user),
          SizedBox(
            height: 30,
          ),
          ListTile(
            leading: Icon(Icons.list_alt_outlined),
            title: Text("Orders", style: listTiteStyle),
            trailing: arrowIcon,
            onTap: () => Navigator.pushNamed(context, Orders.routeName),
          ),
          Divider(thickness: 2),
          ListTile(
            leading: Icon(Icons.favorite_outline),
            title: Text("Favourites", style: listTiteStyle),
            trailing: arrowIcon,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => FavouritesScreen())));
            },
          ),
          Divider(thickness: 2),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text("Addresses", style: listTiteStyle),
            trailing: arrowIcon,
            onTap: () => Navigator.of(context).pushNamed(Address.routeName),
          ),
          Divider(thickness: 2),
          ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text("Setting", style: listTiteStyle),
              trailing: arrowIcon,
              onTap: () => Navigator.of(context)
                  .pushNamed(SettingScreen.routeName)
                  .then((value) => setState(() {}))),
        ]),
      ),
    );
  }

  Widget profiePic(user) {
    return Row(
      children: [
        Selector<AuthOther, bool>(
            selector: (context, provider) => provider.profilePicState,
            builder: (_, value, child) {
              var user = FirebaseAuth.instance.currentUser;
              String imgUrl = user?.photoURL ?? "assets/images/profile.png";
              return InkWell(
                  onTap: () => Navigator.of(context)
                          .pushNamed(HeroImages.routeName, arguments: {
                        "images": [imgUrl],
                        "startIndex": 0,
                        "isProfile": true,
                        "title": user?.displayName
                      }),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: (user?.photoURL == null
                        ? AssetImage(imgUrl)
                        : NetworkImage(imgUrl)) as ImageProvider,
                    child: value
                        ? CircularProgressIndicator(color: Colors.grey)
                        : null,
                  ));
            }),
        SizedBox(
          width: 15,
        ),
        Flexible(
          // width: 100,
          child: Text(
            user?.displayName ?? "",
            style: TextStyle(fontSize: 22),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
