import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/screens/category_screen/filter_bottomsheet.dart';
import 'package:reshop/screens/category_screen/sort_bottomsheet.dart';
import 'package:reshop/screens/search_screen.dart';
import 'package:reshop/widgets/product_card.dart';
import '../../providers/dummyData.dart';
import '../../consts/constants.dart';
import '../../consts/size_config.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = "/CategoryScreen";

  const CategoryScreen({Key? key}) : super(key: key);
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String title = "";
  bool hasSubCat = true;
  late String subCat;
  int selectedBtn = 0;
  late List all;
  late List other;

  SizeConfig size = SizeConfig();

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments;
    title = data.toString();
    if (title == "Best Sellers" || title == "LifeStyle Products") {
      hasSubCat = false;
    }
    size.init(context);
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(children: [
            buildTitle(),
            SizedBox(height: 10),
            if (hasSubCat) subCategory(),
            if (hasSubCat) SizedBox(height: 10),
            Container(
                height: hasSubCat ? size.getHeight - 220 : size.getHeight - 180,
                child: myGridView()),
          ]),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 26,
        ),
        onPressed: (() {
          Navigator.pop(context);
        }),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SearchScreen()));
          },
          label: Text(
            "Search",
            style: TextStyle(
                color: mySecondTextColor,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
          icon: Icon(Icons.search, size: 24),
        ),
      ],
      elevation: 0,
    );
  }

  Widget buildTitle() {
    return Row(children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 28,
        ),
      ),
      Spacer(),
      if (hasSubCat)
        IconButton(
            onPressed: () => filterBottomSheet(title),
            icon: Icon(Icons.filter_alt_outlined)),
      if (hasSubCat)
        IconButton(
            onPressed: () => sortButtomSheet(), icon: Icon(Icons.filter_list))
    ]);
  }

  subCategory() {
    subCat = Constants.subCategories[title].toString();
    return SizedBox(
      height: 45,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(5),
        children: List.generate(subCat.length, (index) {
          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: index != selectedBtn
                      ? MaterialStateProperty.all(
                          Color.fromRGBO(208, 208, 208, 1))
                      : null,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              child: Text(
                subCat[index],
                style: TextStyle(
                    color: index != selectedBtn
                        ? mySecondTextColor
                        : Colors.white),
              ),
              onPressed: () {
                setState(() {
                  selectedBtn = index;
                });
              },
            ),
          );
        }),
      ),
    );
  }

  myGridView() {
    var provider = Provider.of<DummyData>(context);
    if (hasSubCat) {
      if (selectedBtn == 0) {
        all = provider.getByCategory(title).toList();
      } else {
        other = provider.getBySubCat(subCat[selectedBtn]);
      }
    } else {
      if (title == "Best Sellers") {
        all = provider.bestSeller;
      } else {
        all = provider.lifeStyle;
      }
    }
    return GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: !hasSubCat
            ? all.length
            : selectedBtn == 0
                ? all.length
                : other.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.8,
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8),
        itemBuilder: (BuildContext context, int index) {
          return ProductCart(
            product: !hasSubCat
                ? all[index]
                : selectedBtn == 0
                    ? all[index]
                    : other[index],
          );
        });
  }

  filterBottomSheet(String title) {
    // var dummyData = Provider.of<DummyData>(context, listen: false);
    List<String> filterCategory = [];
    List<String> brand = [];
    brand = List.castFrom(Constants.brands);
    filterCategory.add(title);
    for (int i = 1; i < Constants.subCategories[title]!.length; i++) {
      filterCategory.add(Constants.subCategories[title]![i]);
    }
    return buttomSheet(
        FilterBottomSheet(category: filterCategory, brand: brand));
  }

  sortButtomSheet() {
    return buttomSheet(SortBottomSheet());
  }

  buttomSheet(type) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return type;
        });
  }
}
