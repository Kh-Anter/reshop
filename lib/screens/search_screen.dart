import 'package:flutter/material.dart';
import 'package:reshop/constants.dart';
import 'package:reshop/size_config.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/SearchScreen";
  const SearchScreen({Key key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List recentSearch = [
    "All",
    "Smart Phones",
    "Women fashion",
    "Labtops",
    "Tools",
    "Cosmetics",
    "Men fashion"
  ];
  var selectedBtn = "";
  SizeConfig _size = SizeConfig();

  @override
  Widget build(BuildContext context) {
    _size.init(context);
    return Scaffold(
      appBar: myAppbar(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 15, left: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 15),
              child: Text(
                "Recent Search",
                style: TextStyle(color: myTextFieldBorderColor),
              ),
            ),
            createRecentSearch(),
          ]),
        ),
      )),
    );
  }

  AppBar myAppbar() {
    return AppBar(
      leadingWidth: 75,
      leading: IconButton(
        alignment: Alignment.bottomCenter,
        icon: Icon(
          Icons.arrow_back_ios,
          size: 26,
        ),
        onPressed: (() {
          Navigator.pop(context);
        }),
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          width: _size.getWidth - 70,
          padding: EdgeInsets.only(left: 10, right: 1),
          margin: EdgeInsets.only(top: 10, right: 15, left: 10),
          decoration: BoxDecoration(
              color: myTextFieldBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: TextField(
            onTap: () {},
            decoration: InputDecoration(
              hintText: "Search",
              icon: Icon(
                Icons.search,
                size: 24,
                color: myPrimaryColor,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
      elevation: 0,
    );
  }

  Widget createRecentSearch() {
    return Wrap(
        children:
            //[ for(i in recentSearch) ElevatedButton(
            // onPressed: () {}, child: Text(recentSearch[index])) ]  other solution
            List.generate(recentSearch.length, (index) {
      return Container(
        height: 35,
        margin: EdgeInsets.all(3),
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    selectedBtn == recentSearch[index]
                        ? myPrimaryColor
                        : elevatedBtnColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)))),
            onPressed: () {
              setState(() {
                selectedBtn = recentSearch[index];
              });
            },
            child: Text(recentSearch[index],
                style: selectedBtn != recentSearch[index]
                    ? TextStyle(color: mySecondTextColor)
                    : null)),
      );
    }));
  }
}
