import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/enums.dart';
import 'package:reshop/models/product.dart';
import 'package:reshop/screens/category_screen/filter_bottomsheet.dart';
import 'package:reshop/screens/category_screen/sort_bottomsheet.dart';
import 'package:reshop/screens/search_screen.dart';
import 'package:reshop/widgets/product_card.dart';

import '../../providers/dummyData.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../../widgets/bottom_sheet_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = "/CategoryScreen";
  String title = "";
  CategoryScreen({String title, Key key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var subCat;
  var selectedBtn = 0;
  var all;
  var other;
  //var selectedItem = "aaa";
  //var dropdownValue = 'One';
  SizeConfig _size = SizeConfig();

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context).settings.arguments;
    widget.title = data;
    _size.init(context);
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          title(),
          SizedBox(height: 10),
          subCategory(),
          SizedBox(height: 10),
          Container(height: _size.getHeight - 220, child: myGridView()),
        ]),
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

  Widget title() {
    return Row(children: [
      Text(
        widget.title,
        style: TextStyle(
          fontSize: 28,
        ),
      ),
      Spacer(),
      IconButton(
          onPressed: () => filterBottomSheet(widget.title),
          icon: Icon(Icons.filter_alt_outlined)),
      IconButton(
          onPressed: () => sortButtomSheet(), icon: Icon(Icons.filter_list))
    ]);
  }

  Widget subCategory() {
    var _dummyData = Provider.of<DummyData>(context, listen: false);
    TextStyle selectedBtnStyle = TextStyle(color: Colors.white);
    TextStyle unselectedBtnStyle = TextStyle(color: Colors.black26);
    subCat = _dummyData.subCategories[widget.title];
    return Container(
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

  Widget myGridView() {
    var provider = Provider.of<DummyData>(context);
    if (selectedBtn == 0) {
      all = provider.getByCategory(widget.title).toList();
    } else {
      other = provider.getBySubCat(all, subCat[selectedBtn]).toList();
    }
    return
        // Container(
        //   height: _size.getHeight,
        //   width: _size.getWidth,
        //   child:
        GridView.builder(
            scrollDirection: Axis.vertical,
            itemCount: selectedBtn == 0 ? all.length : other.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.8,
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8),
            itemBuilder: (BuildContext context, int index) {
              return ProductCart(
                product: all[index],
              );
            });
  }

  filterBottomSheet(String title) {
    var dummyData = Provider.of<DummyData>(context, listen: false);
    List<String> filterCategory = [];
    List<String> brand = [];
    brand = List.castFrom(dummyData.brands);
    filterCategory.add(title);
    for (int i = 1; i < dummyData.subCategories[title].length; i++) {
      filterCategory.add(dummyData.subCategories[title][i]);
    }
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return FilterBottomSheet(category: filterCategory, brand: brand);
        });
  }

  sortButtomSheet() {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return SortBottomSheet();
        });
  }
}
