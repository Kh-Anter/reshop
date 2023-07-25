import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/providers/dummyData.dart';
import 'package:reshop/consts/size_config.dart';
import 'package:provider/provider.dart';
import 'package:reshop/widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/SearchScreen";
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var dummyData;
  List searchResult = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dummyData = Provider.of<DummyData>(context, listen: false);
  }

  TextEditingController searchCtl = TextEditingController();
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
  SizeConfig size = SizeConfig();

  @override
  Widget build(BuildContext context) {
    size.init(context);
    return Scaffold(
      appBar: myAppbar(),
      body: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: SingleChildScrollView(
          //  controller: controller,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 15),
              //height: 10,
              child: Text(
                "  Recent Search",
                style: TextStyle(color: myTextFieldBorderColor),
              ),
            ),
            createRecentSearch(),
            SizedBox(
              height: 15,
            ),
            if (searchResult.isNotEmpty)
              SizedBox(
                height: size.getHeight - 300,
                child: buildSearchResult(context),
              ),
          ]),
        ),
      ),
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
          onPressed: () => Navigator.pop(context)),
      actions: [
        Container(
          alignment: Alignment.center,
          width: size.getWidth - 70,
          padding: EdgeInsets.only(left: 10, right: 1),
          margin: EdgeInsets.only(top: 10, right: 15, left: 10),
          decoration: BoxDecoration(
              color: myTextFieldBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: TextField(
            controller: searchCtl,
            onChanged: (newVal) => search(),
            decoration: InputDecoration(
              hintText: "Search",
              icon: Icon(Icons.search, size: 24, color: myPrimaryColor),
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
                recent();
              });
            },
            child: Text(recentSearch[index],
                style: selectedBtn != recentSearch[index]
                    ? TextStyle(color: mySecondTextColor)
                    : null)),
      );
    }));
  }

  Widget buildSearchResult(context) {
    return GridView.builder(
        physics: ScrollPhysics(),
        //physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: searchResult.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.8,
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8),
        itemBuilder: (BuildContext context, int index) {
          return ProductCart(
            product: searchResult[index],
          );
        });
  }

  search() {
    var newKey = searchCtl.text.toString().trim();
    int len = dummyData.myProducts.length;
    List searchResult2 = [];
    if (newKey != "") {
      selectedBtn = "";
      for (int i = 0; i < len; i++) {
        if (dummyData.myProducts[i].title.contains(newKey) ||
            dummyData.myProducts[i].description.contains(newKey) ||
            dummyData.myProducts[i].subCat.contains(newKey)) {
          searchResult2.add(dummyData.myProducts[i]);
        }
      }
      searchResult = searchResult2;
    } else {
      searchResult = [];
    }
    setState(() {});
  }

  recent() {
    int len = dummyData.myProducts.length;
    List searchResult2 = [];
    if (selectedBtn != "") {
      if (selectedBtn == "All") {
        searchResult = dummyData.myProducts;
      } else {
        for (int i = 0; i < len; i++) {
          if (dummyData.myProducts[i].subCat == selectedBtn) {
            searchResult2.add(dummyData.myProducts[i]);
          }
        }
        searchResult = searchResult2;
      }
    } else {
      searchResult = [];
    }
    setState(() {});
  }
}
