import 'package:flutter/material.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/screens/favourites.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            CircleAvatar(
                radius: 50,
                child:
                    ClipOval(child: Image.asset("assets/images/profile.png"))),
            SizedBox(
              width: 15,
            ),
            Text(
              "Khaled anter",
              style: TextStyle(fontSize: 28),
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(Icons.add_reaction_sharp),
          title: Text(
            "Orders",
            style: TextStyle(color: myTextFieldBorderColor, fontSize: 18),
          ),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
          onTap: () {},
        ),
        Divider(thickness: 2),
        ListTile(
          leading: Icon(Icons.favorite_outline),
          title: Text(
            "Favourites",
            style: TextStyle(color: myTextFieldBorderColor, fontSize: 18),
          ),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => FavouritesScreen())));
          },
        ),
        Divider(thickness: 2),
        ListTile(
          leading: Icon(Icons.home_outlined),
          title: Text(
            "Addresses",
            style: TextStyle(color: myTextFieldBorderColor, fontSize: 18),
          ),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
          onTap: () {},
        ),
        Divider(thickness: 2),
        ListTile(
          leading: Icon(Icons.settings_outlined),
          title: Text(
            "Setting",
            style: TextStyle(color: myTextFieldBorderColor, fontSize: 18),
          ),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
          onTap: () {},
        ),
      ]),
    );
  }
}
